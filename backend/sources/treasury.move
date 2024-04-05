// #[lint_allow(self_transfer)]
module backend::treasury {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    friend backend::business;

    struct Treasury has key, store { // Object containing a reference to the coin pool to draw Payments from
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

module backend::payment {
    /** The Payment object is created when a payment is made to an employee
        The Payment object contains coins and a reference to the PayStub object
        The Payment object sent to the employee wallet directly from Treasury; cannot be intercepted by another employee
        Payments and Paystubs are for all employees are created in the same PTB transaction block
    */
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Payment has key, store {
        id: UID,
        pay_stub_ref: &PayStub,
    }

}

