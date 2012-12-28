OSProcess_FILES = \
packages/osprocess/OSProcess.st packages/osprocess/ChangeLog packages/osprocess/OSProcessTests.st 
$(OSProcess_FILES):
$(srcdir)/packages/osprocess/stamp-classes: $(OSProcess_FILES)
	touch $(srcdir)/packages/osprocess/stamp-classes
