# Architecture

## V2 Arch
- The idea is to generalize the entities in the Payroll app so they can be reused and composed to serve other business purposes in the enterprise
- For instance, Payroll deals one component of a business operating environment: employee relationships with the firm

- Generalize a business to be an enterprise. This can be any social system consisting of people and software interacting and performing internal operations.
    - An enterprise can be a business, government, school, or any other type of institution.
- Generalize the operating environment of the enterprise to consist of relationships with other entities
    - Consumers (customers)
    - Stakeholders (shareholders)
    - Vendors (suppiers)
    - Workers (employees)
- Each of these relationships requires certain types of transactions and entities in order for the enterprise to interact with its counterparties
    - Payments
    - Receipts
    - Value (value is the thing that is exchanged for payments, such as a product or labor)
    - Relationship wrappers; Employee, customer, vendor, and stakeholder wrapper; Interfaces that can be instantiated
- The behavior of the enterprise...
    - Pipe payments between relationships; split payments in this pipeline. Ex: payments from customer to split to employees, vendors, and shareholders
    - Issue receipts; Instead of a merchant and customer copy, a shared immutable object
    - Deliver and receive value; products or services exchangeable for money
    - Holds a treasury as a capital hub; a midpoint where money flowing into the enterprise is parked, and where outflows come from
- Policies
    - There are certain actions a relationship should be able to do or not do
    - These actions are configured a Policies and/or TransferPolicies

Enterprise transactions
- when an Enterprise interacts with any of its relationships (its operating environment), new transactions are created.
- These transactions come in the form of Payment and Receipt objects. There are special types of Receipt objects for each relationship prototype
- Receipts are immutable objects which are shared with all parties involved in the transaction
- Payments contain coin objects. There are different types of Payment objects for each type of relationship
- The Receipt payment contains a reference to the Payment object (should it be the other way around?) which allows parties to analyze the source or destination of funds
- 

Relationsips
- Ideally, new types of enterprise relationships can be created to make the enterprise more adaptive
- Relationships are essentially configuration params which stipulate:
    - Source and destination of Payment objects
    - Components of the transaction, logged in the Receipt object and used to calculate Payment amounts


## V1 arch
- The `Business` object 
    - Contains the resources owned by the enterprise
    - Does not execute transactions. The object only holds resources such as `Treasury` and functions which operate on business resources
-The `Employee` object
    - Executes transactions that utilize the `Business` object's resources
    - Contains configurable `Entitlements` which describe which transactions the `Employee` is authorized to execute
    - Contains identity information which is relevant to the employment
    - Contains wallet address for the employee to receive their pay in their personal wallet
- The `Treasury` object
    - Contains funds which are owned by the business to pay for things, such as employees
    - Contains funtions for creating new `Payment` objects and sending them to the employee's wallet
    - Payment objects are processed in batches, and these transactions are contained in a PTB
- The `PayStub` object
    - Is immutable and shared?
    - Is created in the same batched PTB transaction as the `Payment` object it corresponds to
    - Contains metadata about the `Payment` object that was created and sent to the employee's wallet for audit purposes
    - Is accessible by reference from the employee's payment object in their personal wallet
    - Is also accessible by reference from the `Employee` object owned by the business
    - Is appended to a vector containing a full history of paystubs for each `Employee` object
    - Is owned by the `Employee` object
    - Contains a breakdown of the compensation, such as base salary, bonuses, benefits deductions, retirement contributions, etc..
- The `Payment` object
    - Is created in a batched PTB transaction 
    - Can only be created and sent by authorized `Employees` with the correct `Entitlements`
    - Contains coins drawn from the `Treasury` from an authorized `Employee`
    - Is sent directly to the employee's personal wallet address at the time of creation
    - Is never owned or accessed by the `Business` or any of the objects the Business owns
- 

Stories
- As an employee, I would like to...
    - Configure multiple personal wallets with a percentage of each paycheck going to the specified addresses
    - Be able to access a full history of all paystubs I've ever received from my employer
    - Configure payment denominations; receive pay in SOL, Bitcoin, ETH, SUI, etc.... for each personal wallet
    - Set my own termination date on my Employee object, to quit my job at a specified time
    - Change my own personal wallet addresses
    - Opt-into employer-offered benefits such as health insurance, and change my own benefits configuration
    - Receive an email notification when I get paid
