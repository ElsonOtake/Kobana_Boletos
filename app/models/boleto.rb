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

  def all
    boletos = []
    bank_billets = BoletoSimples::BankBillet.all
    bank_billets.each do |bank_billet|
      boletos << bank_billet.attributes.slice(*Boleto.attribute_names)
    end
    boletos
  end

  def create
    boleto = BoletoSimples::BankBillet.create(
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
    self.id = boleto.id
    self.status = boleto.status
    self.response_errors = boleto.response_errors.to_json
    self
  end
  
  def persisted?
    JSON.parse(self.response_errors).empty?
  end

  def find(id)
    begin
      boleto = BoletoSimples::BankBillet.find(id)
      self.id = boleto.id
      self.amount = boleto.amount
      self.expire_at = boleto.expire_at
      self.customer_person_name = boleto.customer_person_name
      self.customer_cnpj_cpf = boleto.customer_cnpj_cpf
      self.customer_state = boleto.customer_state
      self.customer_city_name = boleto.customer_city_name
      self.customer_zipcode = boleto.customer_zipcode
      self.customer_address = boleto.customer_address
      self.customer_neighborhood = boleto.customer_neighborhood
      self.status = boleto.status
      self.response_errors = boleto.response_errors.to_json
      self.attributes.with_indifferent_access
    rescue => error
      error.message
    end
  end

  def cancel(id)
    boleto = BoletoSimples::BankBillet.cancel(id: id)
    self.response_errors = boleto.response_errors.to_json
    self
  end
end