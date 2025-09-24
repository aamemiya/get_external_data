MODULE common
!=======================================================================
!
! [PURPOSE:] General constants and procedures
!
! [ATTENTION:] This module calls 'SFMT.f90'
!
! [HISTORY:]
!   07/20/2004 Takemasa MIYOSHI  created
!   01/23/2009 Takemasa MIYOSHI  modified for SFMT
!
!=======================================================================
  IMPLICIT NONE
  PUBLIC
!-----------------------------------------------------------------------
! Variable size definitions
!-----------------------------------------------------------------------
  INTEGER,PARAMETER :: r_dble=kind(0.0d0)
  INTEGER,PARAMETER :: r_sngl=kind(0.0e0)
#ifdef LETKFSINGLE
  INTEGER,PARAMETER :: r_size=r_sngl
#else
  INTEGER,PARAMETER :: r_size=r_dble
#endif
!-----------------------------------------------------------------------
! Constants
!-----------------------------------------------------------------------
  REAL(r_size),PARAMETER :: pi=3.1415926535d0
  REAL(r_size),PARAMETER :: gg=9.81d0
  REAL(r_size),PARAMETER :: rd=287.05d0       ! gas constant air (J/kg/K)      GYL
  REAL(r_size),PARAMETER :: rv=461.50d0       ! gas constant H2O (J/kg/K)      GYL
  REAL(r_size),PARAMETER :: cp=1005.7d0       ! spec heat air [p] (J/kg/K)
  REAL(r_size),PARAMETER :: hvap=2.5d6        ! heat of vaporization (J/kg)
  REAL(r_size),PARAMETER :: fvirt=rv/rd-1.0d0 ! parameter for T/Tv conversion  GYL
  REAL(r_size),PARAMETER :: re=6371.3d3
  REAL(r_size),PARAMETER :: r_omega=7.292d-5
  REAL(r_size),PARAMETER :: t0c=273.15d0
  REAL(r_size),PARAMETER :: undef=-9.99d33
  REAL(r_size),PARAMETER :: deg2rad=pi/180.0d0 ! GYL
  REAL(r_size),PARAMETER :: rad2deg=180.0d0/pi ! GYL

END MODULE common
