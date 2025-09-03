namespace :custom_tasks do
  desc "ES_5879_rectify_parties_ids"
  task ES_5879_rectify_parties_ids: :environment do
    repository = App::Model::UnitSecurityFormRepository.new(EFrame::Iam.system_context)

    input_params = [{
    'contract_id': '7a331053-b4ce-42a7-a126-fd441eef268f',
    'invoice_number': '2408276071907',
    'lessor_id_number': '1003178140',
    'tenant_id_number': '2166525515'
  },
  {
    'contract_id': '90580b62-903e-4a5a-8ce4-918e99d1a3cc',
    'invoice_number': '2408196049157',
    'lessor_id_number': '1067768802',
    'tenant_id_number': '1039634074'
  },
  {
    'contract_id': 'f3a7b3f8-713e-4fae-abfe-ec79f863e36e',
    'invoice_number': '2408262504159',
    'lessor_id_number': '1044517546',
    'tenant_id_number': '1097712994'
  },
  {
    'contract_id': 'f327fdb5-01de-4c6e-8a87-fe7d38911b33',
    'invoice_number': '2408154319244',
    'lessor_id_number': '1096065741',
    'tenant_id_number': '2281860193'
  },
  {
    'contract_id': 'fcd04c6e-1282-4b59-a4ac-ef40e6690133',
    'invoice_number': '2410223632652',
    'lessor_id_number': '1099009084',
    'tenant_id_number': '1099988295'
  },
  {
    'contract_id': '8c9e66ea-a34c-43b1-83b3-e4236306c81d',
    'invoice_number': '2410223356307',
    'lessor_id_number': '1099009084',
    'tenant_id_number': '1099988295'
  },
  {
    'contract_id': 'b7412ae1-d4f7-44bf-a288-45779fe06500',
    'invoice_number': '2410229620817',
    'lessor_id_number': '1099009084',
    'tenant_id_number': '1099988295'
  },
  {
    'contract_id': '7fa09a2f-4f44-4db4-976f-9a648b75d1f7',
    'invoice_number': '2410227629596',
    'lessor_id_number': '1099009084',
    'tenant_id_number': '1099988295'
  },
  {
    'contract_id': 'be1825b8-c2f7-4d28-828b-133608cf7834',
    'invoice_number': '2410221882690',
    'lessor_id_number': '1099009084',
    'tenant_id_number': '1099988295'
  },
  {
    'contract_id': '887218c7-c456-4277-b240-6695c5633f9c',
    'invoice_number': '2409021924116',
    'lessor_id_number': '1031002841',
    'tenant_id_number': '2535988683'
  },
  {
    'contract_id': 'ba33ac62-7040-4d7e-b6e7-e9eb3530ca4a',
    'invoice_number': '2412030922614',
    'lessor_id_number': '1013264708',
    'tenant_id_number': '1134150059'
  },
  {
    'contract_id': '926cdca1-7274-4711-b1ad-b20c251725b2',
    'invoice_number': '2410150530854',
    'lessor_id_number': '1067015725',
    'tenant_id_number': '1022692956'
  },
  {
    'contract_id': '926cdca1-7274-4711-b1ad-b20c251725b2',
    'invoice_number': '2410150530854',
    'lessor_id_number': '1067015725',
    'tenant_id_number': '1022692956'
  },
  {
    'contract_id': '926cdca1-7274-4711-b1ad-b20c251725b2',
    'invoice_number': '2410150530854',
    'lessor_id_number': '1067015725',
    'tenant_id_number': '1022692956'
  }]

    rectified_cases = []

    input_params.each do |params|
      invoice_number = params[:invoice_number]
      contract_id = params[:contract_id]
      lessor_id_number = params[:lessor_id_number]
      tenant_id_number = params[:tenant_id_number]

      form = repository.find_by({contract_id: contract_id})

      if form.nil?
        puts "Form not found for invoice number: #{invoice_number} and contract id: #{contract_id}"
        next
      end

      mismatched = form.lessor_id_number != lessor_id_number

      if mismatched
        repository.update!(form.id, {lessor_id_number: lessor_id_number})
        puts "Rectified lessor id: #{form.id}"
        rectified_cases.push(invoice_number)
      else
        puts "Lessor id is already correct"
      end

      if form.nil?
        puts "Form not found for invoice number: #{invoice_number} and contract id: #{contract_id}"
        next
      end

      mismatched = form.tenant_id_number != tenant_id_number

      if mismatched
        repository.update!(form.id, {tenant_id_number: tenant_id_number})
        puts "Rectified tenant id: #{form.id}"
        rectified_cases.push(invoice_number)
      else
        puts "Tenant id is already correct"
      end
    end

    puts "RECTIFIED_CASES START"
    puts rectified_cases.join("\n")
    puts "RECTIFIED_CASES END"
  end
end



