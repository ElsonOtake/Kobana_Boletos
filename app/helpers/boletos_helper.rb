module BoletosHelper
  def display(field, value)
    case field
    when "amount"
      number_to_currency(value.to_f, unit: "")
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
end
