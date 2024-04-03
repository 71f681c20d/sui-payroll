#[lint_allow(self_transfer)]
module backend::business {
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};
    use std::string::String;

    use backend::treasury;

    struct Business has key { // Object for the business, containing all employees and treasury
        id: UID,
        employees: vector<Employee>,
        treasury: Treasury,
    }

    public entry fun create_business(): Business {
        let treasury = treasury::new_treasury();

        let business = Business {
            id: UID::new(),
            employees: vector::new(),
            treasury,
        };

        business
    }

    public entry fun add_employee(business: &mut Business, employee: Employee) {
        let required_entitlements = vector[
            "business.read.employee",
            "business.write.employee",
        ];
        // Check that the function caller has the required entitlements
        assert!(check_entitlement(required_entitlements, employee), "Error: Insufficient Entitlements to add employee to business.");
        // Add the employee to the business
        business.employees.push_back(employee);
    }

    public fun check_entitlement(entitlements: vector<Entitlement>, employee: &Employee): bool {
        // Check if an Employee has all Entitlements provided
        
        let entitlement = treasury::get_entitlement(business.treasury, employee);
        entitlement
    }

    public entry fun pay_employees(business: &mut Business) {
        let required_entitlements = vector[
            "business.read.employee",
            "business.write.pay",
        ];
        // Check that the function caller has the required entitlements
        assert!(check_entitlement(required_entitlements, employee), "Error: Insufficient Entitlements to create payments for employees");

        // fun sum_intermediate(n: u64): u64 {
            let sum = 0;
            let i = 0;
            loop {
                i = i + 1;
                if (i % 10 == 0) continue;
                if (i > n) break;
                sum = sum + i
            };

            sum
        // }

        for employee in business.employees.iter_mut() {
            treasury::transfer(business.treasury, employee, employee.salary);
        }
    }
}