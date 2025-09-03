input_params = [2408276071907,2408196049157,2408262504159,2408154319244,2410223632652,2410223356307,2410229620817,2410227629596,2410221882690,2409021924116,2412030922614,2410150530854,2410150530854,2410150530854]

invoice_service = Infra::Services::Azm::InvoiceService

draft_invoices = []
approved_invoices = []
closed_invoices = []
refunded_invoices = []

input_params.each do |invoice_number|
  puts "********************** Invoice_number: #{invoice_number} *************************" 

  invoice_data = Infra::Services::Azm::InvoiceService.get_invoice(
    internal_invoice_no: invoice_number
  )

  if invoice_data['statusCode'] == 'drft'
    draft_invoices.push(invoice_number)
  end

  if invoice_data['statusCode'] == 'apvd'
    approved_invoices.push(invoice_number)
  end

  if invoice_data['statusCode'] == 'clos'
    closed_invoices.push(invoice_number)
  end

  if invoice_data['statusCode'] == 'refunded'
    refunded_invoices.push(invoice_number)
  end
end

puts "DRAFT_INVOICES START"
puts draft_invoices.join("\n")
puts "DRAFT_INVOICES END"

puts "APPROVED_INVOICES START"
puts approved_invoices.join("\n")
puts "APPROVED_INVOICES END"

puts "CLOSED_INVOICES START"
puts closed_invoices.join("\n")
puts "CLOSED_INVOICES END"

puts "REFUNDED_INVOICES START"
puts refunded_invoices.join("\n")
puts "REFUNDED_INVOICES END"


