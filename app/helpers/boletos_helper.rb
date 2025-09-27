module BoletosHelper
  def display(field, value)
    case field
    when "amount"
      number_to_currency(value.to_f, unit: "")
    when "customer_cnpj_cpf"
      format_cpf_cnpj(value)
    when "customer_zipcode"
      "#{value[0, 5]}-#{value[5, 3]}"
    when "status"
      value.capitalize
    else
      value
    end
  end

  def error_border(errors, field)
    errors.has_key?(field) ? "input is-danger" : "input is-info"
  end

  def format_cpf_cnpj(document)
    return "" if document.blank?

    numbers_only = document.to_s.gsub(/\D/, '')

    if numbers_only.length == 11
      # Format CPF: 000.000.000-00
      "#{numbers_only[0,3]}.#{numbers_only[3,3]}.#{numbers_only[6,3]}-#{numbers_only[9,2]}"
    elsif numbers_only.length == 14
      # Format CNPJ: 00.000.000/0000-00
      "#{numbers_only[0,2]}.#{numbers_only[2,3]}.#{numbers_only[5,3]}/#{numbers_only[8,4]}-#{numbers_only[12,2]}"
    else
      document
    end
  end
end
