moduleexec_LTLIBRARIES = gst-osprocess.la

AM_CPPFLAGS = -I$(top_srcdir)/libgst -I$(top_srcdir)/lib-src

gst_module_ldflags = -rpath $(moduleexecdir) -release $(VERSION) -module \
        -no-undefined -export-symbols-regex gst_initModule

gst_osprocess_la_SOURCES = gst_osprocess.c
gst_osprocess_la_LDFLAGS = $(gst_module_ldflags)

