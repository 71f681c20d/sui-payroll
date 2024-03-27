/**
 * Wrapper for sui move smart contracts
 * Should this be a service or a class?
 * The class has a private method. Will exporting a function compromise security?
 */
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { PACKAGE_ID, SUI_CLIENT } from "./SuiClient";
import EmployeeModel from '@/Models/Employee';

// a service to interact with the smart contract using SUI SDK
export class EmployerService  {

    private async makeMoveCall(txData: any, txb: TransactionBlock) {
        const keypair = AuthService.getEd25519Keypair();
        const sender = AuthService.walletAddress()
        txb.setSender(sender);
        txb.moveCall(txData);
        const { bytes, signature: userSignature } = await txb.sign({
            client: SUI_CLIENT,
            signer: keypair,
        });
        const zkLoginSignature = await AuthService.generateZkLoginSignature(userSignature);
        return SUI_CLIENT.executeTransactionBlock({
            transactionBlock: bytes,
            signature: zkLoginSignature,
        });
    }

    async addEmployee(employee: EmployeeModel) {
        const txb = new TransactionBlock();
        const txData = {
            target: `${PACKAGE_ID}::employer::add_employee`,
            arguments: [
                txb.pure.string(employee.firstName),
                txb.pure.string(employee.lastName),
                txb.pure.string(employee.email),
                txb.pure.u32(employee.salary),
            ]
        };
        return this.makeMoveCall(txData, txb);
    }
}

