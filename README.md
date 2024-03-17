<p align="right">(<a href="#voltar-ao-topo">Português</a>)</p>

<a name="readme-top"></a>

<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
  - [🚀 Live Demo](#live-demo)
- [💻 Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Install](#install)
  - [Usage](#usage)
  - [Run tests](#run-tests)
- [👥 Author](#author)
- [🔭 Future Features](#future-features)
- [🤝 Contributing](#contributing)
- [⭐️ Show your support](#support)
- [🙏 Acknowledgements](#acknowledgements)
- [📝 License](#license)

<!-- PROJECT DESCRIPTION -->

# 📖 Kobana_Boletos <a name="about-project"></a>

**Kobana_Boletos** is a Rails application performing CRUD using an external API without persisting data in the local database table. List, create, update, show details, and cancel a bank billet. The billets are created by integrating the Rails project with the [Kobana API in Sandbox](https://developers.kobana.com.br/reference/visao-geral).


## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Client</summary>
  <ul>
    <li><a href="https://rubyonrails.org/">Ruby on Rails</a></li>
  </ul>
</details>

<details>
  <summary>Server</summary>
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

<details>
<summary>Database</summary>
  <ul>
    <li><a href="https://developers.kobana.com.br/reference/visao-geral">Kobana API in Sandbox</a></li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

- **[ActiveModel::Model](https://api.rubyonrails.org/classes/ActiveModel/Model.html)**
- **[ActiveModel::Attributes](https://api.rubyonrails.org/classes/ActiveModel/Attributes.html)**
- **[I18n](https://guides.rubyonrails.org/i18n.html)**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LIVE DEMO -->

## 🚀 Live Demo <a name="live-demo"></a>

- [Heroku](https://elsonotake-kobana-boletos-8a0943d52ae8.herokuapp.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running, follow these steps.

### Prerequisites <a name="prerequisites"></a>

In order to run this project you need:

[Ruby](https://www.ruby-lang.org/en/)

### Setup <a name="setup"></a>

Clone this repository to your desired folder:

using HTTPS:
```sh
  git clone https://github.com/ElsonOtake/Kobana_Boletos.git
  cd Kobana_Boletos
```

using an SSH key:
```sh
  git clone git@github.com:ElsonOtake/Kobana_Boletos.git
  cd Kobana_Boletos
```

using GitHub CLI:
```sh
  git clone gh repo clone ElsonOtake/Kobana_Boletos
  cd Kobana_Boletos
```

### Install <a name="install"></a>

Fill in the environment variables
```sh
  BOLETOSIMPLES_API_TOKEN=BOLETOSIMPLES_API_TOKEN
```

Install this project with:
```sh
  bundle install
  npm install
```

### Usage <a name="usage"></a>

To run the project, execute the following command:

```sh
  bin/dev
```
Open `http://localhost:3000/` on your browser.

### Run tests <a name="run-tests"></a>

To run tests, run the following command:

```sh
  rails test test/models
  rails test test/controllers
  rails test test/integration
  rails test test/system
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHOR -->

## 👥 Author <a name="author"></a>

👤 **Elson Otake**

- GitHub: [elsonotake](https://github.com/elsonotake)
- Twitter: [@elsonotake](https://twitter.com/elsonotake)
- LinkedIn: [elsonotake](https://linkedin.com/in/elsonotake)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Future Features <a name="future-features"></a>

-

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->

## ⭐️ Show your support <a name="support"></a>

Give a ⭐️ if you like this project!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments <a name="acknowledgements"></a>

I would like to thank:

- [Kobana](https://www.kobana.com.br/)
- [Microverse](https://www.microverse.org/)
- [W3Schools](https://www.w3schools.com/)
- [Stack Overflow](https://stackoverflow.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./MIT.md) licensed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<p align="right">(<a href="#readme-top">English</a>)</p>

<a name="voltar-ao-topo"></a>

<!-- TABLE OF CONTENTS -->

# 📗 Tabela de conteúdo

- [📖 Sobre o projeto](#sobre-o-projeto)
  - [🛠 Construído com](#construido-com)
    - [Tech Stack](#tecnologias)
    - [Características principais](#caracteristicas-principais)
  - [🚀 Live Demo](#demonstracao-ao-vivo)
- [💻 Primeiros Passos](#primeiros-passos)
  - [Pré-requisitos](#pre-requisitos)
  - [Configuração](#configuracao)
  - [Instalação](#instalacao)
  - [Utilização](#utilizacao)
  - [Executar testes](#executar-testes)
- [👥 Autor](#autor)
- [🔭 Recursos futuros](#recursos-futuros)
- [🤝 Contribuição](#contribuicao)
- [⭐️ Mostre seu apoio](#mostre-seu-apoio)
- [🙏 Agradecimentos](#agradecimentos)
- [📝 Licença](#licenca)

<!-- PROJECT DESCRIPTION -->

# 📖 Kobana_Boletos <a name="sobre-o-projeto"></a>

**Kobana_Boletos** é uma aplicação Rails que executa CRUD usando uma API externa sem persistir dados na tabela do banco de dados local. É possível listar boletos, criar novos boletos, alterar boletos, apresentar dados de um boleto e cancelar um boleto aberto. Os boletos são criados realizando a integração do projeto Rails com a [API da Kobana em Sandbox](https://developers.kobana.com.br/reference/visao-geral).

## 🛠 Construído com <a name="construido-com"></a>

### Tech Stack <a name="tecnologias"></a>

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

<details>
<summary>Banco de dados</summary>
  <ul>
    <li><a href="https://developers.kobana.com.br/reference/visao-geral">API da Kobana em Sandbox</a></li>
  </ul>
</details>

<!-- Features -->

### Características principais <a name="caracteristicas-principais"></a>

- **[ActiveModel::Model](https://api.rubyonrails.org/classes/ActiveModel/Model.html)**
- **[ActiveModel::Attributes](https://api.rubyonrails.org/classes/ActiveModel/Attributes.html)**
- **[I18n](https://guides.rubyonrails.org/i18n.html)**


<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- LIVE DEMO -->

## 🚀 Live Demo <a name="demonstracao-ao-vivo"></a>

- [Heroku](https://elsonotake-kobana-boletos-8a0943d52ae8.herokuapp.com/)

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- GETTING STARTED -->

## 💻 Primeiros Passos <a name="primeiros-passos"></a>

Para obter uma cópia local instalada e funcionando, siga estas etapas.

### Pré-requisitos <a name="pre-requisitos"></a>

Para executar este projeto você precisa de:

[Ruby](https://www.ruby-lang.org/en/)

### Configuração <a name="configuracao"></a>

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

### Instalação <a name="instalacao"></a>

Preencha as variáveis de ambiente
```sh
  BOLETOSIMPLES_API_TOKEN=BOLETOSIMPLES_API_TOKEN
```

Instale este projeto com:
```sh
  bundle install
  npm install
```

### Utilização <a name="utilizacao"></a>

Para executar o projeto, execute o seguinte comando:

```sh
  bin/dev
```
Abra `http://localhost:3000/` no seu navegador.

### Executar testes <a name="executar-testes"></a>

Para executar testes, execute os seguintes comandos:

```sh
  rails test test/models
  rails test test/controllers
  rails test test/integration
  rails test test/system
```

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- AUTHOR -->

## 👥 Autor <a name="autor"></a>

👤 **Elson Otake**

- GitHub: [elsonotake](https://github.com/elsonotake)
- Twitter: [@elsonotake](https://twitter.com/elsonotake)
- LinkedIn: [elsonotake](https://linkedin.com/in/elsonotake)

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Recursos futuros <a name="recursos-futuros"></a>

-

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contribuição <a name="contribuicao"></a>

Contribuições, problemas e solicitações de recursos são bem-vindos!

Sinta-se à vontade para verificar a [página de problemas](../../issues/).

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- SUPPORT -->

## ⭐️ Mostre seu apoio <a name="mostre-seu-apoio"></a>

Give a ⭐️ if you like this project!

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Agradecimentos <a name="agradecimentos"></a>

Eu gostaria de agradecer:

- [Kobana](https://www.kobana.com.br/)
- [Microverse](https://www.microverse.org/)
- [W3Schools](https://www.w3schools.com/)
- [Stack Overflow](https://stackoverflow.com/)

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>

<!-- LICENSE -->

## 📝 Licença <a name="licenca"></a>

Este projeto é licenciado pelo [MIT](./MIT.md).

<p align="right">(<a href="#voltar-ao-topo">voltar ao topo</a>)</p>
