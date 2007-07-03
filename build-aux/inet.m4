dnl I'd like this to be edited in -*- Autoconf -*- mode...
dnl
AC_DEFUN([GST_INET_SOCKETS], [

AC_SEARCH_LIBS(listen, socket, [], [
    dnl Check for listen on MinGW. We need to include <winsock.h>
    dnl to get the correct __stdcall name decoration
    AC_MSG_CHECKING([For listen in -lwsock32])
    OLD_LIBS="$LIBS"
    LIBS="-lwsock32 $LIBS"
    AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <winsock.h>]],[[listen(0,0);]])],
                   [ac_cv_lib_wsock32_listen=yes
                    AC_MSG_RESULT(yes)],
                   [LIBS="$OLD_LIBS"
                    AC_MSG_RESULT(no)])])
AC_SEARCH_LIBS(gethostbyname, nsl)

gst_cv_inet_sockets=yes
AC_CHECK_FUNC(socket, , gst_cv_inet_sockets=no)
AC_CHECK_HEADER(netinet/in.h, , gst_cv_inet_sockets=no)
AC_CHECK_HEADER(arpa/inet.h, , gst_cv_inet_sockets=no)
if test $gst_cv_inet_sockets = yes || test $ac_cv_lib_wsock32_listen = yes; then
  AC_DEFINE(HAVE_INET_SOCKETS, 1, [Define if your system's sockets provide access to the Internet.])
fi

])dnl
