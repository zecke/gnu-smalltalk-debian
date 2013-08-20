TestCase subclass: TestContextPart [

    testContextStatePrint [
        <category: 'testing'>

        | ctxt stream |
        stream := WriteStream on: String new.
        ctxt := [ : a : b : c | | d e f | d := 21. e := 22. f := 23. thisContext ] value: 1 value: 2 value: 3.
        ctxt printContextStateOn: stream spaces: 2.
        self assert: stream contents = 
'  args:
    a -> 1
    b -> 2
    c -> 3
  temps:
    d -> 21
    e -> 22
    f -> 23
'.
    ]

]
