/**
 * Wrapper for the sui cluster
 */
import { SUI_CLIENT } from "./SuiClient";

export class SuiService {
    async getFormattedBalance(owner: string) {
        const res = await SUI_CLIENT.getBalance({
            owner
        });
        return Number(Number(res.totalBalance) / 1000_000_000).toFixed(2);
    }
}
