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

	SUBROUTINE READMT ( IMT, IMTV, IOGCE, IMTVL )

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    READMT
C   PRGMMR: ATOR            ORG: NP12       DATE: 2009-03-23
C
C ABSTRACT:  THIS SUBROUTINE OPENS AND READS BUFR MASTER TABLES AS
C   SPECIFIED BY THE INPUT ARGUMENTS AND USING ADDITIONAL INFORMATION
C   AS DEFINED IN THE MOST RECENT CALL TO BUFR ARCHIVE LIBRARY
C   SUBROUTINE MTINFO (OR AS DEFINED WITHIN BUFR ARCHIVE LIBRARY
C   SUBROUTINE BFRINI, IF SUBROUTINE MTINFO WAS NEVER CALLED).
C
C PROGRAM HISTORY LOG:
C 2009-03-23  J. ATOR    -- ORIGINAL AUTHOR
C 2014-11-25  J. ATOR    -- ADD CALL TO CPMSTABS FOR ACCESS TO MASTER
C                           TABLE INFORMATION WITHIN C WHEN USING
C                           DYNAMICALLY ALLOCATED ARRAYS
C
C USAGE:    CALL READMT ( IMT, IMTV, IOGCE, IMTVL )
C   INPUT ARGUMENT LIST:
C     IMT      - INTEGER: MASTER TABLE NUMBER
C     IMTV     - INTEGER: MASTER TABLE VERSION NUMBER
C     IOGCE    - INTEGER: ORIGINATING CENTER
C     IMTVL    - INTEGER: LOCAL TABLE VERSION NUMBER
C
C   INPUT FILES:
C     UNITS 98,99  - IF SUBROUTINE MTINFO WAS NEVER CALLED, THEN THESE
C                    LOGICAL UNIT NUMBERS ARE USED BY THIS ROUTINE FOR
C                    OPENING AND READING THE BUFR MASTER TABLES.
C                    ALTERNATIVELY, IF SUBROUTINE MTINFO WAS CALLED,
C                    THEN THE LOGICAL UNIT NUMBERS SPECIFIED IN THE
C                    MOST RECENT CALL TO MTINFO (ARGUMENTS LUNMT1 AND
C                    LUNMT2) ARE USED INSTEAD.
C REMARKS:
C    THIS ROUTINE CALLS:        BORT2    CPMSTABS ERRWRT   ICVIDX
C                               IGETTDI  RDMTBB   RDMTBD
C    THIS ROUTINE IS CALLED BY: READS3
C                               Not normally called by any application
C                               programs but it could be.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

	USE MODA_MSTABS
	USE MODA_RDMTB

	INCLUDE 'bufrlib.prm'

	COMMON /QUIET/  IPRT
	COMMON /MSTINF/ LUN1, LUN2, LMTD, MTDIR

	CHARACTER*20	FMTF
	CHARACTER*100	MTDIR
	CHARACTER*128	BORT_STR
	CHARACTER*132	TBLFIL,STDFIL,LOCFIL1,LOCFIL2
	LOGICAL		FOUND

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C*	Reset the scratch table D index for this master table.

	ITMP = IGETTDI ( 0 )

	IF ( IPRT .GE. 2 ) THEN
        CALL ERRWRT(' ')
	CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
	CALL ERRWRT('BUFRLIB: READMT - OPENING/READING MASTER TABLES')
	ENDIF

C*	Locate and open the master Table B files.  There should be one
C*	file of standard descriptors and one file of local descriptors.

C*	First locate and open the file of standard Table B descriptors.

	IF ( ( IMT .EQ. 0 ) .AND. ( IMTV .LE. 13 ) ) THEN

C*	  For master table 0, version 13 is a superset of all earlier
C*	  versions.

	  STDFIL = MTDIR(1:LMTD) // '/' // 'bufrtab.TableB_STD_0_13'
	ELSE
	  WRITE ( FMTF, '(A,I1,A,I1,A)' )
     .	     '(2A,I', ISIZE(IMT), ',A,I', ISIZE(IMTV), ')'
	  WRITE ( STDFIL, FMTF ) MTDIR(1:LMTD), '/bufrtab.TableB_STD_',
     .	     IMT, '_', IMTV
	ENDIF
	TBLFIL = STDFIL
	IF ( IPRT .GE. 2 ) THEN
	  CALL ERRWRT('Standard Table B:')
	  CALL ERRWRT(TBLFIL)
	ENDIF
	INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	IF ( .NOT. FOUND ) GOTO 900
	OPEN ( UNIT = LUN1, FILE = TBLFIL, IOSTAT = IER )
	IF ( IER .NE. 0 ) GOTO 901

C*	Now locate and open the file of local Table B descriptors.

