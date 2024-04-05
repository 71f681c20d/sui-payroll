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
- 


