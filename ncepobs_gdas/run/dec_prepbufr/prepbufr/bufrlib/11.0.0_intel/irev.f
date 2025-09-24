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

      FUNCTION IREV(N)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    IREV
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: THIS FUNCTION WILL, WHEN THE LOCAL MACHINE IS "LITTLE-
C   ENDIAN" (I.E., USES A RIGHT TO LEFT SCHEME FOR NUMBERING THE BYTES
C   WITHIN A MACHINE WORD), RETURN A COPY OF AN INPUT INTEGER WORD WITH
C   THE BYTES REVERSED.  ALTHOUGH, BY DEFINITION (WITHIN WMO MANUAL
C   306), A BUFR MESSAGE IS A STREAM OF INDIVIDUAL OCTETS (I.E., BYTES)
C   THAT IS INDEPENDENT OF ANY PARTICULAR MACHINE REPRESENTATION, THE
C   BUFR ARCHIVE LIBRARY SOFTWARE OFTEN NEEDS TO INTERPRET ALL OR PARTS
C   OF TWO OR MORE ADJACENT BYTES IN ORDER TO CONSTRUCT AN INTEGER
C   WORD.  BY DEFAULT, THE SOFTWARE USES THE "BIG-ENDIAN" (LEFT TO
C   RIGHT) SCHEME FOR NUMBERING BYTES.  BY REVERSING THE BYTES, IREV
C   ALLOWS THE INTEGER WORD TO BE PROPERLY READ OR WRITTEN (DEPENDING
C   ON WHETHER INPUT OR OUTPUT OPERATIONS, RESPECTIVELY, ARE BEING
C   PERFORMED) ON LITTLE-ENDIAN MACHINES.  IF THE LOCAL MACHINE IS
C   BIG-ENDIAN, IREV SIMPLY RETURNS A COPY OF THE SAME INTEGER THAT WAS
C   INPUT.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C                           DOCUMENTATION
C 2007-01-19  J. ATOR    -- BIG-ENDIAN VS. LITTLE-ENDIAN IS NOW
C                           DETERMINED AT COMPILE TIME AND CONFIGURED
C                           WITHIN BUFRLIB VIA CONDITIONAL COMPILATION
C                           DIRECTIVES
C
C USAGE:    IREV (N)
C   INPUT ARGUMENT LIST:
C     N        - INTEGER: INTEGER WORD WITH BYTES ORDERED ACCORDING TO
C                THE "BIG-ENDIAN" NUMBERING SCHEME
C
C   OUTPUT ARGUMENT LIST:
C     IREV     - INTEGER: INTEGER WORD WITH BYTES ORDERED ACCORDING TO
C                THE NUMBERING SCHEME OF THE LOCAL MACHINE (EITHER
C                "BIG-ENDIAN" OR "LITTLE-ENDIAN", IF "BIG-ENDIAN THEN
C                THIS IS JUST A DIRECT COPY OF N)
C
C REMARKS:
C    THIS ROUTINE CALLS:        None
C    THIS ROUTINE IS CALLED BY: IPKM     IUPM     PKB      PKC
C                               UPBB
C                               Normally not called by any application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      COMMON /HRDWRD/ NBYTW,NBITW,IORD(8)

      CHARACTER*8 CINT,DINT
      EQUIVALENCE(CINT,INT)
      EQUIVALENCE(DINT,JNT)

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      INT = N
      DO I=1,NBYTW
        DINT(I:I) = CINT(IORD(I):IORD(I))
      ENDDO
      IREV = JNT

      RETURN
      END
