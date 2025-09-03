input_params = [2408276071907,2408196049157,2408262504159,2408154319244,2410223632652,2410223356307,2410229620817,2410227629596,2410221882690,2409021924116,2412030922614,2410150530854,2410150530854,2410150530854]

result = []

input_params.each do |invoice_number|
  invoice_details = Infra::Services::Azm::InvoiceService.get_invoice(internal_invoice_no: invoice_number)

  result.push(
    {
      contract_id: invoice_details['oivanContractId'],
      invoice_number: invoice_number.to_s,
      lessor_id_number: invoice_details['beneficiaryFrom'],
      tenant_id_number: invoice_details['beneficiaryTo'],
    }
  )
end

puts "result START"
STDOUT.write(JSON.generate(result))   # compact, one line
puts "result END"