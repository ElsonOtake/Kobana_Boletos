class Boleto
  require 'uri'
  require 'net/http'
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
      boletos << Boleto.new(bank_billet.attributes.slice(*Boleto.attribute_names))
    end
    boletos
  end

  def create
    self.expire_at = self.first_week_day(self.expire_at)
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
    self.id = boleto.id unless boleto.id.nil?
    self.status = boleto.status unless defined?(boleto.status).nil?
    self.response_errors = boleto.response_errors.to_json
    self
  end

  def update(id)
    self.id = id
    self.expire_at = self.first_week_day(self.expire_at)
    url = URI("https://api-sandbox.kobana.com.br/v1/bank_billets/#{id}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["authorization"] = "Bearer #{ENV['BOLETOSIMPLES_API_TOKEN']}"
    body = self.attributes.select { |key| ["amount", "expire_at"].include? key }
    request.body = body.to_json
    response = http.request(request)
    if response.code == "204"
      self.response_errors = "{}"
    else
      self.response_errors = JSON.parse(response.body)["errors"].to_json
    end
  end
  
  def errors_empty?
    JSON.parse(self.response_errors).empty?
  end

  def persisted?
    !self.id.nil?
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
      self
    rescue => error
      add_message(error.message)
    end
  end

  def cancel(id)
    begin
      boleto = BoletoSimples::BankBillet.cancel(id: id)
      self.response_errors = boleto.response_errors.to_json
      self
    rescue => error
      add_message(error.message)
    end
  end

  private

  def add_message(message)
    erro = Boleto.new
    erro.response_errors = [Hash[:title, message]].to_json
    erro
  end

  def first_week_day(date)
    date.on_weekday? ? date : (date + 2).beginning_of_week
  end
end