- As a business, I would like to...
    - Be notified if an employee's termination date changes (null by default)
    - Add new employees
    - Change an Employee's termination date to fire them at a specified time
    - Change an Employee's start date to hire them at a specified time
    - Prevent attempts to overdraw from the Treasury (Use PTB)
    - Configure entitlements so that only specific employees are authorized to do specific things
    - Generate a full summary of all expenses paid to all employees
    - View summary of all pay made to a specific employee
    - View a summary of expenses paid over a specified window of time
    - Provide opt-in benefits to employees, such as health insurance, which will be deducted from the employee's pay
    - Have multiple Treasury wallets, with configurable percentages that payments will be drawn from
    - Configure Treasury account denominations; Draw payments from Bitcoin, ETH, Stablecoins, etc... 
    - 

Design choices
- The `Paystub` object needs to be an immutable object or struct (choose which one) which is owned by the `Employee` object, and contains a copy/snapshot of the employee's compensation breakdown at the time of payment, and the address the payment was sent to
- The list of `Paystubs` needs to be a table-based data structure or a linked list, since there will be a lot of them. will be ordered sequentially, won't ever be changed, and might be read in bulk for auditing purposes
- The `Payment` object needs to contain a reference to the `Paystub` object it corresponds to. It also needs to contain coins which are the actual payment itself
- The Employee object needs to contain a destination address which will be used to send new `Payment` objects to at the time of creation
- The `Business` object needs to contain various functions which are relevant to operating the business, such as modifying the `Treasury`, managing `Employees`, and generating `Payments`. These functions can only be called by `Employee` objects which have the appropriate `Entitlements` which authorize the employee to perform these transactions
- The  `Entitlements` object contains a predefined list of entitlements which can be updated by an authorized `Employee`. It also contains a set of functions which allow an entitlement to be granted to or revoked from other employees. There should be a way to manage which entitlements an employee is authorized to grant or revoke, so they don't revoke the entitlement of the CEO, for example
- The `Compensation` object belongs to the `Employee` object and can be updated to change the pay. The compensation contains a table of key/values, for example "bonus", 1000. When `Paystub` objects are created for that employee, the `Compensation` field is copied as a snapshot into the `Paystub`, which will describe the compensation breakdown at the time the payment was made

Bridging
- One nice feature about the application is that a `Treasury` can contain many different cryptocurrency reserve assets, like BTC, ETH, SOL, and stablecoins. 
- Employees can also be paid in multiple cryptocurrencies, so they might specify that every payment is 50% bitcoin, 30% ethereum, and 20% solana. This makes it easy for employees to automatically invest a percentage of their assets for hodling, defi, spending, etc...
- In order to do this, the Wormhole bridge will be used to bridge assets onto Sui as wrapped coins, create payment objects with the wrapped coins, and then unwrap the coins and send them to the employee's personal wallet address(es)
- When the Payment objects are created, there needs to be a way for the payments to be measured. If you are paying from multiple cryptos to other cryptos, and they are all trading at different prices, how do you know how much to send of each and how much to pay to each employee?
- In order to correctly price the asset denominations for payments, the Pyth network can be used as an oracle for swap rates between crypto trading pairs. This will allow the business to choose which underlying asset each the reserve or payment assets will be priced in. So that payments can be priced relative to stablecoins, bitcoin, etc...
Bridging service:
- Bitsui.io: bitcoin-sui bridge; sui-wrapped bitcoin

Treasury and Payment modules
- Reference: https://docs.sui.io/references/framework/sui-framework/balance 
- Coin reference: https://docs.sui.io/standards/coin 
- Standard library modules
    - Supply<T>
    - Balance<T>
    - Coin https://docs.sui.io/standards/coin
    - Closed-Loop token (tokens with programmable rules)
    - The Rule module (in closed-loop token standard) is used to define rules for token transactions
    - TokenPolicy

Interfaces
- Authorized Transaction interface; contains methods for checking entitlement before completing a transaction


Experiments
- Create an experimental Payment object
- Create a simple object with a Coin field, and 

