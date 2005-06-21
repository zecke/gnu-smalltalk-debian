/******************************** -*- C -*- ****************************
 *
 *	Byte Code optimization & analysis definitions.
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
 *
 ***********************************************************************/


#ifndef GST_OPT_H
#define GST_OPT_H

/* This divides the byte codes of a method in basic blocks, optimizes
   each one, joins the optimized blocks and return a new vector of
   byte codes that contains the stream of optimized byte codes.
   Actual optimization of the basic blocks is optimize_basic_block's
   task; this function takes care of handling basic blocks and
   optimizing jumps (because they span multiple basic blocks). 

   On output, BYTECODES is freed and another vector of bytecodes
   is answered. */
extern bytecodes _gst_optimize_bytecodes (bytecodes bytecodes);

/* This fills a table that says which stack slot is touched by each
   bytecode.  BP points to SIZE bytecodes, POS points to an array that
   is filled with pointers relative to BASE.  In other words, if bp[x]
   writes in the first stack slot, we put pos[x] == &base[0]; if bp[x]
   writes in the second stack slot, we put pos[x] == &base[1], etc. */
extern void _gst_compute_stack_positions (gst_uchar * bp,
					  int size,
					  PTR * base,
					  PTR ** pos);

/* METHODOOP is the OOP for a CompiledMethod or CompiledBlock to be
   analyzed, having SIZE bytecodes.  DEST is an array of SIZE items,
   which on output has non-zero items for jump destinations only: in
   particular, it is positive for a forward jump and negative for a
   backward jump.  */
extern void _gst_analyze_bytecodes (OOP methodOOP,
				    int size,
				    char *dest);

/* This looks at BYTECODES and checks if they could be replaced
   with an optimized return of self, of an instance variable or of
   a literal.  */
extern int _gst_is_simple_return (bytecodes bytecodes) ATTRIBUTE_PURE;

/* This decides whether the block compiled to the BC bytecodes can be
   optimized; LITERALS contains the literals for the given block, and
   is used to check nested blocks: if there are any, they must already
   have had their cleanness set by a call to _gst_check_kind_of_block.

   The answer is a number that identifies the possibility to optimize
   the block: 0 for clean blocks, 1 for a self-contained block (no
   accesses to outer contexts) which however needs to know about self,
   31 for a block containing a method return or a reference to
   thisContext, and another number N for a block that accesses the
   (N-1)th outer context. */
extern int _gst_check_kind_of_block (bytecodes bc,
				     OOP * literals);

/* These specify which bytecodes are pushes or message sends.  Use
   them through the macros below.  */
extern const int _gst_is_send_table[], _gst_is_push_table[];

#define IS_SEND_BYTECODE(b)	_gst_is_send_table[(gst_uchar) (b)]
#define IS_PUSH_BYTECODE(b)	_gst_is_push_table[(gst_uchar) (b)]

/* The values emitted by _gst_analyze_bytecodes. */
#define TOP_UNKNOWN		0
#define TOP_IS_INTEGER		1
#define TOP_IS_NOT_INTEGER	2

#endif /* GST_OPT_H */
