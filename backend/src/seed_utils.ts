export const dataPath = "../../data/data_preparation/csv/"

export function normalizeValue(value: any) {
    return typeof value === "string" && value.trim() === "" ? null : value;
}

export function printDiff(oldRow: any, newRow: any) {
    for (const key in newRow) {
        const oldVal = oldRow[key];
        const newVal = newRow[key];
        if (String(oldVal) !== String(newVal)) {
            console.log(`  • ${key}:\n    - before: ${oldVal}\n    + after:  ${newVal}`);
        }
    }
}
