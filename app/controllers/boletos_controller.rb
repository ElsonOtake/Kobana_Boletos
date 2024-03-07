class BoletosController < ApplicationController
  before_action :set_boleto, only: %i[ edit show cancel ]
  
  def index
    @boletos = Boleto.new.all
  end

  def show
  end

  def new
    @boleto = Boleto.new
    @cities = []
  end

  def cancel
  end

  def edit
    @cities = CS.cities(@boleto.customer_state, :BR)
  end

  def create
    @boleto= Boleto.new(boleto_params)
    @boleto.create
    
    respond_to do |format|
      if @boleto.persisted?
        format.html { redirect_to root_path, notice: t(:successfully_created) }
        format.turbo_stream { flash.now[:notice] = t(:successfully_created) }
      else
        @cities = CS.cities(boleto_params[:customer_state], :BR)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def cancel_by_id
    boleto = Boleto.new.cancel(params[:id])
    respond_to do |format|
      if boleto.persisted?
        @id = params[:id]
        format.html { redirect_to root_path, notice: t(:successfully_canceled) }
        format.turbo_stream { flash.now[:notice] = t(:successfully_canceled) }
      else
        @id = nil
        message = JSON.parse(boleto.response_errors).first.with_indifferent_access[:title]
        format.html { redirect_to root_path, notice: message, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:notice] = message }      
      end
    end
  end

  private

  def set_boleto
    @boleto = Boleto.new.find(params[:id])
    unless @boleto.persisted?
      respond_to do |format|
        message = JSON.parse(@boleto.response_errors).first.with_indifferent_access[:title]
        format.html { redirect_to root_path, notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    end
  end

  def boleto_params
    params.require(:boleto).permit(:amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state,
                                   :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood)
  end
end
