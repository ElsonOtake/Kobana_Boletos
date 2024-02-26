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
  attribute :response_errors, :string, default: "{}"

  def create
    bank_billet = BoletoSimples::BankBillet.create(
      amount: self.amount,
      expire_at: self.expire_at,
      customer_person_name: self.customer_person_name,
      customer_cnpj_cpf: self.customer_cnpj_cpf,
      customer_state: self.customer_state,
      customer_city_name: self.customer_city_name,
      customer_zipcode: self.customer_zipcode,
      customer_address: self.customer_address,
      customer_neighborhood: self.customer_neighborhood
      )
    self.id = bank_billet.id
    self.status = bank_billet.status
    self.response_errors = bank_billet.response_errors.to_json
  end
  
  def persisted?
    JSON.parse(self.response_errors).empty?
  end

  def find(id)
    begin
      BoletoSimples::BankBillet.find(id)
    rescue => error
      error.message
    end
  end
end