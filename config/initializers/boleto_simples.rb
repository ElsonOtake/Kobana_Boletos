require 'boletosimples'

BoletoSimples.configure do |c|
  # c.environment = :production # defaut :sandbox
  # production - https://app.kobana.com.br/conta/api/tokens
  # sandbox - https://app-sandbox.kobana.com.br/conta/api/tokens
  c.api_token = ENV['BOLETOSIMPLES_API_TOKEN']
  c.user_agent = 'elsonotake@gmail.com' #Colocar um e-mail válido para contatos técnicos relacionado ao uso da API.
  # c.debug = true
  # c.custom_headers = { 'X-CUSTOM' => 'CONTENT' }
end