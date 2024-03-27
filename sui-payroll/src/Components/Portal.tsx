/**
 * This component is the root component for the Payment Portal
 * This landing page will either direct user to the Employee or Employer portal
 * 
 */
'use client';
import react from "react";
import PortalSelection from "./PortalSelection";
import Employer from "./Employer";
import Employee from "./Employee";


export type PortalState = {
    portalSelection?: string,
    setPortalSelection?: Function,
}

export const portalContext = react.createContext<PortalState>({});


const Portal = () => {

    const [portalSelection, setPortalSelection] = react.useState<string>('');

    return (
        <>
            <header>
                <h1>
                    The Payroll Portal
                </h1>
            </header>
            <portalContext.Provider
                value={{
                    portalSelection, setPortalSelection,
                }}>
                <div id="portal_root">
                    { portalSelection==='' && <PortalSelection /> }
                    { portalSelection==='employer' && <Employer /> }
                    { portalSelection==='employee' && <Employee /> }
                </div>
            </portalContext.Provider>
        </>

    )
}

export default Portal;