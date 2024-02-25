class Boleto
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer, default: nil
  attribute :amount, :float, default: nil
  attribute :expire_at, :date, default: nil
  attribute :customer_person_name, :string, default: nil
  attribute :customer_cnpj_cpf, :string, default: nil
  attribute :customer_state, :string, default: nil
  attribute :customer_city_name, :string, default: nil
  attribute :customer_zipcode, :string, default: nil
  attribute :customer_address, :string, default: nil
  attribute :customer_neighborhood, :string, default: nil
  attribute :status, :string, default: nil
end