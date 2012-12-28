"=====================================================================
|
|   External OSProcess handling
|
|
 ======================================================================"

"======================================================================
|
| Copyright 2012 Free Software Foundation, Inc.
| Written by Holger Hans Peter Freyther
| baesed on work by Gwenael Casaccio
|
| This file is part of the GNU Smalltalk class library.
|
| The GNU Smalltalk class library is free software; you can redistribute it
| and/or modify it under the terms of the GNU Lesser General Public License
| as published by the Free Software Foundation; either version 2.1, or (at
| your option) any later version.
| 
| The GNU Smalltalk class library is distributed in the hope that it will be
| useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
| General Public License for more details.
| 
| You should have received a copy of the GNU Lesser General Public License
| along with the GNU Smalltalk class library; see the file COPYING.LIB.
| If not, write to the Free Software Foundation, 59 Temple Place - Suite
| 330, Boston, MA 02110-1301, USA.  
|
 ======================================================================"

Object subclass: OSProcess [
    | pid stdin stdout |
    <category: 'OSProcess'>

    OSProcess class >> fileDescriptorFamily [
	<category: 'stream-family'>
	^ FileStream
    ]

    OSProcess class >> SIGINT [
	<category: 'signals'>
	^ 2
    ]

    OSProcess class >> SIGKILL [
	<category: 'signals'>
	^ 9
    ]

    OSProcess class >> kill: pid signal: asig [
	<category: 'syscall'>
	<cCall: 'kill' returning: #long args: #(#long #int)>
    ]

    OSProcess class >> waitpid: pid status: anIntPtr options: anInteger [
	<category: 'syscall'>
	<cCall: 'waitpid' returning: #long args: #(#long (#ptr #int) #int)>
    ]

    OSProcess class >> getpid [
	<category: 'syscall'>
	<cCall: 'getpid' returning: #long args: #()>
    ]

    OSProcess class >> getppid [
	<category: 'syscall'>
	<cCall: 'getppid' returning: #long args: #()>
    ]

    OSProcess class >> internalFork: command args: args stdin: outIn stdout: outOut [
	<cCall: 'gst_osprocess_fork_and_exec' returning: #int args: #(#self #string (#ptr #string) #smalltalk #smalltalk #smalltalk)>
    ]

    OSProcess class >> forkAndExec: command args: args [
	| argv i res pid in out|
	<category: 'exec'>

	"From ThisOSOSProcess. Make sure the last item is null terminated"
	argv := (CStringType arrayType: args size + 2) gcNew.
	argv at: 0 put: command.

	"Add all arguments"
	i := 1.
	args do: [:arg |
	    argv at: i put: arg.
	    i := i + 1].

	"Null terminate.. once more"
	argv at: i put: nil.

	"Fork now and get things out of the call."
	in := self fileDescriptorFamily new.
	out := self fileDescriptorFamily new.
	pid := self internalFork: command args: argv
		    stdin: in stdout: out.
	pid < 0
	    ifTrue: [^self error: 'Failed to fork the process'].

	"Initialize the sockets, the fds were set inside the fork"
	in initialize.
	out initialize.

	^ OSProcess new
	    stdin: in;
	    stdout: out;
	    pid: pid;
	    yourself.
    ]

    stdin: aStd [
	<category: 'creation'>
	stdin := aStd.
    ]

    stdout: aStd [
	<category: 'creation'>
	stdout := aStd.
    ]

    pid: aPid [
	<category: 'creation'>
	pid := aPid.
    ]

    stdin [
	<category: 'stream'>
	^ stdin
    ]

    stdout [
	<category: 'stream'>
	^ stdout
    ]

    kill [
	<category: 'termination'>
	^ self sendSignal: self class SIGKILL.
    ]

    sendSignal: aSig [
	<category: 'termination'>
	^ self class kill: pid signal: aSig.
    ]

    close [
	stdin close.
	stdout close.
    ]
]
