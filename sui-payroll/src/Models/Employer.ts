/**
 * Interface for Employer model
 */
export default interface EmployerModel {
    id: number;
    name: string;
    address: string;
    city: string;
    state: string;
    zip: string;
    phone: string;
    email: string;
    website: string;
    contact: string;
    contactPhone: string;
    contactEmail: string;
    contactTitle: string;
    ein: string;
    stateId: number;
    stateName: string;
    stateAbbreviation: string;
    stateTaxId: string;
    stateUnemploymentId: string;
    stateWorkersCompId: string;
    stateDisabilityId: string;
    stateSuiId: string;
    stateSuiRate: number;
    stateSuiLimit: number;
    stateSuiWageBase: number;
    stateSuiMinRate: number;
    stateSuiMaxRate: number;
    stateSuiMinWageBase: number;
    stateSuiMaxWageBase: number;
    stateSuiMinWageBaseYear: number;
    stateSuiMaxWageBaseYear: number;
    stateSuiMinRateYear: number;
    stateSuiMaxRateYear: number;
    stateSuiMinRateEffectiveDate: string;
    stateSuiMaxRateEffectiveDate: string;
    stateSuiMinWageBaseEffectiveDate: string;
    stateSuiMaxWageBaseEffectiveDate: string;
    stateSuiMinWageBaseYearEffectiveDate: string;
    stateSuiMaxWageBaseYearEffectiveDate: string;
    stateSuiMinRateYearEffectiveDate: string;
    stateSuiMaxRateYearEffectiveDate: string;
    stateSuiMinRateYearExpirationDate: string;
    stateSuiMaxRateYearExpirationDate: string;
    stateSuiMinWageBaseYearExpirationDate: string;
    stateSuiMaxWageBaseYearExpirationDate: string;
    stateSuiMinRateExpirationDate: string;
    stateSuiMaxRateExpirationDate: string;
    stateSuiMinWageBaseExpirationDate: string;
    stateSuiMaxWageBaseExpirationDate: string;
    stateSuiMinRateYearExpirationDateEffectiveDate: string;
    stateSuiMaxRateYearExpirationDateEffectiveDate: string;
}