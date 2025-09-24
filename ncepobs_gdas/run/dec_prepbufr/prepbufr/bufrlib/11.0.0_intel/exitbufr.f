/* Copyright (C) 1991-2012 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */


/* This header is separate from features.h so that the compiler can
   include it implicitly at the start of every compilation.  It must
   not itself include <features.h> or any other header that includes
   <features.h> because the implicit include comes before any feature
   test macros that may be defined in a source file before it first
   explicitly includes a system header.  GCC knows the name of this
   header in order to preinclude it.  */

/* We do support the IEC 559 math functionality, real and complex.  */

/* wchar_t uses ISO/IEC 10646 (2nd ed., published 2011-03-15) /
   Unicode 6.0.  */

/* We do not support C11 <threads.h>.  */

	SUBROUTINE EXITBUFR

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    EXITBUFR
C   PRGMMR: ATOR             ORG: NCEP       DATE: 2015-03-02
C
C ABSTRACT:  THIS SUBROUTINE FREES ALL DYNAMICALLY-ALLOCATED MEMORY,
C   CLOSES ALL LOGICAL UNITS THAT ARE OPEN TO THE BUFR ARCHIVE LIBRARY,
C   AND RESETS THE LIBRARY TO ALL OF ITS DEFAULT SETTINGS AS THOUGH IT
C   HAD NEVER BEEN CALLED.  THIS ALLOWS AN APPLICATION PROGRAM TO
C   POTENTIALLY RE-ALLOCATE MEMORY ALL OVER AGAIN WITHIN THE BUFR
C   ARCHIVE LIBRARY VIA A NEW SUBSEQUENT SERIES OF CALLS TO
C   SUBROUTINES ISETPRM AND OPENBF.
C
C   NOTE THAT ONCE THIS SUBROUTINE IS CALLED, THE ENTIRE BUFR ARCHIVE
C   LIBRARY IS UNUSABLE FOR THE REMAINDER OF THE LIFE OF THE
C   APPLICATION PROGRAM, UNLESS AND UNTIL SUBROUTINE OPENBF IS
C   CALLED TO ONCE AGAIN DYNAMICALLY ALLOCATE NEW ARRAY SPACE.
C
C PROGRAM HISTORY LOG:
C 2015-03-02  J. ATOR    -- ORIGINAL AUTHOR
C
C USAGE:    CALL EXITBUFR
C
C REMARKS:
C    THIS ROUTINE CALLS:        ARDLLOCF
C    THIS ROUTINE IS CALLED BY: None
C                               Normally called only by application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$


	USE MODA_STBFR
	USE MODA_IFOPBF
	USE MODA_S01CM
	
	INCLUDE 'bufrlib.prm'

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C	Close any logical units that are open to the library.

	DO JJ = 1, NFILES
	  IF ( IOLUN(JJ) .NE. 0 ) CALL CLOSBF( ABS(IOLUN(JJ)) )
	END DO

C	Deallocate all allocated memory.

	CALL ARDLLOCF

C	Reset the library.

	NS01V = 0
	IFOPBF = 0


	RETURN
	END
