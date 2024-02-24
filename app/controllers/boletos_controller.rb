class BoletosController < ApplicationController
  before_action :set_boleto, only: %i(edit show)
  Required = %i(amount expire_at customer_person_name customer_cnpj_cpf customer_state customer_city_name 
                customer_zipcode customer_address customer_neighborhood)
  def index
    @billets = []
    bank_billets = BoletoSimples::BankBillet.all
    bank_billets.each do |bank_billet|
      @billets << bank_billet.attributes.slice(:id, :status, *Required)
    end
  end

  def edit
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

    respond_to do |format|
      if @bank_billet.save
        # if @bank_billet.persisted?
        @billet = @bank_billet.attributes.slice(:id, :status, *Required)
        format.html { redirect_to root_path }
        format.turbo_stream
      else
        puts "Erro :(#{@bank_billet.response_errors})"
        render :new
      end
    end
  end

  def update
    cancel = BoletoSimples::BankBillet.cancel(id: params[:id])
    respond_to do |format|
      if cancel.response_errors.empty?
        @billet = BoletoSimples::BankBillet.find(params[:id]).attributes.slice(:id, :status, *Required)
        format.html { redirect_to root_path }
        format.turbo_stream
      else
        puts "Erro :(#{cancel.response_errors})"
        render :edit
      end
    end
  end

  private

  def set_boleto
    begin
      @bank_billet = BoletoSimples::BankBillet.find(params[:id])
    rescue => error
      puts error.message
    end
  end

  def boleto_params
    params.require(:boleto).permit(*Required)
  end
end
