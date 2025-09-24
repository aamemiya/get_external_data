module setup

  INTEGER,PARAMETER :: r_dble=kind(0.0d0)
  INTEGER,PARAMETER :: r_sngl=kind(0.0e0)
  INTEGER,PARAMETER :: r_size=r_sngl

  REAL(r_size),PARAMETER :: undef=-9.99d33

  integer, parameter :: nid_obs = 16 ! number of variable types
  integer, parameter :: nobtype = 24 ! number of observation report types
!
! conventional observations
!
  INTEGER,PARAMETER :: id_u_obs=2819
  INTEGER,PARAMETER :: id_v_obs=2820
  INTEGER,PARAMETER :: id_t_obs=3073
  INTEGER,PARAMETER :: id_tv_obs=3074
  INTEGER,PARAMETER :: id_q_obs=3330
  INTEGER,PARAMETER :: id_rh_obs=3331
!
! surface observations codes > 9999
!
  INTEGER,PARAMETER :: id_ps_obs=14593
  INTEGER,PARAMETER :: id_rain_obs=19999
  INTEGER,PARAMETER :: id_tclon_obs=99991  ! TC vital
  INTEGER,PARAMETER :: id_tclat_obs=99992  ! TC vital
  INTEGER,PARAMETER :: id_tcmip_obs=99993  ! TC vital
!
! radar observations
!
  INTEGER,PARAMETER :: id_radar_ref_obs=4001
  INTEGER,PARAMETER :: id_radar_ref_zero_obs=4004
  INTEGER,PARAMETER :: id_radar_vr_obs=4002
  INTEGER,PARAMETER :: id_radar_prh_obs=4003
!
! Himawari-8 (H08) observations
!
  INTEGER,PARAMETER :: id_H08IR_obs=8800

  INTEGER,PARAMETER :: elem_uid(nid_obs)= &
     (/id_u_obs, id_v_obs, id_t_obs, id_tv_obs, id_q_obs, id_rh_obs, &
       id_ps_obs, id_rain_obs, id_radar_ref_obs, id_radar_ref_zero_obs, id_radar_vr_obs, id_radar_prh_obs, &
       id_H08IR_obs, id_tclon_obs, id_tclat_obs, id_tcmip_obs/)

  CHARACTER(3),PARAMETER :: obelmlist(nid_obs)= &
     (/'  U', '  V', '  T', ' Tv', '  Q', ' RH', ' PS', 'PRC', 'REF', 'RE0', ' Vr', 'PRH',&
       'H08', 'TCX', 'TCY', 'TCP'/)

  ! Parameter 'nobtype' is set in common_nml.f90
  CHARACTER(6),PARAMETER :: obtypelist(nobtype)= &
     (/'ADPUPA', 'AIRCAR', 'AIRCFT', 'SATWND', 'PROFLR', &
       'VADWND', 'SATEMP', 'ADPSFC', 'SFCSHP', 'SFCBOG', &
       'SPSSMI', 'SYNDAT', 'ERS1DA', 'GOESND', 'QKSWND', &
       'MSONET', 'GPSIPW', 'RASSDA', 'WDSATR', 'ASCATW', &
       'TMPAPR', 'PHARAD', 'H08IRB', 'TCVITL'/) ! H08
  INTEGER,PARAMETER :: max_obs_info_meta = 3 ! maximum array size for type(obs_info)%meta
  TYPE obs_info
    INTEGER :: nobs = 0
    INTEGER,ALLOCATABLE :: elm(:)
    REAL(r_size),ALLOCATABLE :: lon(:)
    REAL(r_size),ALLOCATABLE :: lat(:)
    REAL(r_size),ALLOCATABLE :: lev(:)
    REAL(r_size),ALLOCATABLE :: dat(:)
    REAL(r_size),ALLOCATABLE :: err(:)
    INTEGER,ALLOCATABLE :: typ(:)
    REAL(r_size),ALLOCATABLE :: dif(:)
    REAL(r_size) :: meta(max_obs_info_meta) = undef
    REAL(r_size),ALLOCATABLE :: ri(:)
    REAL(r_size),ALLOCATABLE :: rj(:)
  END TYPE obs_info

  integer,parameter::nlon=360
  integer,parameter::nlat=181
  integer,parameter::nlev=19

  real(r_size),parameter :: lon(nlon)=(/( 0.0 + 360.0 * real(ilon) / real(nlon) ,  ilon  = 1, nlon )/)
  real(r_size),parameter :: lat(nlat)=(/( -90.0 + 180.0 * real(ilat) / real(nlat) , ilat = 1, nlat )/)
  real(r_size),parameter :: reflev(nlev)=(/( 100000.0 - 5000.0 * real(ilev-1), ilev = 1, nlev )/)  !!! Pa

contains
!-----------------------------------------------------------------------
! Convert a raw obsID to a sequential obsID (1 - nid_obs)
!-----------------------------------------------------------------------
function uid_obs(id_obs)
  implicit none
  integer :: id_obs
  integer :: uid_obs

  select case(id_obs)
  case(id_u_obs)
    uid_obs = 1
  case(id_v_obs)
    uid_obs = 2
  case(id_t_obs)
    uid_obs = 3
  case(id_tv_obs)
    uid_obs = 4
  case(id_q_obs)
    uid_obs = 5
  case(id_rh_obs)
    uid_obs = 6
  case(id_ps_obs)
    uid_obs = 7
  case(id_rain_obs)
    uid_obs = 8
  case(id_radar_ref_obs)
    uid_obs = 9
  case(id_radar_ref_zero_obs)
    uid_obs = 10
  case(id_radar_vr_obs)
    uid_obs = 11
  case(id_radar_prh_obs)
    uid_obs = 12
  case(id_h08ir_obs) ! H08
    uid_obs = 13     ! H08
  case(id_tclon_obs)
    uid_obs = 14
  case(id_tclat_obs)
    uid_obs = 15
  case(id_tcmip_obs)
    uid_obs = 16
  case default
    uid_obs = -1     ! error
  end select
end function uid_obs
!===============================================================================
subroutine print_obsnum (nobs, nobs_cat)
!-------------------------------------------------------------------------------

  implicit none
  integer, intent(in) :: nobs
  integer, intent(in) :: nobs_cat(nid_obs,nobtype+1)
  integer :: itype

  write (*, '(A)') '================================================================================'
  write (*, '(A,I10)') ' TOTAL NUMBER OF OBSERVATIONS:', nobs
  write (*, '(A)') '--------------------------------------------------------------------------------'

  write (*, '(A,8(4x,A3))') '        ', obelmlist
  do itype = 1, nobtype
    write (*, '(A6,A2,8(I7))') obtypelist(itype), ': ', nobs_cat(:,itype)
  end do
  write (*, '(A6,A2,8(I7))') 'OTHERS', ': ', nobs_cat(:,nobtype+1)
  
  write (*, '(A)') '================================================================================'

!-------------------------------------------------------------------------------
end subroutine print_obsnum
!===============================================================================
end module setup
