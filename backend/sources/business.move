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

        let employees_len = Vector::length(&employees);
        let i = 0;

        while (i < employees_len) {
            let employee = Vector::borrow(&employees, i);
            let employee_address = &employee.wallet_address; // Assuming `wallet_address` field exists
            let payment = Payment::create_payment(amount, *employee_address);
            Payment::send_payment(&mut payment, *employee_address);
            i = i + 1;
        }

        for employee in business.employees.iter_mut() {
            treasury::transfer(business.treasury, employee, employee.salary);
        }
    }
}

module backend::receipt { // formerly Paystub
    /** This immutable shared object contains metadata about payments made to each employee
        The PayStub object is created when a payment is made to an employee
        The Paystub object is stored in the employee's pay_stubs vector_table for auditing purposes
        The Payment object sent to the employee wallet references the PayStub object for auditing purposes
    */
    use sui::tx_context::{TxContext, Self};
    use sui::transfer::Self;
    use sui::object::{Self, UID};

    struct Receipt has key, store {
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