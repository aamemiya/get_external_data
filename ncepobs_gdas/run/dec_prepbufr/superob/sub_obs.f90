module sub_obs
use setup

contains
!-----------------------------------------------------------------------
! Basic modules for observation input
!-----------------------------------------------------------------------
SUBROUTINE get_nobs(cfile,nrec,nn)
  IMPLICIT NONE
  CHARACTER(*),INTENT(IN) :: cfile
  INTEGER,INTENT(IN) :: nrec
  INTEGER,INTENT(OUT) :: nn
  REAL(r_sngl),ALLOCATABLE :: wk(:)
!  INTEGER :: ios
!  INTEGER :: iu,iv,it,iq,irh,ips,itc
  INTEGER :: iunit
  LOGICAL :: ex
  INTEGER :: sz

  ALLOCATE(wk(nrec))
  nn = 0
!  iu = 0
!  iv = 0
!  it = 0
!  iq = 0
!  irh = 0
!  ips = 0
!  itc = 0
  iunit=91
  INQUIRE(FILE=cfile,EXIST=ex)
  IF(ex) THEN
    OPEN(iunit,FILE=cfile,FORM='unformatted',ACCESS='sequential')

! get file size by reading through the entire file... too slow for big files
!-----------------------------
!    DO
!      READ(iunit,IOSTAT=ios) wk
!      IF(ios /= 0) EXIT
!!      SELECT CASE(NINT(wk(1)))
!!      CASE(id_u_obs)
!!        iu = iu + 1
!!      CASE(id_v_obs)
!!        iv = iv + 1
!!      CASE(id_t_obs,id_tv_obs)
!!        it = it + 1
!!      CASE(id_q_obs)
!!        iq = iq + 1
!!      CASE(id_rh_obs)
!!        irh = irh + 1
!!      CASE(id_ps_obs)
!!        ips = ips + 1
!!      CASE(id_tclon_obs)
!!        itc = itc + 1
!!      END SELECT
!      nn = nn + 1
!    END DO

! get file size by INQUIRE statement... may not work for some older fortran compilers
!-----------------------------
    INQUIRE(UNIT=iunit, SIZE=sz)
    IF (MOD(sz, r_sngl * (nrec+2)) /= 0) THEN
      WRITE(6,'(3A)') '[Warning]',cfile,': Reading error -- skipped'
      RETURN
    END IF
    nn = sz / (r_sngl * (nrec+2))
!-----------------------------

    WRITE(6,'(I10,A)') nn,' OBSERVATIONS INPUT'
!    WRITE(6,'(A12,I10)') '          U:',iu
!    WRITE(6,'(A12,I10)') '          V:',iv
!    WRITE(6,'(A12,I10)') '      T(Tv):',it
!    WRITE(6,'(A12,I10)') '          Q:',iq
!    WRITE(6,'(A12,I10)') '         RH:',irh
!    WRITE(6,'(A12,I10)') '         Ps:',ips
!    WRITE(6,'(A12,I10)') '   TC TRACK:',itc
    CLOSE(iunit)
  ELSE
    WRITE(6,'(2A)') cfile,' does not exist -- skipped'
  END IF
  DEALLOCATE(wk)

  RETURN
END SUBROUTINE get_nobs




