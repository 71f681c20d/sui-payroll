// #[lint_allow(self_transfer)]
module backend::employee {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    use backend::compensation::Compensation;

    struct Employee has key, store {
        id: UID,
        name: String,
        role: String,
        age: u32,
        compensation: Compensation,
        entitlement: vector<Entitlement>,
        pay_stubs: vector_table<PayStub>,
    }

}

module backend::compensation {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Compensation has store, copy {
        let table = table::new<String, u64>();
    }

    public entry fun add_pay_component(name: String, amount: u64) {
        // name is the key, amount is the value; ex: "bonus", 1000
        table::add(&mut table, name, amount);
    }

}

module backend::allocations {
    // Percentages of salary to be paid to each employee wallet address
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Allocations has store {
        name: String,
        amount: u32,
    }

}

module backend::entitlement {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    let ENTITLEMENT_LIST: mut vector<Entitlement> = vec![
        Entitlement { name: "business.read.treasury"},
        Entitlement { name: "business.write.treasury" },
        Entitlement { name: "business.read.paystubs" },
        Entitlement { name: "business.write.pay" },
        Entitlement { name: "business.read.employee" },
        Entitlement { name: "business.write.employee" },
    ];

    let ENTITLEMENT_GROUPS: mut vector<EntitlementGroup> = vec![
        EntitlementGroup { name: "business.treasury", entitlements: vector["business.read.treasury", "business.write.treasury"] },
        EntitlementGroup { name: "business.pay", entitlements: vector["business.read.paystubs", "business.write.pay"] },
        EntitlementGroup { name: "business.employee", entitlements: vector["business.read.employee", "business.write.employee"] },
    ];

    struct Entitlement has key, store {
        id: UID,
        name: String,
    }

    struct EntitlementGroup has key, store {
        id: UID,
        name: String,
        entitlements: vector<Entitlement>,
    }

    public(friend) fun get_entitlement(): Entitlement {
        ENTITLEMENT_LIST
    }

    public(friend) fun add_entitlement(entitlement: Entitlement) {
        ENTITLEMENT_LIST.push_back(entitlement)
    }

    public(friend) fun add_entitlement(name: String) {
        ENTITLEMENT_LIST.push_back(Entitlement { name })
    }

    public(friend) fun get_entitlement_groups(): vecotr<EntitlementGroup> {
        ENTITLEMENT_GROUPS
    }

    public(friend) fun create_entitlement_group(name: String, entitlements: vector<Entitlement>) {
        ENTITLEMENT_GROUPS.push_back(EntitlementGroup { name, entitlements })
    }

}

module backend::paystub {
    /** This immutable shared object contains metadata about payments made to each employee
        The PayStub object is created when a payment is made to an employee
        The Paystub object is stored in the employee's pay_stubs vector_table for auditing purposes
        The Payment object sent to the employee wallet references the PayStub object for auditing purposes
    */
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};

    struct PayStub has key, store {
        id: UID,
        employee_id: UID,
        compensation: Compensation,
        timestamp: u64,
    }

    public(friend) fun create_paystub(employee: Employee, ctx: TxContext) {
        // Calculate
        let paystub: PayStub = { 
            id: object::new(ctx),
            employee_id: employee.id, 
            compensation: employee.compensation, 
            timestamp: TimeEvent { timestamp_ms: clock::timestamp_ms(clock) }, 
            };
        // Make the Paystub object immutable
        transfer::freeze_object(object);
    }

}



