Tooling_FILES = \
packages/tooling/Parser/EmittedEntity.st packages/tooling/Parser/EmittedClass.st packages/tooling/Parser/EmittedComments.st packages/tooling/Parser/EmittedEval.st packages/tooling/Parser/Loader.st packages/tooling/Lint/Monticello.st
$(Tooling_FILES):
$(srcdir)/packages/tooling/stamp-classes: $(Tooling_FILES)
	touch $(srcdir)/packages/tooling/stamp-classes
