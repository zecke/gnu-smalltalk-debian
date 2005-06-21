/******************************** -*- C -*- ****************************
 *
 *	Public interface for binary save/restore module.
 *
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright 1988,89,90,91,92,94,95,99,2000,2001,2002
 * Free Software Foundation, Inc.
 * Written by Steve Byrne.
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


#ifndef GST_SAVE_H
#define GST_SAVE_H

/* Try to open FILENAME for output and writing a snapshot to it, and
   return whether the operation succeeded. */
extern mst_Boolean _gst_save_to_file (const char *fileName);

/* Try to open FILENAME for input and loading a snapshot from it, and
   return whether the operation succeeded. */
extern mst_Boolean _gst_load_from_file (const char *fileName);

#endif /* GST_SAVE_H */
