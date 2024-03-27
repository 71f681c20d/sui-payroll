import react, { ReactNode } from "react";
import EmployeeModel from "@/Models/Employee";


/**
 * This component is the root component for the Translation Memory Game
 * There are 3 possible pages/states: new_game, in_game, and end_game
 * Each of these states has a corresponding component
 */

export type GameState = {
  employee?: EmployeeModel,
  setEmployee?: Function,
}

export const employerContext = react.createContext<GameState>({});

const Employee = () => {

  const [employee, setEmployee] = react.useState<EmployeeModel>({} as EmployeeModel);
  

  const stateMap = new Map<string, ReactNode>();
//   stateMap.set('new_game', <NewGame />);


  return (
    <>
      <header>
        <h1>
          The Employer portal
        </h1>
      </header>
      <employerContext.Provider
        value={{
            employee, setEmployee,
        }}>
        <div id="employer_root">
          {/* {stateMap.get(currentPage)} */}
        </div>
      </employerContext.Provider>
    </>

  )
}

export default Employee;