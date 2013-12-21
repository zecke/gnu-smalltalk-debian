"======================================================================
|
|   Smalltalk in Smalltalk RBScanner tests
|
|
 ======================================================================"

"======================================================================
|
| Copyright 2013 Free Software Foundation, Inc.
| Written by Holger Hans Peter Freyther.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 2, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
| Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
|
 ======================================================================"


TestCase subclass: TestRBScanner [
    <comment: 'I do test the RBScanner/Tokenizer.'>

    testEmbeddedCompiletimeConstant [
        | scanner token value |
        scanner := RBScanner on: '#(##(1))' readStream.

        "Token is the literal"
        token := scanner next.
        self assert: token isLiteral.

        "And the literal should be RBOptimizedToken RBNumberLiteralToken RBSpecialCharacterToken"
        value := token value.
        value inspect.
        self assert: value size equals: 3.
        self assert: value first isOptimized.
        self assert: value second isLiteral.
        self assert: value second value equals: 1.
        self assert: value third isSpecial.
        self assert: value third value equals: $).

        "And we are at the end"
        scanner atEnd printNl.
        self assert: scanner atEnd.
    ]

    testDirectCompiletimeConstant [
        | scanner token |
        scanner := RBScanner on: '##(1)' readStream.

        "Token is for optimized code"
        token := scanner next.
        self assert: token isOptimized.

        "Token is the '1'"
        token := scanner next.
        self assert: token isLiteral.
        self assert: token value equals: 1.

        "Token is the ')'"
        token := scanner next.
        self assert: token isSpecial.
        self assert: token value equals: $).

        "And we are at the end"
        self assert: scanner atEnd.
    ]
]

