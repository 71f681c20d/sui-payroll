import react, { ReactNode } from "react";
import EmployerModel from "@/Models/Employer";
import EmployeeModel from "@/Models/Employee";


/**
 * This component is the root component for the Translation Memory Game
 * There are 3 possible pages/states: new_game, in_game, and end_game
 * Each of these states has a corresponding component
 */

export type GameState = {
  employer?: EmployerModel,
  setEmployer?: Function,
}

export const employerContext = react.createContext<GameState>({});

const Employer = () => {

  const [employer, setEmployer] = react.useState<EmployerModel>({} as EmployerModel);
  

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
            employer, setEmployer,
        }}>
        <div id="employer_root">
          {/* {stateMap.get(currentPage)} */}
        </div>
      </employerContext.Provider>
    </>

  )
}

export default Employer;