# AtlasFi Protocol

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Clarity Version](https://img.shields.io/badge/Clarity-3.0-blue.svg)](https://github.com/stacksgov/sips/blob/main/sips/sip-015/sip-015-network-upgrade.md)
[![Stacks](https://img.shields.io/badge/Built%20on-Stacks-purple.svg)](https://www.stacks.co/)

## Overview

AtlasFi is a next-generation decentralized credit infrastructure built for Bitcoin holders on the Stacks blockchain. The protocol provides a capital-efficient mechanism to unlock liquidity against Bitcoin collateral while embedding institutional-grade risk controls and maintaining Bitcoin exposure.

## 🚀 Key Features

- **Bitcoin-Backed Credit Lines**: Secure loans collateralized by Bitcoin with configurable ratios
- **Automated Liquidation Protection**: Dynamic risk management to reduce systemic exposure
- **Oracle-Driven Pricing**: Real-time asset price integration for accurate valuations
- **Governance Controls**: Parameter tuning capabilities for evolving market conditions
- **Multi-Asset Infrastructure**: Extensible design supporting future asset integrations
- **Capital Efficiency**: Optimized collateralization ratios for maximum liquidity

## 📋 Table of Contents

- [Architecture](#architecture)
- [Smart Contract Structure](#smart-contract-structure)
- [Core Functions](#core-functions)
- [Risk Management](#risk-management)
- [Installation](#installation)
- [Testing](#testing)
- [Usage Examples](#usage-examples)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## 🏗️ Architecture

AtlasFi operates as a trustless lending protocol where:

1. Users deposit Bitcoin as collateral
2. Credit lines are issued based on configurable collateralization ratios
3. Automated systems monitor and manage liquidation risks
4. Interest accrues block-by-block with transparent calculations
5. Governance controls enable protocol evolution

### Protocol Parameters

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Minimum Collateral Ratio | 150% | Required overcollateralization |
| Liquidation Threshold | 120% | Automatic liquidation trigger |
| Platform Fee Rate | 1% | Protocol revenue mechanism |
| Interest Rate | 5% | Annual borrowing cost |

## 📦 Smart Contract Structure

### Data Variables

```clarity
;; Platform state
(define-data-var platform-initialized bool false)
(define-data-var minimum-collateral-ratio uint u150)
(define-data-var liquidation-threshold uint u120)
(define-data-var platform-fee-rate uint u1)
(define-data-var total-btc-locked uint u0)
(define-data-var total-loans-issued uint u0)
```

### Data Maps

```clarity
;; Loan tracking
(define-map loans { loan-id: uint } { ... })
(define-map user-loans { user: principal } { ... })
(define-map collateral-prices { asset: string-ascii } { ... })
```

### Supported Assets

- **BTC**: Primary collateral asset
- **STX**: Secondary supported asset
- Extensible for future multi-asset support

## 🔧 Core Functions

### Platform Management

#### `initialize-platform()`

Initializes the protocol for operation. Owner-only function.

```clarity
(define-public (initialize-platform)
  ;; Sets platform-initialized to true
  ;; Required before any lending operations
)
```

### Lending Operations

#### `deposit-collateral(amount)`

Deposits Bitcoin collateral into the protocol.

```clarity
(define-public (deposit-collateral (amount uint))
  ;; Validates amount > 0
  ;; Updates total-btc-locked
)
```

#### `request-loan(collateral, loan-amount)`

Creates a new collateralized loan position.

```clarity
(define-public (request-loan (collateral uint) (loan-amount uint))
  ;; Validates collateralization ratio
  ;; Creates loan record
  ;; Returns loan-id
)
```

#### `repay-loan(loan-id, amount)`

Repays an active loan with accrued interest.

```clarity
(define-public (repay-loan (loan-id uint) (amount uint))
  ;; Calculates total owed (principal + interest)
  ;; Updates loan status to "repaid"
  ;; Releases collateral
)
```

### Governance Functions

#### `update-collateral-ratio(new-ratio)`

Updates the minimum collateralization requirement.

#### `update-liquidation-threshold(new-threshold)`

Modifies the liquidation trigger point.

#### `update-price-feed(asset, new-price)`

Updates oracle price data for supported assets.

### Read-Only Functions

#### `get-loan-details(loan-id)`

Returns comprehensive loan information.

#### `get-user-loans(user)`

Retrieves all active loans for a user.

#### `get-platform-stats()`

Returns protocol-wide statistics.

## ⚡ Risk Management

### Liquidation Mechanism

The protocol employs automated liquidation to protect against undercollateralization:

1. **Monitoring**: Continuous collateral ratio calculations
2. **Threshold**: 120% ratio triggers liquidation
3. **Execution**: Automatic position closure
4. **Protection**: Prevents protocol insolvency

### Interest Calculation

Interest accrues per block using the formula:

```
interest = (principal × rate × blocks) / (100 × 144)
```

Where 144 represents the average blocks per day on Stacks.

## 🛠️ Installation

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) >= 2.0
- [Node.js](https://nodejs.org/) >= 18.0
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/rich-udoh01/AtlasFi.git
   cd AtlasFi
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Verify installation**

   ```bash
   clarinet check
   ```

## 🧪 Testing

### Running Tests

Execute the full test suite:

```bash
npm test
```

Run tests with coverage and cost analysis:

```bash
npm run test:report
```

Watch mode for development:

```bash
npm run test:watch
```

### Test Structure

```typescript
describe("AtlasFi Protocol", () => {
  it("should initialize platform correctly", () => {
    // Test platform initialization
  });
  
  it("should handle loan creation", () => {
    // Test loan request flow
  });
  
  it("should manage liquidations", () => {
    // Test liquidation mechanics
  });
});
```

## 📚 Usage Examples

### Basic Lending Flow

```typescript
// 1. Initialize platform (owner only)
simnet.callPublicFn("atlasi-fi", "initialize-platform", [], owner);

// 2. Set BTC price
simnet.callPublicFn("atlasi-fi", "update-price-feed", 
  [Cl.stringAscii("BTC"), Cl.uint(50000)], owner);

// 3. Deposit collateral
simnet.callPublicFn("atlasi-fi", "deposit-collateral", 
  [Cl.uint(100000000)], borrower); // 1 BTC in satoshis

// 4. Request loan
simnet.callPublicFn("atlasi-fi", "request-loan", 
  [Cl.uint(100000000), Cl.uint(20000)], borrower); // 1 BTC collateral, $20k loan

// 5. Repay loan
simnet.callPublicFn("atlasi-fi", "repay-loan", 
  [Cl.uint(1), Cl.uint(21000)], borrower); // Loan ID 1, amount with interest
```

### Governance Operations

```typescript
// Update collateral requirements
simnet.callPublicFn("atlasi-fi", "update-collateral-ratio", 
  [Cl.uint(175)], owner); // Increase to 175%

// Update liquidation threshold
simnet.callPublicFn("atlasi-fi", "update-liquidation-threshold", 
  [Cl.uint(130)], owner); // Increase to 130%
```

### Querying Protocol State

```typescript
// Get loan details
const loanDetails = simnet.callReadOnlyFn("atlasi-fi", "get-loan-details", 
  [Cl.uint(1)], borrower);

// Get platform statistics
const stats = simnet.callReadOnlyFn("atlasi-fi", "get-platform-stats", 
  [], borrower);

// Get user's active loans
const userLoans = simnet.callReadOnlyFn("atlasi-fi", "get-user-loans", 
  [Cl.principal(borrower)], borrower);
```

## 🔒 Security

### Error Handling

The protocol implements comprehensive error handling:

| Error Code | Description |
|------------|-------------|
| `u100` | Unauthorized access |
| `u101` | Insufficient collateral |
| `u102` | Below minimum threshold |
| `u103` | Invalid amount |
| `u104` | Already initialized |
| `u105` | Not initialized |
| `u106` | Invalid liquidation |
| `u107` | Loan not found |
| `u108` | Loan not active |
| `u109` | Invalid loan ID |
| `u110` | Invalid price |
| `u111` | Invalid asset |

### Best Practices

- Always validate input parameters
- Use appropriate access controls
- Monitor collateralization ratios
- Implement circuit breakers for extreme market conditions
- Regular security audits and formal verification

### Known Limitations

- Single owner governance model (consider multi-sig)
- Static interest rates (implement dynamic models)
- Limited to 10 active loans per user
- Oracle dependency for price feeds

## 🤝 Contributing

We welcome contributions to AtlasFi! Please follow these guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Include comprehensive tests
- Update documentation
- Ensure all tests pass
- Use conventional commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
