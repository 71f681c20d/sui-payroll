# sui-payroll
A simple payroll app on sui

Stack
- Next/TS front end
- Sui/Move backend

- sui zk groth16 circom zk proofs
- Wormhole bridge integration

What does the app do?
- The app is intended to be used by both employers and employees, although they will each use it differently
- Employers have 
    - A treasury they will use to draw from in order to pay employees
    - A list of employees currently on the payroll and their relevant information; ie employee database on-chain
    - The ability to set an employee start date on the employee-owned object, or termination date
    - A breakdown of employee compensation, such as base salary, bonuses, etc... all other components contributing to an employee's pay
    - An audit trail that can generate a financial statement about compensation, including all the data for event Paycheck object sent
    - The ability to create and transfer new Paycheck objects to employees, drawn from the Treasury (possibly bridged or swapped for stablecoins)
- Employees have
    - Ownership of their own employee object that the employer uses in the database
    - The ability to set their own termination date (if they want to quit)
    - DONT have the ability to hire themselves by setting their own start date
    - A list of Paycheck objects, with each one including all the data you might expect on a paystub, like compensation breakdown etc.. and which can be sent or bridged or do whatever the employee wants to 

Objects
- Employer
- PriviledgedEmployee (HR staff employees)
- Employee
- Paycheck
- Treasury



To do
x Strip down and simplify the frontend
- Read stuff about sui 
- Implement the sui backend
- Connect frontend and backend
- Add zk functionality for private objects
- Add bridge functionality to frontend

