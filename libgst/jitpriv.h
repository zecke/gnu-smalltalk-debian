/******************************** -*- C -*- ****************************
 *
 *	A few functions that only xlat.c needs to have access to
 *
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright 2001, 2002 Free Software Foundation, Inc.
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
 *
 ***********************************************************************/


#ifndef GST_INTERNAL_H
#define GST_INTERNAL_H

#ifdef USE_JIT_TRANSLATION

/* These are functions that are called by the JIT-compiled code and
   yet are internal to interp.c.  xlat.c needs their addresses so that
   it can store them in the compiled code it generates.  */
typedef void (*internal_func) ();
extern const internal_func _gst_internal_funcs[];

#define PTR_UNWIND_CONTEXT	 _gst_internal_funcs[0]
#define PTR_UNWIND_METHOD	 _gst_internal_funcs[1]
#define PTR_ACTIVATE_NEW_CONTEXT _gst_internal_funcs[2]
#define PTR_PREPARE_CONTEXT	 _gst_internal_funcs[3]
#define PTR_EMPTY_CONTEXT_STACK	 _gst_internal_funcs[4]
#define PTR_LOOKUP_NATIVE_IP	 _gst_internal_funcs[5]
#define PTR_BLOCKCOPY		 _gst_internal_funcs[6]
#endif

#endif /* GST_INTERNAL_H */