C*	Use the local table corresponding to the originating center
C*	and local table version number of the current message, if such
C*	a table exists.  Otherwise use the NCEP local table B.

	LOCFIL2 = MTDIR(1:LMTD) // '/' // 'bufrtab.TableB_LOC_0_7_1'
	WRITE ( FMTF, '(A,I1,A,I1,A,I1,A)' )
     .	   '(2A,I', ISIZE(IMT), ',A,I', ISIZE(IOGCE),
     .	   ',A,I',  ISIZE(IMTVL), ')'
	WRITE ( LOCFIL1, FMTF ) MTDIR(1:LMTD), '/bufrtab.TableB_LOC_',
     .	   IMT, '_', IOGCE, '_', IMTVL
	TBLFIL = LOCFIL1
	IF ( IPRT .GE. 2 ) THEN
	  CALL ERRWRT('Local Table B:')
	  CALL ERRWRT(TBLFIL)
	ENDIF
	INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	IF ( .NOT. FOUND ) THEN

C*	  Use the NCEP local table B.

	  TBLFIL = LOCFIL2
	  IF ( IPRT .GE. 2 ) THEN
	    CALL ERRWRT('Local Table B not found, so using:')
	    CALL ERRWRT(TBLFIL)
	  ENDIF
	  INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	  IF ( .NOT. FOUND ) GOTO 900
	ENDIF
	OPEN ( UNIT = LUN2, FILE = TBLFIL, IOSTAT = IER )
	IF ( IER .NE. 0 ) GOTO 901

C*	Read the master Table B files.

	CALL RDMTBB ( LUN1, LUN2, MXMTBB,
     .		      IBMT, IBMTV, IBOGCE, IBLTV,
     .		      NMTB, IBFXYN, CBSCL, CBSREF, CBBW,
     .		      CBUNIT, CBMNEM, CMDSCB, CBELEM )

C*	Close the master Table B files.

	CLOSE ( UNIT = LUN1 )
	CLOSE ( UNIT = LUN2 )

C*	Locate and open the master Table D files.  There should be one
C*	file of standard descriptors and one file of local descriptors.

C*	First locate and open the file of standard Table D descriptors.

	TBLFIL = STDFIL
	TBLFIL(LMTD+15:LMTD+15) = 'D'
	IF ( IPRT .GE. 2 ) THEN
	  CALL ERRWRT('Standard Table D:')
	  CALL ERRWRT(TBLFIL)
	ENDIF
	INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	IF ( .NOT. FOUND ) GOTO 900
	OPEN ( UNIT = LUN1, FILE = TBLFIL, IOSTAT = IER )
	IF ( IER .NE. 0 ) GOTO 901

C*	Now locate and open the file of local Table D descriptors.

C*	Use the local table corresponding to the originating center
C*	and local table version number of the current message, if such
C*	a table exists.  Otherwise use the NCEP local table D.

	TBLFIL = LOCFIL1
	TBLFIL(LMTD+15:LMTD+15) = 'D'
	IF ( IPRT .GE. 2 ) THEN
	  CALL ERRWRT('Local Table D:')
	  CALL ERRWRT(TBLFIL)
	ENDIF
	INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	IF ( .NOT. FOUND ) THEN

C*	  Use the NCEP local table D.

	  TBLFIL = LOCFIL2
	  TBLFIL(LMTD+15:LMTD+15) = 'D'
	  IF ( IPRT .GE. 2 ) THEN
	    CALL ERRWRT('Local Table D not found, so using:')
	    CALL ERRWRT(TBLFIL)
	  ENDIF
	  INQUIRE ( FILE = TBLFIL, EXIST = FOUND )
	  IF ( .NOT. FOUND ) GOTO 900
	ENDIF
	OPEN ( UNIT = LUN2, FILE = TBLFIL, IOSTAT = IER )
	IF ( IER .NE. 0 ) GOTO 901

C*	Read the master Table D files.

	CALL RDMTBD ( LUN1, LUN2, MXMTBD, MAXCD,
     .		      IDMT, IDMTV, IDOGCE, IDLTV,
     .		      NMTD, IDFXYN, CDMNEM, CMDSCD, CDSEQ,
     .		      NDELEM, IEFXYN, CEELEM )
	DO I = 1, NMTD
	  DO J = 1, NDELEM(I)
	    IDX = ICVIDX ( I-1, J-1, MAXCD ) + 1
	    IDEFXY(IDX) = IEFXYN(I,J)
	  ENDDO
	ENDDO

C*	Close the master Table D files.

	CLOSE ( UNIT = LUN1 )
	CLOSE ( UNIT = LUN2 )

	IF ( IPRT .GE. 2 ) THEN
	CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
        CALL ERRWRT(' ')
	ENDIF

C*	Copy the master table information into internal C arrays.

	CALL CPMSTABS ( NMTB, IBFXYN, CBSCL, CBSREF, CBBW, CBUNIT,
     .			CBMNEM, CBELEM, NMTD, IDFXYN, CDSEQ, CDMNEM,
     .			NDELEM, IDEFXY, MAXCD )

	RETURN
900	BORT_STR = 'BUFRLIB: READMT - COULD NOT FIND FILE:'
	CALL BORT2(BORT_STR,TBLFIL)
901	BORT_STR = 'BUFRLIB: READMT - COULD NOT OPEN FILE:'
	CALL BORT2(BORT_STR,TBLFIL)
	END
