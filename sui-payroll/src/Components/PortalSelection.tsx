/**
 * Sets the portal selection for the user to either employer or employee
 */

import react, { useContext } from "react";
import { portalContext } from "./Portal";

const PortalSelection = () => {

    const portalStore = useContext(portalContext);
    const setPortalSelection = portalStore?.setPortalSelection;

    
    const handlePortalSelection = (selection: string) => {
        setPortalSelection? setPortalSelection(selection): console.error('setPortalSelection is not defined');
    }

    return (
        <>
            <p>
                Please select if you are an employer or an employee:
            </p>
            <div id="portal_selection">
                <button onClick={() => {handlePortalSelection('employer')}}>Go To Employer Portal</button>
                <button onClick={() => {handlePortalSelection('employee')}}>Go To Employee Portal</button>

            </div>
        </>

    )
}

export default PortalSelection;