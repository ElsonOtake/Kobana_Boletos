class BoletosController < ApplicationController

  Required = %i(amount expire_at customer_person_name customer_cnpj_cpf customer_state customer_city_name 
                customer_zipcode customer_address customer_neighborhood)
  def index
    # Listar os boletos
    @billets = []
    bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)
    bank_billets.each do |bank_billet|
      @billets << bank_billet.attributes.slice(*Required)
    end
  end

  def new

  end

  def show
  end

  def create
    @bank_billet = BoletoSimples::BankBillet.new()
    @bank_billet.amount = boleto_params[:amount]
    @bank_billet.expire_at = boleto_params[:expire_at]
    @bank_billet.customer_address = boleto_params[:customer_address]
    @bank_billet.customer_city_name = boleto_params[:customer_city_name]
    @bank_billet.customer_cnpj_cpf = boleto_params[:customer_cnpj_cpf]
    @bank_billet.customer_neighborhood = boleto_params[:customer_neighborhood]
    @bank_billet.customer_person_name = boleto_params[:customer_person_name]
    @bank_billet.customer_state = boleto_params[:customer_state]
    @bank_billet.customer_zipcode = boleto_params[:customer_zipcode]
    @bank_billet.save

    if @bank_billet.persisted?
      redirect_to root_path
    else
      puts "Erro :(#{@bank_billet.response_errors})"
      redirect_to root_path
    end
  end

  def cancel
  end

  private

  def boleto_params
    params.require(:boleto).permit(*Required)
  end
end
