# AshPay
# Learning by Doing

This is my personal implementation of the original MoneyPit project by Christian Alexander.

**Original Project:** [ChristianAlexander/money_pit](https://github.com/ChristianAlexander/money_pit)

## About this version

I created this version as a hands-on learning experience to deepen my understanding of Ash Framework and some Ash extensions. This repository represents my journey of learning through practice, implementing features and exploring different approaches while building upon Christian's excellent foundation.

A demonstration of [AshStateMachine](https://hexdocs.pm/ash_state_machine/) - the state machine extension for the [Ash Framework](https://ash-hq.org/).

This e-commerce application showcases how to build robust, stateful business processes with automatic state transitions, validation, and background job integration.

## State Machine Features

- ** Order State Transitions** - Orders flow through states: `created` → `paid`/`failed` → `ready_for_refund` → `refunded`

- ** Automatic State Validation** - Invalid state transitions are prevented at the framework level

- ** Background Job Integration** - State changes trigger background jobs using [AshOban](https://hexdocs.pm/ash_oban/)

- ** Real-time Updates** - UI updates automatically as orders transition through states.

- ** Policy Integration** - Authorization rules based on current state (e.g., only admins can refund `paid` orders)

## 🚀 Run it yourself!

1. **📦 Install dependencies and set up the database:**

   ```bash
   mix setup
   ```

   This will:

   -  Install Elixir dependencies

   -  Set up the database with migrations

   -  Create seed data with demo products and users

   -  Install and build frontend assets

2. **▶️ Start the Phoenix server:**

   ```bash
   iex -S mix phx.server
   ```

3. **🌐 Visit the application:**

   -  Main site: [`localhost:4000`](http://localhost:4000)

   -  Storefront: [`localhost:4000/storefront`](http://localhost:4000/storefront) (requires login)

   -  Orders: [`localhost:4000/orders`](http://localhost:4000/orders) (requires login)

## Demo Credentials & Data

### 👥 Demo Accounts

- ** Regular User:** `user@ashpay.com` / `password123`

- ** Admin User:** `admin@ashpay.com` / `password123`

###  Demo Products

- ** Basic Plan** - $9.99

- ** Pro Plan** - $19.99

- ** Max Plan** - $199.00

## 🛠️ Key Technologies

- **[Ash State Machine](https://hexdocs.pm/ash_state_machine/)**  - State machine extension

- **[Ash Framework](https://ash-hq.org/)**  - Declarative application framework

- **[AshOban](https://hexdocs.pm/ash_oban/)**  - Background job processing

- **[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/)**  - Real-time web interfaces

- **[Ash Authentication](https://hexdocs.pm/ash_authentication/)**  - Authentication system

- **[Ash Money](https://hexdocs.pm/ash_money/)**  - Money type and currency handling
