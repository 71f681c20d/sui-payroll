/**
 * Interface for Employee model
 */
export default interface EmployeeModel {
    id: number;
    firstName: string;
    lastName: string;
    address: string;
    city: string;
    state: string;
    zip: string;
    phone: string;
    email: string;
    ssn: string;
    dob: string;
    salary: number;
}