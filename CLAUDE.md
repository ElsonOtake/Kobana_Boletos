# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kobana_Boletos is a Rails 8 application that performs CRUD operations on bank billets (boletos) using the Kobana API (BoletoSimples) without persisting data locally. The application integrates with the Kobana API Sandbox for creating, listing, updating, showing, and canceling bank billets.

## Development Setup

### Ruby Version
- Ruby 3.4.5 (specified in `.ruby-version` and `.tool-versions`)
- Set up using asdf: `asdf install ruby 3.4.5`

### Environment Variables
Create a `.env` file with:
```
BOLETOSIMPLES_API_TOKEN=your_sandbox_api_token
```

### Commands

```bash
# Install dependencies
bundle install
npm install

# Run development server
bin/dev  # Runs Rails server, JS build watch, and CSS build watch concurrently

# Run tests
rails test test/models
rails test test/controllers
rails test test/integration
rails test test/system

# Individual test example
rails test test/models/boleto_test.rb
```

## Architecture

### Core Model
- **Boleto** (`app/models/boleto.rb`): Non-persisted model using `ActiveModel::Model` and `ActiveModel::Attributes`
  - Integrates with Kobana API via BoletoSimples gem
  - Implements CRUD operations without database persistence
  - Uses memcached for API response caching

### API Integration
- Configuration in `config/initializers/boleto_simples.rb`
- Sandbox environment by default
- Uses Bearer token authentication

### Internationalization
- Supports English (en) and Portuguese (pt)
- Locale files in `config/locales/`
- URL-based locale switching: `/:locale/boletos`

### Frontend
- Bulma CSS framework
- Stimulus JS framework
- Turbo for SPA-like navigation
- Build tools: esbuild for JS, Sass for CSS

### Key Dependencies
- `boletosimples`: Kobana API client
- `city-state`: Brazilian state/city data
- `dalli`: Memcached client
- `turbo-rails` & `stimulus-rails`: Hotwire stack