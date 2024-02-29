<a name="readme-top"></a>

<!-- TABLE OF CONTENTS -->

# 📗 Tabela de conteúdo

- [📖 Sobre o projeto](#about-project)
  - [🛠 Construído com](#built-with)
    - [Tech Stack](#tech-stack)
    - [Características principais](#key-features)
  - [🚀 Live Demo](#live-demo)
- [💻 Primeiros Passos](#getting-started)
  - [Pré-requisitos](#prerequisites)
  - [Configuração](#setup)
  - [Instalação](#install)
  - [Utilização](#usage)
  - [Executar testes](#run-tests)
- [👥 Autor](#authors)
- [🔭 Recursos futuros](#future-features)
- [🤝 Contribuição](#contributing)
- [⭐️ Mostre seu apoio](#support)
- [🙏 Agradecimentos](#acknowledgements)
- [📝 Licença](#license)

<!-- PROJECT DESCRIPTION -->

# 📖 Kobana_Boletos <a name="about-project"></a>

**Kobana_Boletos** é um CRUD de gestão de boletos. É possível listar boletos, criar novos boletos, apresentar dados de um boleto e cancelar um boleto aberto. Os boletos são criados realizando a integração do projeto Rails com a [API da Kobana em Sandbox](https://developers.kobana.com.br/reference/visao-geral). O form de criação possui somente os campos obrigatórios da API. Testes cobrindo o que foi desenvolvido foram criados.


## 🛠 Construído com <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Cliente</summary>
  <ul>
    <li><a href="https://rubyonrails.org/">Ruby on Rails</a></li>
  </ul>
</details>

<details>
  <summary>Servidor</summary>
  <ul>
    <li><a href="https://github.com/BoletoSimples/boletosimples-ruby">BoletoSimples</a></li>
    <li><a href="https://bulma.io/">Bulma</a></li>
    <li><a href="https://github.com/teamcapybara/capybara">Capybara</a></li>
    <li><a href="https://github.com/thecodecrate/city-state">City-State</a></li>
    <li><a href="https://github.com/petergoldstein/dalli">Dalli</a></li>
    <li><a href="https://github.com/bkeepers/dotenv">Dotenv</a></li>
    <li><a href="https://stimulus.hotwired.dev/">Stimulus</a></li>
    <li><a href="https://github.com/hotwired/turbo-rails">Turbo Rails</a></li>
  </ul>
</details>

<!-- Features -->

### Características principais <a name="key-features"></a>

- **[ActiveModel::Attributes](https://api.rubyonrails.org/classes/ActiveModel/Attributes.html)**


<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- LIVE DEMO -->

## 🚀 Live Demo <a name="live-demo"></a>

- []()

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- GETTING STARTED -->

## 💻 Primeiros Passos <a name="getting-started"></a>

Para obter uma cópia local instalada e funcionando, siga estas etapas.

### Pré-requisitos

Para executar este projeto você precisa de:

[Ruby](https://www.ruby-lang.org/en/)

### Configuração

Clone este repositório na pasta desejada:

usando HTTPS:
```sh
  git clone https://github.com/ElsonOtake/Kobana_Boletos.git
  cd Kobana_Boletos
```

usando uma chave SSH:
```sh
  git clone git@github.com:ElsonOtake/Kobana_Boletos.git
  cd Kobana_Boletos
```

usando GitHub CLI:
```sh
  git clone gh repo clone ElsonOtake/Kobana_Boletos
  cd Kobana_Boletos
```

### Instalação

Preencha as variáveis de ambiente
```sh
  BOLETOSIMPLES_API_TOKEN=BOLETOSIMPLES_API_TOKEN
```

Instale este projeto com:
```sh
  bundle install
  npm install
```

### Utilização

Para executar o projeto, execute o seguinte comando:

```sh
  bin/dev
```
Abra `http://localhost:3000/` no seu navegador.

### Executar testes

Para executar testes, execute os seguintes comandos:

```sh
  rails test test/models
  rails test test/controllers
  rails test test/integration
  rails test test/system
```

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- AUTHORS -->

## 👥 Autor <a name="authors"></a>

👤 **Elson Otake**

- GitHub: [elsonotake](https://github.com/elsonotake)
- Twitter: [@elsonotake](https://twitter.com/elsonotake)
- LinkedIn: [elsonotake](https://linkedin.com/in/elsonotake)

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Recursos futuros <a name="future-features"></a>

-

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contribuição <a name="contributing"></a>

Contribuições, problemas e solicitações de recursos são bem-vindos!

Sinta-se à vontade para verificar a [página de problemas](../../issues/).

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- SUPPORT -->

## ⭐️ Mostre seu apoio <a name="support"></a>

Give a ⭐️ if you like this project!

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Agradecimentos <a name="acknowledgements"></a>

Eu gostaria de agradecer:

- [Kobana](https://www.kobana.com.br/)
- [Microverse](https://www.microverse.org/)
- [W3Schools](https://www.w3schools.com/)
- [Stack Overflow](https://stackoverflow.com/)

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- LICENSE -->

## 📝 Licença <a name="license"></a>

Este projeto é licenciado pelo [MIT](./MIT.md).

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>
