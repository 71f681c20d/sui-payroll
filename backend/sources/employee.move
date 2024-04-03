// #[lint_allow(self_transfer)]
module backend::employee {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    use backend::compensation::Compensation;

    struct Employee {
        name: String,
        age: u32,
        compensation: Compensation,
        entitlement: vector<Entitlement>,
    }

}

module backend::compensation {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Compensation {
        salary: u32,
        bonus: u32,
    }

}

module backend::allocations {
    // Percentages of salary to be paid to each employee wallet address
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    struct Allocations {
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

    struct Entitlement {
        name: String,
    }

    struct EntitlementGroup {
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

