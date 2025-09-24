program main
implicit real(a-h,o-z)

real(4)::wk(8)
character(len=200)::cfile

character(len=14)::ctime

integer::list_obs(6)=(/1,4,3,6,8,9/)

!cfile="superob/2023010100/obs_20230101000000.dat"
cfile="fort.90"

open (21, file=trim(cfile), form='unformatted', access='sequential', convert='big_endian')
!open (21, file=trim(cfile), form='unformatted', access='sequential', convert="little_endian")
ios=0
do while (ios==0)
  read(21,iostat=ios) wk(1:8)
!  if (all(int(wk(7)).ne.list_obs)) then 

!    if (int(wk(7))==20) then

     if(ios/=0) exit
      write(*,'(8F16.4)') wk
!      stop
!    end if
!  end if
end do
close(21)

stop
end program main
