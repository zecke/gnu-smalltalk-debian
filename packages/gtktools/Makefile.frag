GTKTools_FILES = \
packages/gtktools/Extensions.st packages/gtktools/GtkMainWindow.st packages/gtktools/GtkAbstractConcreteWidget.st packages/gtktools/GtkConcreteWidget.st packages/gtktools/GtkEntryDialog.st packages/gtktools/GtkListModel.st packages/gtktools/GtkSidebarWidget.st packages/gtktools/GtkHSidebarWidget.st packages/gtktools/GtkVSidebarWidget.st packages/gtktools/GtkScrollTreeWidget.st packages/gtktools/GtkSimpleListWidget.st packages/gtktools/Model/GtkColumnType.st packages/gtktools/Model/GtkColumnTextType.st packages/gtktools/Model/GtkColumnPixbufType.st packages/gtktools/Model/GtkColumnOOPType.st packages/gtktools/Tests/GtkConcreteWidgetTest.st packages/gtktools/Tests/GtkScrollTreeWidgetTest.st packages/gtktools/Tests/GtkSimpleListWidgetTest.st
$(GTKTools_FILES):
$(srcdir)/packages/gtktools/stamp-classes: $(GTKTools_FILES)
	touch $(srcdir)/packages/gtktools/stamp-classes
