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

  def t(field)
    traducao = {
      "id" => "Id",
      "amount" => "Valor",
      "expire_at" => "Vencimento",
      "customer_person_name" => "Nome",
      "customer_cnpj_cpf" => "CNPJ/CPF",
      "customer_state" => "Estado",
      "customer_city_name" => "Cidade",
      "customer_zipcode" => "CEP",
      "customer_address" => "Endereço",
      "customer_neighborhood" => "Bairro",
      "status" => "Situação"
    }.with_indifferent_access
    traducao[field]
  end
end
