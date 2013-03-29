GtkScrollTreeWidget subclass: GtkSimpleListWidget [

    GtkSimpleListWidget class >> named: aString [
	<category: 'instance creation'>

	^ self createListWithModel: {{GtkColumnTextType title: aString}}
    ]

    buildTreeView [
        <category: 'user interface'>

        self treeView getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (GTKTools.GtkListModel on: self treeView getModel)
                                        contentsBlock: [ :each | {each displayString} ]
    ]
]

