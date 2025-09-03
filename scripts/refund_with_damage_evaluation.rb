namespace :custom_tasks do
  desc "ES_6282_refund_security_deposit_with_damage_evaluation"
  task ES_6282_refund_security_deposit_with_damage_evaluation: :environment do
    repository = App::Model::UnitSecurityFormRepository.new(EFrame::Iam.system_context)
    unit_security_form_service = App::Services::UnitSecurityFormService.new(EFrame::Iam.system_context)
    inspection_request_repo = App::Model::InspectionRequestRepository.new(EFrame::Iam.system_context)

    input_params = ['9aa62cdd-8d62-45df-b88d-daebde4ad9b2','028a1727-856b-4ab7-8f84-64076586ce39','039d0e99-560d-48a8-bf28-fb2a54618db7','32dbf0b4-874d-4e2f-bce4-9cf39325e901','6829cad3-7d4f-4e80-b753-d4561ac80ac0','e99a6ac7-a25a-4e46-954b-c9185af22ce7','7960c6f7-02cc-4125-8208-8545d6807f06','23f22aea-eea9-4c35-b127-e6ee290132df','89877cc8-72a0-4e16-91dc-9d623939c8b6','71b75b6d-f4b0-416d-9b6c-333b4ea303c4','5ddc1498-e325-4a2f-b000-882f12dc8004','9e0cad72-59a7-446b-aff3-14582b305a1c','a3d08da9-41a9-4c0d-ba82-747ffcdaed83','45312363-c9c2-4963-9529-8d42c6f2a7f1','7a331053-b4ce-42a7-a126-fd441eef268f','f3a7b3f8-713e-4fae-abfe-ec79f863e36e','f327fdb5-01de-4c6e-8a87-fe7d38911b33','fcd04c6e-1282-4b59-a4ac-ef40e6690133','8c9e66ea-a34c-43b1-83b3-e4236306c81d','b7412ae1-d4f7-44bf-a288-45779fe06500','7fa09a2f-4f44-4db4-976f-9a648b75d1f7','be1825b8-c2f7-4d28-828b-133608cf7834','887218c7-c456-4277-b240-6695c5633f9c','ba33ac62-7040-4d7e-b6e7-e9eb3530ca4a']

    done_cases = []
    undone_cases = []

    input_params.each do |contract_id|
      puts "\n[MIMO] Processing contract ID: #{contract_id}"
      
      # Find the form for this contract
      form = repository.find_by({ contract_id: contract_id })
      # form = repository.find_by({ contract_number: contract_id })
      contract_id = form&.contract_id
      contract_number = form&.contract_number

      if form.nil?
        puts "[MIMO] No form found for contract ID: #{contract_id}"
        undone_cases.push([form.security_deposit_invoice_number, "No form found for contract ID: #{contract_id}"])
        next
      end

      puts "[MIMO] Found form with ID: #{form.id}"
      puts "[MIMO] Current MI status: #{form.mi_status || 'nil'}, MO status: #{form.mo_status || 'nil'}"

      auto_renewal = false
      # skip if form is manual contract cloned form
      if form.previous_form_id
        auto_renewal = repository.find_by({
          id: form.previous_form_id,
          contract_number: form.contract_number
        }).present?

        return unless auto_renewal
      end

      if form.mo_status == 'expired' || form.mo_status == 'done'
        unless form.security_deposit_invoice_number
          puts "[MIMO] No security deposit invoice number found for contract number: #{contract_number}"
          undone_cases.push([form.security_deposit_invoice_number, "No security deposit invoice number found to refund. Parties already responded to MO form"])
          next
        end

        if form.mo_damage_amount_by_lessor.present? || form.mo_damage_amount_by_tenant.present?
          if form.mo_damage_amount_by_lessor != form.mo_damage_amount_by_tenant
            puts "******** Damage amount must be equal *********"
            undone_cases.push([form.security_deposit_invoice_number, "Damage amount must be equal"])
            next
          end
        end

        new_form = repository.find_by({ previous_form_id: form.id })

        if !new_form&.is_archived_form && %w(registered active).include?(form&.contract_state)
          puts "[MIMO] Contract state is registered or active so not refund"
          undone_cases.push([form.security_deposit_invoice_number, "Contract state is registered or active so not refund"])
          next
        end

        inspection_request = inspection_request_repo.find_by({unit_security_form_id: form.id})

        if inspection_request.present? && inspection_request.integration? && inspection_request.closed_completed?
          expert_damage_evaluation = inspection_request.expert_damage_evaluation
          puts "[MIMO] Completed Inspection request found for form ID with damage evaluation: #{expert_damage_evaluation}"
        elsif inspection_request.present?
          puts "[MIMO] Inspection request found for form ID but not closed or completed: #{form.id}"
          undone_cases.push([form.security_deposit_invoice_number, "Inspection request found for form ID but not closed or completed"])
          next
        else
          puts "[MIMO] No inspection request found for form ID: #{form.id}"
          expert_damage_evaluation = nil
        end

        refund_handler = App::Services::RefundService.new(form: form, expert_damage_evaluation: expert_damage_evaluation)
        puts "[MIMO] Expert damage evaluation: #{refund_handler.expert_damage_evaluation}"
        refund_handler.expert_damage_evaluation

        next if refund_handler.expert_damage_evaluation

        puts "[MIMO] Refund amount: #{refund_handler.refund_amount}"
        refund_handler.refund_amount

        refund_call = refund_handler.call

        if refund_call
          App::Services::SmsService.new(form: form).call
          puts "[MIMO] Refund SMS sent for contract number: #{contract_number}"

          done_cases.push(form.security_deposit_invoice_number)
        end
      end

      Workers::UnitSecurityForms::UpdateCoreContract.perform_in(0.seconds, form.id)

      if !auto_renewal
        Workers::UnitSecurityForms::UpdateCloneForm.perform_in(0.seconds, form.id)
      end
    end

    puts "REFUNDED CASES START"
    pp done_cases.join("\n")
    puts "REFUNDED CASES END"

    puts "UNDONE CASES START"
    pp undone_cases.join("\n")
    puts "UNDONE CASES END"
  end
end