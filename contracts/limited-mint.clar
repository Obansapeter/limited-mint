;; ----------------------------------------------------------------------------------
;; Contract: limited-mint.clar
;; Author: Your Name
;; Description: Limited edition NFT drop with fixed supply and time-based mint window.
;; ----------------------------------------------------------------------------------



;; NFT definition
(define-non-fungible-token limited-edition-nft uint)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOTAL_SUPPLY u1000) ;; Max NFTs available
(define-constant MINT_START u12345678) ;; Block height minting starts
(define-constant MINT_END u12349999) ;; Block height minting ends
(define-constant MAX_MINT_PER_USER u5) ;; Max NFTs per principal

;; Variables
(define-data-var last-token-id uint u0)

;; Track how many NFTs each user minted
(define-map minted-per-user principal uint)

;; Track token metadata URIs (optional)
(define-map token-metadata uint (string-ascii 256))

;; ---------------------------------------------
;; Public function: Mint limited edition NFT
;; ---------------------------------------------
(define-public (mint (metadata-uri (string-ascii 256)))
  (let (
        (current-block stacks-block-height)
        (last-id (var-get last-token-id))
        (user tx-sender)
        (user-minted (default-to u0 (map-get? minted-per-user user)))
        (next-id (+ last-id u1))
       )
    ;; Check minting window
    (asserts! (>= current-block MINT_START) (err u100))
    (asserts! (<= current-block MINT_END) (err u101))

    ;; Check total supply limit
    (asserts! (<= next-id TOTAL_SUPPLY) (err u102))

    ;; Check user's mint limit
    (asserts! (< user-minted MAX_MINT_PER_USER) (err u103))

    ;; Mint NFT
    (try! (nft-mint? limited-edition-nft next-id user))

    ;; Save metadata URI
    (map-set token-metadata next-id metadata-uri)

    ;; Update counters
    (var-set last-token-id next-id)
    (map-set minted-per-user user (+ user-minted u1))

    (print { action: "mint", minter: user, token-id: next-id, metadata: metadata-uri })
    (ok next-id)
  )
)

;; ---------------------------------------------
;; Read-only: Get total NFTs minted so far
;; ---------------------------------------------
(define-read-only (get-total-minted)
  (ok (var-get last-token-id))
)

;; ---------------------------------------------
;; Read-only: Get NFTs minted by user
;; ---------------------------------------------
(define-read-only (get-minted-by-user (user principal))
  (ok (default-to u0 (map-get? minted-per-user user)))
)

;; ---------------------------------------------
;; Read-only: Get token metadata URI
;; ---------------------------------------------
(define-read-only (get-token-uri (token-id uint))
  (match (map-get? token-metadata token-id)
    metadata (ok metadata)
    (err u404)
  )
)

;; ---------------------------------------------
;; Transfer function DISABLED for soulbound tokens (optional)
;; ---------------------------------------------
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (err u105) ;; Transfer disabled
)
