A Clarity smart contract implementing a limited edition NFT drop with a fixed supply and a time-based minting window.

---

## Overview

This contract enables minting of a limited number of NFTs with the following features:

- **Fixed total supply:** 1000 NFTs
- **Minting window:** Defined by block heights (`MINT_START` to `MINT_END`)
- **Per-user mint limit:** Maximum 5 NFTs per principal
- **Token metadata:** Stores metadata URI for each token
- **Soulbound tokens:** Transfers are disabled to prevent token trading
- **Read-only queries:** Functions to check total minted NFTs, NFTs minted by a user, and token metadata

---

## Contract Details

### NFT Definition
``
(define-non-fungible-token limited-edition-nft uint)
Constants
CONTRACT_OWNER — Contract deployer address

TOTAL_SUPPLY — Maximum NFTs available (1000)

MINT_START — Block height when minting starts

MINT_END — Block height when minting ends

MAX_MINT_PER_USER — Maximum NFTs allowed per user (5)

Functions
Public Functions
mint(metadata-uri: (string-ascii 256)) -> (response uint uint)
Mints a new NFT with the provided metadata URI if:

Current block height is within the minting window

Total supply limit is not exceeded

User's mint limit is not exceeded

Returns the new token ID on success.

Read-Only Functions
get-total-minted() -> (response uint uint): Returns the total number of NFTs minted so far.

get-minted-by-user(user: principal) -> (response uint uint): Returns how many NFTs a given user has minted.

get-token-uri(token-id: uint) -> (response (string-ascii 256) uint): Returns the metadata URI for a given token ID.

Disabled Functions
transfer(token-id: uint, sender: principal, recipient: principal): Token transfer is disabled (soulbound tokens).

Error Codes
Code	Meaning
u100	Minting has not started yet
u101	Minting period has ended
u102	Total supply limit reached
u103	User mint limit reached
u104	NFT minting failed
u105	Transfers disabled (soulbound token)
u404	Token metadata not found

Transfers are disabled to maintain soulbound status.

