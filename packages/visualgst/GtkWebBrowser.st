GtkMainWindow subclass: GtkWebBrowser [
    | webview workspaceNb notebook browserWindows workspaceWindows windowsMenu |

    GtkWebBrowser class >> openOn: aString [
        <category: 'user interface'>

        ^ (self openSized: 450@375)
	    url: aString
    ]

    GtkWebBrowser class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    aboutBrowser [
	<category: 'help events'>

	GTK.Gtk showAboutDialog: nil varargs: {
	    'version' . VisualGST version.
	    'license' . VisualGST license.
	    'website' . 'http://le site du gnu'.
	    'comments' . 'This is a GTK+ wrapper for GNU Smalltalk.'.
	    'rogram-name' . 'GNU Smalltalk Launcher' . nil }
	    "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'};"
    ]

    initialize [
	<category: 'initialization'>

	super initialize.
	workspaceNb := 0.
	browserWindows := OrderedCollection new.
	workspaceWindows := OrderedCollection new.
	self
	    title: 'GNU Smalltalk Web Browser';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
    ]

    buildCentralWidget [
	<category: 'intialize-release'>

        webview := GtkWebView new
                        openUrl: 'http://smalltalk.gnu.org/';
                        showAll;
                        yourself.

	^ (GTK.GtkScrolledWindow withChild: webview)
	    showAll; 
	    yourself
    ]

    createEditMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Undo' #undo).
	    #('Redo' #redo).
	    #().
	    #('Cut' #cut).
	    #('Copy' #copy).
	    #('Paste' #paste).
	    #().
	    #('Select all' #selectAll).
	    #().
	    #('Search' #searchClassOrMethod)}
    ]

    createFileMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('New workspace' #newWorkspace).
	    #().
	    #('Open' #open).
	    #('Save' #save).
	    #('Save as...' #saveAs).
	    #().
	    #('Print' #print).
	    #().
	    #('Save image' #saveImage).
	    #('Save image as...' #saveImageAs).
	    #().
	    #('Quit' #quit)}
    ]

    createHelpMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('About Browser' #aboutBrowser).
	    #('About GNU Smalltalk' #aboutGst)}
    ]

    createMenus [
	<category: 'user interface'>

	"self addMenuItem: 'File' withSubmenu: self createFileMenus.
	self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
	self addMenuItem: 'Tools' withSubmenu: self createToolsMenus.
	self addMenuItem: 'Help' withSubmenu: self createHelpMenus"
    ]

    createStatusBar [
	<category: 'user interface'>

	self statusMessage: 'Gtk Launcher'
    ]

    createToolbar [
	<category: 'user interface'>

	self
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-cut');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-copy');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-paste');
	    appendSeparator;
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute' label: 'Do It');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-convert' label: 'Inspect It')
    ]

    createToolsMenus [
	<category: 'user interface'>

	^ self createMenuEntry: 
	    {#('Browser' #classBrowser).
	    #('Browser window' #classBrowserInAWindow).
	    #('Workspace' #workspace).
	    #('Inspector' #gtkInspector).
	    #().
	    #('Smallzilla' #squeakzilla)}
    ]

    cut [
	<category: 'edit events'>
    ]

    copy [
	<category: 'edit events'>
    ]

    paste [
	<category: 'edit events'>
    ]

    selectAll [
	<category: 'edit events'>
    ]

    searchClassOrMethod [
	<category: 'edit events'>

	GtkFinder open
    ]

    url: aString [
	<category: 'webkit events'>

	webview openUrl: aString
    ]
]

