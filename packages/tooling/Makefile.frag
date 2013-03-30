Tooling_FILES = \
packages/tooling/Parser/SourceEntity.st packages/tooling/Parser/SourceClass.st packages/tooling/Parser/SourceComments.st packages/tooling/Parser/SourceEval.st packages/tooling/Parser/Loader.st
$(Tooling_FILES):
$(srcdir)/packages/tooling/stamp-classes: $(Tooling_FILES)
	touch $(srcdir)/packages/tooling/stamp-classes
