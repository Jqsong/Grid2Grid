MODULE modRead_files_NWT
!
! This module contains the input related routines
!  Subroutines :	init_read_mod
!					read_modes
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
!    Copyright (C) 2014 - LHEEA Lab., Ecole Centrale de Nantes, UMR CNRS 6598
!
!    This program is part of HOS-NWT
!
!    HOS-NWT is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
USE modType
USE modVariables_3d_NWT
!
IMPLICIT NONE
!
!
!
CONTAINS
!
!
!
SUBROUTINE init_read_mod(filename,i_unit,n1,n2,dt_out,T_stop,xlen,ylen,depth)
!
! Initialize data from volumic mode description generated by HOS-NWT
! 
IMPLICIT NONE
!
CHARACTER(LEN=*), INTENT(IN) :: filename
INTEGER, INTENT(IN)          :: i_unit
!
INTEGER, INTENT(OUT)         :: n1,n2
REAL(RP), INTENT(OUT)        :: dt_out,T_stop,xlen,ylen,depth
!
! Local variables
REAL(RP) :: x1, x2, x3
!
! We will look at first eight variables written on 18 characters
OPEN(i_unit,file=filename,status='OLD', FORM='FORMATTED', ACCESS='DIRECT',RECL=18*8)
READ(i_unit,'(8(ES17.10,1X))',REC=1) x1, x3, x2, dt_out, T_stop, xlen, ylen, depth
!
n1     = NINT(x1)
n2     = NINT(x2)
n3_add = NINT(x3)
!
CLOSE(i_unit)
!
END SUBROUTINE init_read_mod
!
!
!
SUBROUTINE read_mod(filename,i_unit,time,dt_out,n1,n2,n3_add, &
	modesspecx,modesspecy,modesspecz,modesspect,modesFS,modesFSt,modesadd,modesaddt)
!
! Initialize data from volumic mode description generated by HOS-NWT
!
IMPLICIT NONE
!
CHARACTER(LEN=*), INTENT(IN) :: filename
INTEGER, INTENT(IN)          :: i_unit, n1, n2, n3_add
REAL(RP), INTENT(IN)         :: time, dt_out
!
REAL(RP), INTENT(OUT), DIMENSION(n1,n2)     :: modesspecx,modesspecy,modesspecz,modesspect,modesFS,modesFSt
REAL(RP), INTENT(OUT), DIMENSION(n3_add,n2) :: modesadd,modesaddt
!
! Local variables
INTEGER :: i1, i2, it
!
! We read the specific records corresponding to time
!
it = NINT(time/dt_out)+1
!
OPEN(i_unit,file=filename,status='OLD', FORM='FORMATTED', ACCESS='DIRECT',RECL=18*n1)
!
DO i2=1,n2
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+1+8*(i2-1)) (modesspecx(i1,i2), i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+2+8*(i2-1)) (modesspecy(i1,i2), i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+3+8*(i2-1)) (modesspecz(i1,i2), i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+4+8*(i2-1)) (modesspect(i1,i2), i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+5+8*(i2-1)) (modesFS(i1,i2)   , i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+6+8*(i2-1)) (modesFSt(i1,i2)  , i1=1,n1)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+7+8*(i2-1)) (modesadd(i1,i2)  , i1=1,n3_add)
	READ(i_unit,'(5000(ES17.10,1X))',REC=((it)*n2*8)+8+8*(i2-1)) (modesaddt(i1,i2) , i1=1,n3_add)
ENDDO
!
CLOSE(i_unit)
!
END SUBROUTINE read_mod
!
!
!
END MODULE modRead_files_NWT