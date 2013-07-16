Object subclass: DebugInformation [

    DebugInformation class >> variables: anArray [
        <category: 'instance creation'>

        ^ self new
            variables: anArray;
            yourself
    ]

    | variables |

    variables: anArray [
        <category: 'initialization'>

        variables := anArray.
    ]

    variables [
        <category: 'accessing'>

        ^ variables
    ]

    arguments: anInteger [
        <category: 'accessing'>

        ^ variables copyFrom: 1 to: anInteger
    ]

    temporaries: anInteger [
        <category: 'accessing'>

        ^ variables copyFrom: anInteger + 1 to: variables size
    ]
]
