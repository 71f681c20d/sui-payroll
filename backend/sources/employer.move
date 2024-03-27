#[lint_allow(self_transfer)]
module backend::employer {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Employer has key {
        id: UID
    }

    struct Employee has key, store {
        id: UID,
        title: String,
        body: String
    }

    #[allow(unused_function)]
    fun init(ctx: &mut TxContext) {
        let employees = Employees{
            id: sui::object::new(ctx),
        };
        transfer::share_object(employees)
    }

    public fun add_employee(first_name: String, last_name: String, email: String, salary: u32, ctx: &mut TxContext) {
        let employee = Employee {
            id: object::new(ctx),
            first_name,
            last_name,
            email,
            salary
        };
        transfer::transfer(note, tx_context::sender(ctx))
    }

}