#[lint_allow(self_transfer)]
module backend::scratch1 {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    friend backend::business;

    struct Treasury has key { // Object containing a reference to the coin pool to draw Payments from
        id: UID,
        balance: u64,
        denomination: String, // USDC, BTC, ETH, etc. The denomination of the currency in the treasury
    }

    public(friend) fun new_treasury(ctx: &mut TxContext): Treasury {
        Treasury {
            id: object::new(ctx),
            balance: 0,
        };
    }

    public(friend) fun check_balance(ctx: &TxContext, treasury: &Treasury): u64 {
        treasury.balance
    }

    public(friend) fun withdraw(ctx: &mut TxContext, treasury: &mut Treasury, amount: u64) {
        treasury.balance -= amount;
    }

}