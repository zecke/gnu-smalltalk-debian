GTKTools_FILES = \
packages/gtktools/GtkMainWindow.st packages/gtktools/GtkAbstractConcreteWidget.st packages/gtktools/GtkConcreteWidget.st packages/gtktools/GtkEntryDialog.st packages/gtktools/GtkListModel.st packages/gtktools/GtkSidebarWidget.st packages/gtktools/GtkHSidebarWidget.st packages/gtktools/GtkVSidebarWidget.st packages/gtktools/Tests/GtkConcreteWidgetTest.st
$(GTKTools_FILES):
$(srcdir)/packages/gtktools/stamp-classes: $(GTKTools_FILES)
	touch $(srcdir)/packages/gtktools/stamp-classes
