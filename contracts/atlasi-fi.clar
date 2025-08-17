;; Title: AtlasFi Protocol - Bitcoin Collateralized Credit Engine
;;
;; Summary:
;; AtlasFi is a next-generation decentralized credit infrastructure built for Bitcoin holders.
;; It provides a capital-efficient mechanism to unlock liquidity against BTC while embedding
;; institutional-grade risk controls. The protocol is designed for sustainable growth, ensuring
;; users retain Bitcoin exposure while accessing stable, predictable on-chain loans.
;;
;; Description:
;; AtlasFi transforms passive Bitcoin positions into productive assets within the DeFi ecosystem.
;; By offering dynamic collateralization management, automated liquidation safeguards, and
;; real-time asset pricing, the protocol guarantees solvency without compromising capital efficiency.
;;
;; Key Features:
;;   - Bitcoin-backed credit lines secured by configurable collateralization ratios
;;   - Automated liquidation protection to reduce systemic risk
;;   - Flexible and upgradable interest rate framework
;;   - Oracle-driven real-time asset price integration
;;   - Governance-enabled parameter tuning for evolving market conditions
;;   - Multi-asset infrastructure for future extensibility

;;                     Protocol Constants & Errors

(define-constant CONTRACT-OWNER tx-sender)

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u101))
(define-constant ERR-BELOW-MINIMUM (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-ALREADY-INITIALIZED (err u104))
(define-constant ERR-NOT-INITIALIZED (err u105))
(define-constant ERR-INVALID-LIQUIDATION (err u106))
(define-constant ERR-LOAN-NOT-FOUND (err u107))
(define-constant ERR-LOAN-NOT-ACTIVE (err u108))
(define-constant ERR-INVALID-LOAN-ID (err u109))
(define-constant ERR-INVALID-PRICE (err u110))
(define-constant ERR-INVALID-ASSET (err u111))

;; Supported assets (extensible infrastructure)
(define-constant VALID-ASSETS (list "BTC" "STX"))

;;                         Data Variables

(define-data-var platform-initialized bool false)
(define-data-var minimum-collateral-ratio uint u150) ;; Default: 150%
(define-data-var liquidation-threshold uint u120) ;; 120% triggers liquidation
(define-data-var platform-fee-rate uint u1) ;; 1% platform fee
(define-data-var total-btc-locked uint u0)
(define-data-var total-loans-issued uint u0)

;;                           Data Maps

(define-map loans
  { loan-id: uint }
  {
    borrower: principal,
    collateral-amount: uint,
    loan-amount: uint,
    interest-rate: uint,
    start-height: uint,
    last-interest-calc: uint,
    status: (string-ascii 20),
  }
)

(define-map user-loans
  { user: principal }
  { active-loans: (list 10 uint) }
)

(define-map collateral-prices
  { asset: (string-ascii 3) }
  { price: uint }
)

;;                       Private Helper Functions

(define-private (calculate-collateral-ratio
    (collateral uint)
    (loan uint)
    (btc-price uint)
  )
  (let (
      (collateral-value (* collateral btc-price))
      (ratio (* (/ collateral-value loan) u100))
    )
    ratio
  )
)

(define-private (calculate-interest
    (principal uint)
    (rate uint)
    (blocks uint)
  )