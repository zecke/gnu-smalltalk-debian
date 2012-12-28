/******************************* -*- C -*- ****************************
 *
 *      Subprocess handling
 *
 *
 ***********************************************************************/
/***********************************************************************
 *
 * Copyright 2012 Free Software Foundation, Inc.
 * Written by Holger Hans Peter Freyther.
 *
 * Forking code from libgst/sysdep/posix/files.c:
 * Copyright 1988,89,90,91,92,94,95,99,2000,2001,2002,2003,2006,2007,2008,2009
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later
 * version.
 *
 * Linking GNU Smalltalk statically or dynamically with other modules is
 * making a combined work based on GNU Smalltalk.  Thus, the terms and
 * conditions of the GNU General Public License cover the whole
 * combination.
 *
 * In addition, as a special exception, the Free Software Foundation
 * give you permission to combine GNU Smalltalk with free software
 * programs or libraries that are released under the GNU LGPL and with
 * independent programs running under the GNU Smalltalk virtual machine.
 *
 * You may copy and distribute such a system following the terms of the
 * GNU GPL for GNU Smalltalk and the licenses of the other code
 * concerned, provided that you include the source code of that other
 * code when and as the GNU GPL requires distribution of source code.
 *
 * Note that people who make modified versions of GNU Smalltalk are not
 * obligated to grant this special exception for their modified
 * versions; it is their choice whether to do so.  The GNU General
 * Public License gives permission to release a modified version without
 * this exception; this exception also makes it possible to release a
 * modified version which carries forward this exception.
 *
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 ***********************************************************************/

#include "gstpub.h"

#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

#include <errno.h>
#include <unistd.h>

static VMProxy *vmProxy;

typedef struct st_OSProcess {
  OBJ_HEADER;
  OOP pid;
  OOP _stdin;
  OOP _stdout;
} *OSProcess;

static pid_t
gst_fork_and_exec (OOP self, const char *cmd, char * const argv[], OOP in, OOP out)
{
  /*
   * TODO: The SIGCHLD handler needs to be installed by gst! It is depending
   * on various usages!
   *
   * The whole code should be moved into the sysdeps and use waitpid with a
   * queue like done for file-io to raise a semaphore once a process has
   * entered.
   * The forking code is taken from sysdep/posix/files.c
   */

  int stdin_pipe[2];
  int stdout_pipe[2];

  int result;

  result = socketpair (AF_UNIX, SOCK_STREAM, 0, stdin_pipe);
  if (result == -1)
    return -1;
  result = socketpair (AF_UNIX, SOCK_STREAM, 0, stdout_pipe);
  if (result == -1) {
    close(stdin_pipe[0]);
    close(stdin_pipe[1]);
    return -1;
  }

  /* TODO: create a pipe with close on exec to check if the process runs? */

  /* We suppose it is a system that has fork.  */
  result = fork ();
  if (result == 0)
    {
      /* Child process */
      close (stdin_pipe[0]);
      close (stdout_pipe[0]);

      /* Setup file descriptor */
      dup2 (stdin_pipe[1], STDIN_FILENO);
      dup2 (stdout_pipe[1], STDOUT_FILENO);
      close (stdin_pipe[1]);
      close (stdout_pipe[1]);

      /* stderr is still going to the main stream */
      /* close other fds? */

      execvp(cmd, argv);

      _exit (-1);
      /*NOTREACHED*/
    }

  /* now close the client side of the socket.. */
  close (stdin_pipe[1]);
  close (stdout_pipe[1]);

  if (result == -1)
    {
      int save_errno;
      save_errno = errno;
      /* forking failed */
      close (stdin_pipe[0]);
      close (stdout_pipe[0]);
      errno = save_errno;
      return (-1);
    }


    /* trying to return information */
    vmProxy->strMsgSend(in, "setFD:", vmProxy->intToOOP(stdin_pipe[0]), NULL);
    vmProxy->strMsgSend(out, "setFD:", vmProxy->intToOOP(stdout_pipe[0]), NULL);
    return result;
}

void
gst_initModule (VMProxy * proxy)

{
  vmProxy = proxy;
  vmProxy->defineCFunc ("gst_osprocess_fork_and_exec", gst_fork_and_exec);
}
