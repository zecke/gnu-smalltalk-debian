"======================================================================
|
|   Load packages from a directory without loading a Star file.
|
|
 ======================================================================"

"======================================================================
|
| Copyright 2013
| Free Software Foundation, Inc.
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

Namespace current: Kernel [

ExternalPackage subclass: DirPackage [
    <category: 'Language-Packaging'>
    <comment: 'I can parse a package.xml from a directort and treat it
    like a package. This allows loading packages from a directory without
    the need of zipping them first.'>

    DirPackage class >> file: aFile [
        ^ self new
            file: aFile;
            yourself
    ]

    directory [
        ^ self file asFile directory.
    ]

    name [
        "Pick the name of the loaded package"
        ^ self loadedPackage name.
    ]

    loadedPackage [
        <category: 'accessing'>
        | file package |
        loadedPackage isNil ifFalse: [^loadedPackage].
        file := self file asFile.
        package := Package parse: file readStream.
        package isNil
            ifTrue: [^self error: 'invalid disabled-package tag inside a star file'].
        package relativeDirectory: file directory.
        package baseDirectories: {file directory}.
        package name isNil
            ifTrue: [^self error: 'package name must not be nil'].
        loadedPackage := package.
        ^loadedPackage
    ]
]

PackageContainer subclass: DirPackageContainer [

    <category: 'Language-Packaging'>
    <comment: 'I hold a list of parsed packages.'>

    DirPackageContainer class >> on: aPackage [
        <category: 'creation'>
        ^ self new
            add: aPackage;
            yourself
    ]

    add: aPackage [
        <category: 'addition'>

        self packages
                at: aPackage name, '.dir' put: aPackage.
    ]

    refresh: aDate [
        "no op.. packages contain what we need"
    ]
]

]

PackageLoader class extend [

    dirPackages [
        | container |

        <category: '*Language-Kernel'>

        "Check if there is already a container"
        root do: [:each |
            each class = Kernel.DirPackageContainer
                ifTrue: [^each].
        ].

        container := Kernel.DirPackageContainer new.
        root add: container.
        ^ container.
    ]

    loadPackageFromFile: aFileName [
        | package |
        <category: '*Language-Kernel'>

        "Make sure that root is initialized."
        self refresh.

        "Add the 'directory' to the packages"
        package := Kernel.DirPackage file: aFileName.

        self dirPackages add: package.

        "And now file it in. Do not use >>fileIn as it will
        attempt to load the package by name."
        self fileInPackages: package prerequisites.
        package primFileIn.
    ]
]
