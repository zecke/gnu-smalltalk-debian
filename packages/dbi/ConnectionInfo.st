"======================================================================
|
| Copyright 2006 Mike Anderson
| Written by Mike Anderson
|
| This is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 2, or (at your option) any later version.
| 
| This code is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| Mumble; see the file COPYING.  If not, write to the Free Software
| Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
|
 ======================================================================
"



Object subclass: ConnectionInfo [
    | scheme driver paramString params |
    
    <category: 'DBI-Framework'>
    <comment: 'A utility class to contain connection info.'>

    ConnectionInfo class >> fromDSN: aDSN [
	"Parse a DSN in the format
         dbi:DriverName:dbname=database_name;host=hostname;port=port where
         dbi is constant, DriverName is the name of the driver, and everything
         else is parameters in the form name1=value1;name2=value2;..."

	<category: 'instance creation'>
	| sm n |
	n := self new.
	sm := ReadStream on: aDSN.
	n scheme: (sm upTo: $:).
	n driver: (sm upTo: $:).
	n paramString: sm upToEnd.
	^n
    ]

    parseParams [
	<category: 'private'>
	params := LookupTable new.
	(paramString subStrings: $;) do: 
		[:p | 
		| kv |
		kv := p subStrings: $=.
		params at: (kv at: 1) put: (kv size > 1 ifTrue: [kv at: 2] ifFalse: [nil])]
    ]

    scheme: aString [
	"Set the scheme; the only supported one is 'dbi'."
	<category: 'accessing'>
	scheme := aString
    ]

    scheme [
	"Answer the scheme; the only supported one is 'dbi'."
	<category: 'accessing'>
	^scheme
    ]

    driver: aString [
	"Set the driver; this is not the driver class."
	<category: 'accessing'>
	driver := aString
    ]

    driver [
	"Answer the driver; this is not the driver class."
	<category: 'accessing'>
	^driver
    ]

    paramString: aString [
	"Set the parameter list."
	<category: 'accessing'>
	paramString := aString.
	params := nil
    ]

    params [
	"Return the parsed parameters in a Dictionary."
	<category: 'accessing'>
	params isNil ifTrue: [self parseParams].
	^params
    ]
]
