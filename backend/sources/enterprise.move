/*

*/

module backend::enterprise {
    use sui::table_vec::{Self, TableVec};
    use sui::dynamic_field;

    /*
    Objects for the enterprise, which is the main object for the organization
    - Logic for the enterprise to interact with its operating environment, defined by realtionships
    - Logic for receiving and sending capital flows; issuing receipts
    - Logic for managing the enterprise's relationships, such as employees, customers, and suppliers
    */


    public struct Enterprise has key, store {
        id: UID,
        treasury: Treasury,
    }

    public fun create_enterprise(ctx: &mut TxContext) {
        // Create Tresury
        let mut treasury = Treasury {
            id: object::new(ctx),
            balance: 0,
        };
        let mut enterprise = Enterprise {
            id: object::new(ctx),
            treasury,
        };
        // Create Relationships (enterprise counterparties)
        dynamic_field::add(&mut enterprise.id, b"employees", table_vec::empty<Employee>(ctx));
        //dynamic_field::add(&mut enterprise.id, b"stakeholders", table_vec::empty<Stakeholder>(ctx));
        //dynamic_field::add(&mut enterprise.id, b"vendors", table_vec::empty<Vendor>(ctx));
        //dynamic_field::add(&mut enterprise.id, b"customers", table_vec::empty<Customer>(ctx));
        // Transfer the enterprise object to the module/package publisher
        transfer::public_transfer(enterprise, tx_context::sender(ctx));
    }

    /// accessors and mutators
    public fun get_treasury(self: &Enterprise): &Treasury {
        &self.treasury
    }

    public fun get_employees(enterprise: &Enterprise): &TableVec<Employee> {
        dynamic_field::borrow(&enterprise.id, b"employees")
    }

    public fun add_employee(enterprise: &mut Enterprise, employee: Employee) {
        let mut employees_ref: &mut TableVec<Employee> = dynamic_field::borrow_mut(&mut enterprise.id, b"employees");
        table_vec::push_back(employees_ref, employee);
    }

    /**
    Objects related to capital in the enterpise
    - Treasury; the destination of capital inflows and source of capital outflows
    - Payment; objects that represent the movement of capital between two parties
    - Receipt; objects that represent metadata about a payment for recordkeeping, decision-making, and reporting
    */

    // Contains capital paid to or from the enterprise; a payment hub between relationships
    public struct Treasury has key, store {
        id: UID,
        balance: u64,
    } 

    /// Contains metadata about a payment for recordkeeping, decision-making, and reporting. Immutable and shared
    public struct Receipt has key, store {
        id: UID,
        amount: u64,
    }

    /// Contains capital to be paid to or from the enterprise; references an immutable receipt object
    public struct Payment has key, store {
        id: UID,
        receipt: Receipt,
    }

    /**
    Objects for the enterprise's relationships. The union of all relationships is the operating environment of the enterprise.
    - Employee; the relationship between an employee and the enterprise
    - Customer; the relationship between a customer and the enterprise
    - Supplier; the relationship between a supplier and the enterprise
    - Shareholder; the relationship between a shareholder and the enterprise
    Also contains policies for the relationships.
    */

    /// Wrapper for Employee relationships; manages interactions between employees and the enterprise
    public struct Employee has store {
        pay: u64,
    }
    
}

//module backend::employee {}
