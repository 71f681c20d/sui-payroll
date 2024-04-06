# PoC Use Case

- `Business` object is created with a `Treasury` object member
- The `Treasury` holds `Coin` objects (SUI)
- The `Business` object holds a list of `Employee` objects

- The `Employee` hold the `Compensation` struct which a breakdown of the employee pay
- The `Compensation` fields are mutable, and change over time as pay changes
- When a `Paystub` object is created, a copy of the `Compensation` struct is created as a snapshot, and stored in the `Paystub` object

Payroll use case
- When a user wants to pay employees...
- The `pay_employees` function is called
- A reference to the business object's employee list is created
- A loop iterates over the employee list and...
    - The `Compensation` struct is copied 
    - The net payment is calculated
    - The `Paystub` object is created with the `Compensation` struct copy
    - The `Paystub` object is frozen (made immutable)
    - The `Paystub` object is appended to the `Employee` object's paystub list
    - The `Payment` object is created with a reference to the `Paystub` object
    - Coins are withdrawn from the `Treasury` and sent to the `Payment` object
    - The `Payment` object is sent to the `Employee` object's personal wallet address
    - The loop repeats on the next `Employee` in the `Business` object's employee list
- All transactions in this loop are encapsulated in an atomic programmable transaction block
- An event is emitted indicating the PTB was successful or not

Entry points:
- update employee data:
- update business data: 
- 




## Things to Add to this solution
- This proof-of-concept is incomplete. It isn't usable for a commercial business application because it's missing some things
    - Witnesses; 
    - Transfer policies
    - Bridging
    - Entitlement checking, transaction authorization
    - Front-end UX
- These things are required to make the solution business-ready as an MVP

Additionally, there are other opportunities for improvement
    - Pay other types of expenses, such as employer-provided insurance and benefits
    - Payment and treasury percentages; draw certain percentages from different treasuries and receive payments to multiple wallets in different percentages
    - Pay for b2b vendor services
    - Fiat on/off-ramps; perhaps Rune debit card integration
    - Market-based payment pricing; Price payments in bitcoin, stablecoins, or whatever crypto; use a pricing oracle like Pyth
    - Privacy-preserving services to protect employees and other sensitive information
    
Notes about additional features
- If a business can run all of its internal operations with public pseudonymous on-chain data, then it allows for a full public audit trail
- If a business can manage payments and operations between vendors, employees, shareholders, and customers, then the entire business can run completely on-chain. All of this logic can be implemented and integrated with the existing payroll app
- 




