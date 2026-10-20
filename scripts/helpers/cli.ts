export function runScript(main: () => Promise<unknown>): void {
	void main().catch(error => {
		console.error(error)
		process.exitCode = 1
	})
}
