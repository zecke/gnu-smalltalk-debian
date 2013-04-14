"======================================================================
|
|   Linting for Monticello export
|
|
 ======================================================================"

"======================================================================
|
| Copyright 2013 Free Software Foundation, Inc.
| Written by Holger Hans Peter Freyther.
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


Tooling.EmittedClass extend [
    isComplete [
        <category: 'accessing'>
        ^ isComplete
    ]

    methodsToEmit [
        <category: 'accessing'>
        ^ methodsToEmit
    ]

    classMethodsToEmit [
        <category: 'accessing'>
        ^ classMethodsToEmit
    ]

    isComplete [
        <category: 'accessing'>
        ^ isComplete
    ]
]

Object subclass: Monticello [
    | loader package errors |
    <category: 'Tooling-Lint-Monticello'>

    Monticello class >> lint: aPackage [
        "Work on a given package."
        ^ self new
            loadPackage: aPackage;
            lint.
    ]

    loadPackage: aPackage [
        package := aPackage.
        loader := Tooling.Loader new.

        self lintFiles: aPackage fileIns.
        aPackage test ifNotNil: [
            self lintFiles: aPackage test fileIns].
    ]

    lintFiles: aList [
        | files |

        files := package fullPathsOf: aList.
        files do: [:each | | file |
            file := each open: FileStream read.
            loader parseSmalltalkStream: file with: STInST.GSTFileInParser.
            file close.
        ]
    ]

    loader [
        <category: 'private'>
        ^ loader
    ]

    lint [
        <category: 'lint'>
        "TODO: this should use the visitor..."
        loader stuffToEmit do: [:each |
            each isEmittedClass ifTrue: [self lintClass: each]].
    ]

    lintClass: aClass [
        <category: 'lint'>
        aClass isComplete
            ifTrue: [self lintCompleteClass: aClass]
            ifFalse: [self lintExtension: aClass].
    ]

    lintCompleteClass: aClass [
        <category: 'lint'>
        "Check if the package name is in the category"
        (aClass forClass category startsWith: package name)
            ifFalse: [self addError: 'Class does not begin with package name'
                                for: aClass forClass].
    ]

    lintExtension: aClass [
        <category: 'lint'>

        aClass methodsToEmit do: [:each |
            self lintExtensionMethod: each on: aClass].
        aClass classMethodsToEmit do: [:each |
            self lintExtensionMethod: each on: aClass ].
    ]

    lintExtensionMethod: aSymbol on: aClass [
        | method |
        <category: 'lint'>
        method := aClass forClass >> aSymbol.
        (method methodCategory startsWith: ('*', package name))
            ifFalse: [self addError: 'Method does not beging with *package-name'
                                for: aClass forClass method: aSymbol].
    ]

    addError: aString for: aClass method: aMethod [
        <category: 'error-handling'>
        self errors add: '%1 on %2>>%3' % {aString. aClass name asString. aMethod}.
    ]

    addError: aString for: aClass [
        <category: 'error-handling'>
        self errors add: '%1 on %2' % {aString. aClass name asString}.
    ]

    errors [
        <category: 'error-handling'>
        ^ errors ifNil: [errors := OrderedCollection new].
    ]

    printErrors [
        <category: 'error-handling'>
        self errors do: [:each |
            Transcript nextPutAll: each; nl.]
    ]
]