SUBROUTINE read_obs(cfile,obs)
  IMPLICIT NONE
  CHARACTER(*),INTENT(IN) :: cfile
  TYPE(obs_info),INTENT(INOUT) :: obs
  REAL(r_sngl) :: wk(8)
  REAL(r_size) :: x, y
  INTEGER :: n,iunit

  iunit=91
  OPEN(iunit,FILE=cfile,FORM='unformatted',ACCESS='sequential', convert='big_endian')
  DO n=1,obs%nobs
    READ(iunit) wk
    SELECT CASE(NINT(wk(1)))
    CASE(id_u_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
    CASE(id_v_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
    CASE(id_t_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
    CASE(id_tv_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
    CASE(id_q_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
    CASE(id_ps_obs)
      wk(5) = wk(5) * 100.0 ! hPa -> Pa
      wk(6) = wk(6) * 100.0 ! hPa -> Pa
    CASE(id_rh_obs)
      wk(4) = wk(4) * 100.0 ! hPa -> Pa
      wk(5) = wk(5) * 0.01 ! percent input
      wk(6) = wk(6) * 0.01 ! percent input
    END SELECT
    obs%elm(n) = NINT(wk(1))
    obs%lon(n) = REAL(wk(2),r_size)
    obs%lat(n) = REAL(wk(3),r_size)
    obs%lev(n) = REAL(wk(4),r_size)
    obs%dat(n) = REAL(wk(5),r_size)
    obs%err(n) = REAL(wk(6),r_size)
    obs%typ(n) = NINT(wk(7))
    obs%dif(n) = REAL(wk(8),r_size)
  END DO
  CLOSE(iunit)

  RETURN
END SUBROUTINE read_obs

!-----------------------------------------------------------------------
! Coordinate conversion (plus extended vertical levels)
!-----------------------------------------------------------------------
subroutine phys2ijk(p_full,elem,rlon,rlat,rlev,ri,rj,rk)
  IMPLICIT NONE
  REAL(r_size),INTENT(IN) :: p_full(nlon,nlat,nlev)
  REAL(r_size),INTENT(IN) :: elem
  REAL(r_size),INTENT(IN) :: rlon
  REAL(r_size),INTENT(IN) :: rlat
  REAL(r_size),INTENT(IN) :: rlev ! pressure levels
  REAL(r_size),INTENT(OUT) :: ri
  REAL(r_size),INTENT(OUT) :: rj
  REAL(r_size),INTENT(OUT) :: rk
  REAL(r_size) :: aj,ak
  REAL(r_size) :: lnps(nlon,nlat)
  REAL(r_size) :: plev(nlev)
  INTEGER :: i,j,k
!
! rlon -> ri
!
  IF(rlon == 0.0 .OR. rlon == 360.0) THEN
    ri = REAL(nlon+1,r_size)
  ELSE
    ri = rlon / 360.0d0 * REAL(nlon,r_size) + 1.0d0
  END IF
  IF(CEILING(ri) < 2 .OR. nlon+1 < CEILING(ri)) RETURN
!
! rlat -> rj
!
  DO j=1,nlat
    IF(rlat < lat(j)) EXIT
  END DO
  IF(j == 1) THEN
    rj = (rlat + 90.0d0) / (lat(1) + 90.0d0)
  ELSE IF(j == nlat+1) THEN
    aj = (rlat - lat(nlat)) / (90.0d0 - lat(nlat))
    rj = REAL(nlat,r_size) + aj
  ELSE
    aj = (rlat - lat(j-1)) / (lat(j) - lat(j-1))
    rj = REAL(j-1,r_size) + aj
  END IF
  IF(CEILING(rj) < 2 .OR. nlat < CEILING(rj)) RETURN
!
! rlev -> rk
!
  IF(NINT(elem) > 9999) THEN ! surface observation
    rk = 0.0d0
  ELSE
    !
    ! horizontal interpolation
    !
    i = CEILING(ri)
    j = CEILING(rj)
    DO k=1,nlev
      IF(i <= nlon) THEN
        lnps(i-1:i,j-1:j) = LOG(p_full(i-1:i,j-1:j,k))
      ELSE
        lnps(i-1,j-1:j) = LOG(p_full(i-1,j-1:j,k))
        lnps(1,j-1:j) = LOG(p_full(1,j-1:j,k))
      END IF
      CALL itpl_2d(lnps,ri,rj,plev(k))
    END DO
    !
    ! Log pressure
    !
    rk = LOG(rlev)
    !
    ! find rk
    !
    DO k=2,nlev
      IF(plev(k) < rk) EXIT ! assuming descending order of plev
    END DO
    ak = (rk - plev(k-1)) / (plev(k) - plev(k-1))
    rk = REAL(k-1,r_size) + ak
  END IF
end subroutine phys2ijk

!-----------------------------------------------------------------------
! Interpolation
!-----------------------------------------------------------------------
SUBROUTINE itpl_2d(var,ri,rj,var5)
  IMPLICIT NONE
  REAL(r_size),INTENT(IN) :: var(nlon,nlat)
  REAL(r_size),INTENT(IN) :: ri
  REAL(r_size),INTENT(IN) :: rj
  REAL(r_size),INTENT(OUT) :: var5
  REAL(r_size) :: ai,aj
  INTEGER :: i,j

  i = CEILING(ri)
  ai = ri - REAL(i-1,r_size)
  j = CEILING(rj)
  aj = rj - REAL(j-1,r_size)

  var5 = var(i-1,j-1) * (1-ai) * (1-aj) &
     & + var(i  ,j-1) *    ai  * (1-aj) &
     & + var(i-1,j  ) * (1-ai) *    aj  &
     & + var(i  ,j  ) *    ai  *    aj

  RETURN
END SUBROUTINE itpl_2d



end module sub_obs
