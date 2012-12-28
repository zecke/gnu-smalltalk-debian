Eval [
PackageLoader fileInPackage: #OSProcess.
[
	(OSProcess.OSProcess forkAndExec: 'ls' args: #('/')) inspect; close.
	stdin next.
] repeat.
]
