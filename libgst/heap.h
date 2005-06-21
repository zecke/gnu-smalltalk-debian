/******************************** -*- C -*- ****************************
 *
 *	Header for memory allocation within separate mmap'ed regions
 *
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright 2000, 2001, 2002 Free Software Foundation, Inc.
 * Written by Paolo Bonzini.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later 
 * version.
 * 
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
 ***********************************************************************/


#ifndef GST_HEAP_H
#define GST_HEAP_H

typedef char *heap;

/* Initialize access to a heap managed region.

   On success, returns a "heap descriptor" which is used in subsequent
   calls to other heap package functions.  It is explicitly "char *"
   so that users of the package don't have to worry about the actual
   implementation details.

   On failure returns NULL. */
extern heap _gst_heap_create (int size);

/* Terminate access to a heap managed region by unmapping all memory pages
   associated with the region, and closing the file descriptor if it is one
   that we opened.
  
   Returns NULL on success.
  
   Returns the heap descriptor on failure, which can subsequently be used
   for further action. */
extern heap _gst_heap_destroy (heap hd);

/* Get core for the memory region specified by HD, using SIZE as the
   amount to either add to or subtract from the existing region.  Works
   like sbrk(), but using mmap() if HD is not NULL.  */
extern PTR _gst_heap_sbrk (heap hd,
			   size_t size);

#endif /* GST_HEAP_H */
