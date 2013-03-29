
GTK.GtkTreeModel class extend [
    createModelWith: anArray [
        <category: '*GTKTools'>

        | model |
        model := OrderedCollection new.
        anArray do: [ :each | model addAll: (each collect: [ :elem | elem kind ]) ].
        model addLast: GTKTools.GtkColumnOOPType kind.
        ^ self new: model size varargs: model asArray
    ]
]

GTK.GtkListStore class extend [
    createModelWith: anArray [
        <category: '*GTKTools'>

        | model |
        model := OrderedCollection new.
        anArray do: [ :each | model addAll: (each collect: [ :elem | elem kind ]) ].
        model addLast: GTKTools.GtkColumnOOPType kind.
        ^ self new: model size varargs: model asArray
    ]
]

GTK.GtkTreeStore class extend [
    createModelWith: anArray [
        <category: '*GTKTools'>

        | model |
        model := OrderedCollection new.
        anArray do: [ :each | model addAll: (each collect: [ :elem | elem kind ]) ].
        model addLast: GTKTools.GtkColumnOOPType kind.
        ^ self new: model size varargs: model asArray
    ]
]


GTK.GtkTreeView class extend [

    createModel: aGtkStoreClass with: anArray [
	<category: '*GTKTools'>

	^ self newWithModel: (aGtkStoreClass createModelWith: anArray)
    ]

    createTreeViewWith: anArray [
	<category: '*GTKTools'>

        ^ self createModel: GtkTreeStore with: anArray
    ]

    createListViewWith: anArray [
        <category: '*GTKTools'>

        ^ self createModel: GtkListStore with: anArray
    ]

    createColumnsOn: aGtkTreeView with: anArray [
        <category: '*GTKTools'>

        | colView i render |
        i := 0.
        anArray do: [ :each |
            colView := GtkTreeViewColumn new.
            each do: [ :column |
            column isVisible ifTrue: [
                colView
                    packStart: (render := column cellRenderer new) expand: false;
                    addAttribute: render attribute: column kindName column: i.
                column hasTitle ifTrue: [ colView setTitle: column title ].
                i := i + 1 ] ].
            aGtkTreeView insertColumn: colView position: -1 ]
    ]

    createListWithModel: anArray [
        <category: '*GTKTools'>

        | view |
        view := self createListViewWith: anArray.
        self createColumnsOn: view with: anArray.
	^ view
    ]

    createTreeWithModel: anArray [
	<category: '*GTKTools'>

	| view |
        view := self createTreeViewWith: anArray.
        self createColumnsOn: view with: anArray.
	^ view
    ]
]

GTK.GtkTreeView extend [
    | model |

    model: aGtkModel [
	<category: 'accessing'>

	model := aGtkModel
    ]

    model [
	<category: 'accessing'>

	^ model
    ]

    selection [
	<category: 'accessing'>

        | iter string |
        (iter := self selectedIter) ifNil: [ ^ self error: 'nothing is selected' ].
	^ (self getModel at: iter) last
    ]

    selections [
	<category: 'accessing'>

	| glist result |
	result := OrderedCollection new.
	(glist := self getSelection getSelectedRows: nil) ifNil: [ ^ result ].
	glist do: [ :each | | iter path |
	    path := each castTo: GTK.GtkTreePath type.
	    iter := self getModel getIter: path.
	    result add: ((self getModel at: iter) last) ].
	^ result
    ]

    select: anObject [
	<category: 'accessing'>

        self getSelection unselectAll.
	self getModel do: [ :elem :iter |
	    elem last = anObject ifTrue: [
                    self scrollToCell: (self getModel getPath: iter) column: nil useAlign: false rowAlign: 0.5 colAlign: 0.5.
                    ^ self getSelection selectIter: iter ] ].
    ]

    selectNth: anInteger [
	<category: 'accessing'>

        | path iter |
        self getSelection unselectAll.
        anInteger = 0 ifTrue: [^self].
        path := GtkTreePath newFromIndices: {anInteger - 1. -1}.
	(self getModel getIter: path) isNil ifTrue: [^self].
        self scrollToCell: path column: nil useAlign: false rowAlign: 0.5 colAlign: 0.5.
        self getSelection selectPath: path
    ]

    selectFirstItem [
	<category: 'accessing'>

	| selection |
	(selection := self getSelection) unselectAll.
        selection unselectAll.
        selection selectIter: self getModel getIterFirst
    ]

    selectLastItem [
	<category: 'accessing'>

	| selection |
	(selection := self getSelection) unselectAll.
	selection unselectAll.
        selection selectIter: self getModel getIterLast
    ]
]
