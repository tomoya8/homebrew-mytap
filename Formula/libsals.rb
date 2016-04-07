class Libsals < Formula
  homepage "http://olab.is.s.u-tokyo.ac.jp/archives/sals25/"
  url "http://olab.is.s.u-tokyo.ac.jp/archives/sals25/sals25.tar.gz"
  version "2.5"
  sha1 "f6f6f2276d72b5f1230d00c8633f038b2f91c125"

  depends_on :fortran

  patch :DATA

  def install
    system "make", "FC=#{ENV['FC']}"
    system "make", "install", "prefix=#{prefix}"
    doc.install Dir['doc/*']
    share.install Dir['manual']
    share.install Dir['test']
  end

  test do
    system "make test"
  end
end
__END__
diff -Nur sals25/Makefile sals25a/Makefile
--- sals25/Makefile	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/Makefile	2014-04-06 21:04:44.000000000 +0900
@@ -0,0 +1,17 @@
+all:
+	cd src; make
+	cd srcd; make
+
+install:
+	cd src; make install
+	cd srcd; make install
+
+test:
+	cd test; make test
+
+clean:
+	cd src; make clean
+	cd srcd; make clean
+	cd test; make clean
+
+.PHONY: all install test clean
diff -Nur sals25/Makefile.in sals25a/Makefile.in
--- sals25/Makefile.in	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/Makefile.in	2014-04-06 21:47:33.000000000 +0900
@@ -0,0 +1,36 @@
+SRCS	= sals.f salsex.f lsf.f nonlin.f linls.f linear.f modl.f modelf.f modeld.f modeln.f stat.f out.f dfchek.f
+OBJS	= $(SRCS:.f=.o)
+
+prefix	= /usr/local
+libdir	= $(prefix)/lib
+
+# for G77
+#FC	= g77
+#FFLAGS	= -Wno-globals -O
+
+# for GFORTRAN
+FC	= gfortran
+FFLAGS	= -std=legacy -O
+
+AR 	= ar
+INSTALL	= install -m 644
+
+
+$(TARGET):	$(OBJS)
+	$(AR) rvu $@ $^
+	ranlib $@
+
+$(SRCS):
+	ln -s $* $@
+
+.f.o:
+	$(FC) $(FFLAGS) -c $<
+
+install:	$(TARGET)
+	mkdir -p $(libdir)
+	$(INSTALL) $< $(libdir)
+
+clean:
+	-rm -f *.f *.o *.a *~
+
+.PHONY:	clean
diff -Nur sals25/src/Makefile sals25a/src/Makefile
--- sals25/src/Makefile	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/src/Makefile	2014-04-06 15:51:09.000000000 +0900
@@ -0,0 +1,3 @@
+TARGET  = libsals.a
+
+include ../Makefile.in
diff -Nur sals25/src/modeld sals25a/src/modeld
--- sals25/src/modeld	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/src/modeld	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,37 @@
+C                                                                       00040200
+C                                                                       00040300
+C---  SUBROUTINE  MODELD  -------  (MEMBER  MODL  , SUB. 12 )           00040400
+C                                                                       00040500
+      SUBROUTINE MODELD (LCALCD, NPARA, NDATA, NC, X, COORD, FOBS, F    00040600
+     1                 , RES, DF, LFIX, MDF)                            00040700
+C                                                                       00040800
+C                                                                       00040900
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00041000
+C       MODEL FUNCTION SUBROUTINE WHICH CALCULATES THE JACOBIAN MATRIX  00041100
+C       AND THE MODEL FUNCTIONS.                                        00041200
+C                                                                       00041300
+C     DEBUG 6, SUBCHK                                                   00041400
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00041500
+     1         , RES(NDATA), DF(MDF,NPARA), LFIX(NPARA)                 00041600
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00041700
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00041800
+      WRITE(LOUT1, 6010)                                                00041900
+ 6010 FORMAT(24H0***** ERROR    SALS 753, 5X                            00042000
+     1     , 96HSUBROUTINE MODELD TO CALCULATE MODEL FUNCTIONS AND THEIR00042100
+     2 FIRST DERIVATIVES IS CALLED (LMODEL=2)                           00042200
+     3     /29X,  42HBUT IS NOT SUPPLIED BY THE USER.                   00042300
+     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00042400
+     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00042500
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00042600
+      LSKIP = 2                                                         00042700
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00042800
+      LCALCD = LCALCD                                                   00042900
+      X(1) = X(1)                                                       00043000
+      COORD(1,1) = COORD(1,1)                                           00043100
+      FOBS(1) = FOBS(1)                                                 00043200
+      F(1) = F(1)                                                       00043300
+      RES(1) = RES(1)                                                   00043400
+      DF(1,1) = DF(1,1)                                                 00043500
+      LFIX(1) = LFIX(1)                                                 00043600
+      RETURN                                                            00043700
+      END                                                               00043800
diff -Nur sals25/src/modelf sals25a/src/modelf
--- sals25/src/modelf	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/src/modelf	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,32 @@
+C                                                                       00037000
+C                                                                       00037100
+C---  SUBROUTINE  MODELF  -------  (MEMBER  MODL  , SUB. 11 )           00037200
+C                                                                       00037300
+      SUBROUTINE MODELF (NPARA, NDATA, NC, X, COORD, FOBS, F, RES)      00037400
+C                                                                       00037500
+C                                                                       00037600
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00037700
+C       MODEL FUNCTION SUBROUTINE.                                      00037800
+C                                                                       00037900
+C     DEBUG 6, SUBCHK                                                   00038000
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00038100
+     1         , RES(NDATA)                                             00038200
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00038300
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00038400
+      WRITE(LOUT1, 6010)                                                00038500
+ 6010 FORMAT(24H0***** ERROR    SALS 751, 5X                            00038600
+     1    ,100HSUBROUTINE MODELF TO CALCULATE MODEL FUNCTIONS IS CALLED 00038700
+     2(LMODEL=1) BUT IS NOT SUPPLIED BY THE USER.                       00038800
+     3          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00038900
+     4          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00039000
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00039100
+      LSKIP = 2                                                         00039200
+C                                                                       00039300
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00039400
+      X(1) = X(1)                                                       00039500
+      COORD(1,1) = COORD(1,1)                                           00039600
+      FOBS(1) = FOBS(1)                                                 00039700
+      F(1) = F(1)                                                       00039800
+      RES(1) = RES(1)                                                   00039900
+      RETURN                                                            00040000
+      END                                                               00040100
diff -Nur sals25/src/modeln sals25a/src/modeln
--- sals25/src/modeln	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/src/modeln	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,41 @@
+C                                                                       00043900
+C                                                                       00044000
+C---  SUBROUTINE  MODELN  -------  (MEMBER  MODL  , SUB. 13 )           00044100
+C                                                                       00044200
+      SUBROUTINE MODELN (LCALCN, NPARA, NDATA, NC, X, COORD, FOBS, F    00044300
+     1                 , RES, AWA, AWY, LFIX, FSIE)                     00044400
+C                                                                       00044500
+C                                                                       00044600
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE USER-CODED SUBROUTINE     00044700
+C       WHICH CALCULATES THE NORMAL EQUATION AS WELL AS THE MODEL       00044800
+C       FUNCTIONS.                                                      00044900
+C                                                                       00045000
+C     DEBUG 6, SUBCHK                                                   00045100
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00045200
+     1         , RES(NDATA), AWA(NPARA,NPARA), AWY(NPARA), LFIX(NPARA)  00045300
+     2         , FSIE(NDATA)                                            00045400
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00045500
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00045600
+      WRITE(LOUT1, 6010)                                                00045700
+ 6010 FORMAT(24H0***** ERROR    SALS 755, 5X                            00045800
+     1     , 90HSUBROUTINE MODELN TO CALCULATE MODEL FUNCTIONS AND NORMA00045900
+     2L EQUATION IS CALLED (LMODEL = 4)                                 00046000
+     3     /29X,  32HBUT IS NOT SUPPLIED BY THE USER.                   00046100
+     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00046200
+     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00046300
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00046400
+      LSKIP = 2                                                         00046500
+C                                                                       00046600
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00046700
+      LCALCN = LCALCN                                                   00046800
+      X(1) = X(1)                                                       00046900
+      COORD(1,1) = COORD(1,1)                                           00047000
+      FOBS(1) = FOBS(1)                                                 00047100
+      F(1) = F(1)                                                       00047200
+      RES(1) = RES(1)                                                   00047300
+      AWA(1,1) = AWA(1,1)                                               00047400
+      AWY(1) = AWY(1)                                                   00047500
+      LFIX(1) = LFIX(1)                                                 00047600
+      FSIE(1) = FSIE(1)                                                 00047700
+      RETURN                                                            00047800
+      END                                                               00047900
diff -Nur sals25/src/modl sals25a/src/modl
--- sals25/src/modl	2000-04-19 12:15:46.000000000 +0900
+++ sals25a/src/modl	2014-04-06 13:25:41.000000000 +0900
@@ -375,116 +375,6 @@
    10 CONTINUE                                                          00036700
       RETURN                                                            00036800
       END                                                               00036900
-C                                                                       00037000
-C                                                                       00037100
-C---  SUBROUTINE  MODELF  -------  (MEMBER  MODL  , SUB. 11 )           00037200
-C                                                                       00037300
-      SUBROUTINE MODELF (NPARA, NDATA, NC, X, COORD, FOBS, F, RES)      00037400
-C                                                                       00037500
-C                                                                       00037600
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00037700
-C       MODEL FUNCTION SUBROUTINE.                                      00037800
-C                                                                       00037900
-C     DEBUG 6, SUBCHK                                                   00038000
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00038100
-     1         , RES(NDATA)                                             00038200
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00038300
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00038400
-      WRITE(LOUT1, 6010)                                                00038500
- 6010 FORMAT(24H0***** ERROR    SALS 751, 5X                            00038600
-     1    ,100HSUBROUTINE MODELF TO CALCULATE MODEL FUNCTIONS IS CALLED 00038700
-     2(LMODEL=1) BUT IS NOT SUPPLIED BY THE USER.                       00038800
-     3          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00038900
-     4          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00039000
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00039100
-      LSKIP = 2                                                         00039200
-C                                                                       00039300
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00039400
-      X(1) = X(1)                                                       00039500
-      COORD(1,1) = COORD(1,1)                                           00039600
-      FOBS(1) = FOBS(1)                                                 00039700
-      F(1) = F(1)                                                       00039800
-      RES(1) = RES(1)                                                   00039900
-      RETURN                                                            00040000
-      END                                                               00040100
-C                                                                       00040200
-C                                                                       00040300
-C---  SUBROUTINE  MODELD  -------  (MEMBER  MODL  , SUB. 12 )           00040400
-C                                                                       00040500
-      SUBROUTINE MODELD (LCALCD, NPARA, NDATA, NC, X, COORD, FOBS, F    00040600
-     1                 , RES, DF, LFIX, MDF)                            00040700
-C                                                                       00040800
-C                                                                       00040900
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00041000
-C       MODEL FUNCTION SUBROUTINE WHICH CALCULATES THE JACOBIAN MATRIX  00041100
-C       AND THE MODEL FUNCTIONS.                                        00041200
-C                                                                       00041300
-C     DEBUG 6, SUBCHK                                                   00041400
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00041500
-     1         , RES(NDATA), DF(MDF,NPARA), LFIX(NPARA)                 00041600
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00041700
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00041800
-      WRITE(LOUT1, 6010)                                                00041900
- 6010 FORMAT(24H0***** ERROR    SALS 753, 5X                            00042000
-     1     , 96HSUBROUTINE MODELD TO CALCULATE MODEL FUNCTIONS AND THEIR00042100
-     2 FIRST DERIVATIVES IS CALLED (LMODEL=2)                           00042200
-     3     /29X,  42HBUT IS NOT SUPPLIED BY THE USER.                   00042300
-     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00042400
-     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00042500
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00042600
-      LSKIP = 2                                                         00042700
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00042800
-      LCALCD = LCALCD                                                   00042900
-      X(1) = X(1)                                                       00043000
-      COORD(1,1) = COORD(1,1)                                           00043100
-      FOBS(1) = FOBS(1)                                                 00043200
-      F(1) = F(1)                                                       00043300
-      RES(1) = RES(1)                                                   00043400
-      DF(1,1) = DF(1,1)                                                 00043500
-      LFIX(1) = LFIX(1)                                                 00043600
-      RETURN                                                            00043700
-      END                                                               00043800
-C                                                                       00043900
-C                                                                       00044000
-C---  SUBROUTINE  MODELN  -------  (MEMBER  MODL  , SUB. 13 )           00044100
-C                                                                       00044200
-      SUBROUTINE MODELN (LCALCN, NPARA, NDATA, NC, X, COORD, FOBS, F    00044300
-     1                 , RES, AWA, AWY, LFIX, FSIE)                     00044400
-C                                                                       00044500
-C                                                                       00044600
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE USER-CODED SUBROUTINE     00044700
-C       WHICH CALCULATES THE NORMAL EQUATION AS WELL AS THE MODEL       00044800
-C       FUNCTIONS.                                                      00044900
-C                                                                       00045000
-C     DEBUG 6, SUBCHK                                                   00045100
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00045200
-     1         , RES(NDATA), AWA(NPARA,NPARA), AWY(NPARA), LFIX(NPARA)  00045300
-     2         , FSIE(NDATA)                                            00045400
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00045500
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00045600
-      WRITE(LOUT1, 6010)                                                00045700
- 6010 FORMAT(24H0***** ERROR    SALS 755, 5X                            00045800
-     1     , 90HSUBROUTINE MODELN TO CALCULATE MODEL FUNCTIONS AND NORMA00045900
-     2L EQUATION IS CALLED (LMODEL = 4)                                 00046000
-     3     /29X,  32HBUT IS NOT SUPPLIED BY THE USER.                   00046100
-     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00046200
-     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00046300
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00046400
-      LSKIP = 2                                                         00046500
-C                                                                       00046600
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00046700
-      LCALCN = LCALCN                                                   00046800
-      X(1) = X(1)                                                       00046900
-      COORD(1,1) = COORD(1,1)                                           00047000
-      FOBS(1) = FOBS(1)                                                 00047100
-      F(1) = F(1)                                                       00047200
-      RES(1) = RES(1)                                                   00047300
-      AWA(1,1) = AWA(1,1)                                               00047400
-      AWY(1) = AWY(1)                                                   00047500
-      LFIX(1) = LFIX(1)                                                 00047600
-      FSIE(1) = FSIE(1)                                                 00047700
-      RETURN                                                            00047800
-      END                                                               00047900
 C                                                                       00048000
 C                                                                       00048100
 C---  SUBROUTINE  ZRESCH  -------  (MEMBER  MODL  , SUB. 14 )           00048200
diff -Nur sals25/src/out sals25a/src/out
--- sals25/src/out	2000-04-19 12:16:27.000000000 +0900
+++ sals25a/src/out	2014-04-06 13:25:41.000000000 +0900
@@ -618,7 +618,8 @@
 C     DEBUG 6, SUBCHK                                                   00055000
       COMMON/SCTIME/ CPTIME, ICLOCK(3), IDAY(2)                         00055100
       COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00055200
-      CALL CLOCK(CPTIME, 5)                                             00055300
+C     CALL CLOCK(CPTIME, 5)                                             00055300
+      CALL CPU_TIME(CPTIME)
       IF (NCHAR .LT. 132)  GO TO 60                                     00055500
       IF(L .EQ. 0)  GO TO 10                                            00055600
       IF(L .EQ. 1) GO TO 20                                             00055700
@@ -1027,8 +1028,26 @@
 C 100 FORMAT(I2,1X,I2,1X,I2,1X,I2)                                      00092668
 C                                                                       00092669
 C                                                                       00092670
-      DIMENSION ICLOCK(3)                                               00092700
-      CALL CLOCK(ICLOCK, 1)                                             00092800
+C*    ORIGINAL
+C     DIMENSION ICLOCK(3)                                               00092700
+C     CALL CLOCK(ICLOCK, 1)                                             00092800
+C
+C
+C*    G77 FORTRAN
+C     CHARACTER*4 ICLOCK(3)
+C     CHARACTER*8 TM
+C     CALL TIME(TM)
+C     ICLOCK(1)=TM(1:4)
+C     ICLOCK(2)=TM(5:8)
+C     ICLOCK(3)='    '
+C
+C
+C*    GFORTRAN
+      CHARACTER*12 ICLOCK
+      INTEGER*4 VAL(8)
+      CALL DATE_AND_TIME(VALUES=VAL)
+      WRITE(ICLOCK,100) VAL(5), VAL(6), VAL(7)
+  100 FORMAT(I2.2, ':', I2.2, ':', I2.2)
       RETURN                                                            00092900
       END                                                               00093000
 C                                                                       00093100
@@ -1056,7 +1075,29 @@
 C*    ACOS-6 FORTRAN                                                    00094144
 C     CALL DATIM(IDAY,T)                                                00094145
 C                                                                       00094146
-      DIMENSION IDAY(2)                                                 00094200
-      CALL DATE(IDAY)                                                   00094300
+C
+C*    ORIGINAL
+C     DIMENSION IDAY(2)                                                 00094200
+C     CALL DATE(IDAY)                                                   00094300
+C
+C
+C*    G77 FORTRAN
+C     CHARACTER*4 IDAY(2)
+C     INTEGER*4 TODAY(3)
+C     CHARACTER*11 ADAY
+C     CALL IDATE(TODAY)
+C     WRITE(ADAY,*) TODAY
+C     WRITE(IDAY(1),'(A2,A1,A1)') ADAY(9:10),'/',ADAY(4:4)
+C     WRITE(IDAY(2),'(A1,A1,A2)') ADAY(5:5),'/',ADAY(2:3)
+C
+C
+C*    GFORTRAN
+      CHARACTER*8 IDAY
+      INTEGER*4 VAL(8)
+      CHARACTER*4 YEAR
+      CALL DATE_AND_TIME(VALUES=VAL)
+      WRITE(YEAR,'(I4.4)') VAL(1)
+      WRITE(IDAY,200) YEAR(3:4), VAL(2), VAL(3)
+  200 FORMAT(A2, '/', I2.2, '/', I2.2)
       RETURN                                                            00094400
       END                                                               00094500
diff -Nur sals25/src/sals sals25a/src/sals
--- sals25/src/sals	2000-04-19 12:16:37.000000000 +0900
+++ sals25a/src/sals	2014-04-06 13:25:41.000000000 +0900
@@ -295,7 +295,7 @@
 C       NBITMX  THE LARGEST FLOATING NUMBER IS EXPRESSED BY 2**NBITMX-1 00009820
 C       NBITMN  THE SMALLEST POSITIVE FLOATING NUMBER IS EXPRESSED BY   00009824
 C                 2**(-NBITMN).                                         00009828
-             DATA   NBITR/24/, NBITMX/252/, NBITMN/260/                 00009832
+             DATA   NBITR/24/, NBITMX/128/, NBITMN/126/                 00009832
 C***  SET THE MACHINE DEPENDENT CONSTANTS IN COMMON/SCEPS/ AND /SCMNMX/.00009836
       EPS = 0.5**(NBITR-2)                                              00009840
       EPST = EPS*16.0                                                   00009844
@@ -338,7 +338,7 @@
 C                                                                       00012812
 C*    START THE CPU TIMER ---  FOR HITAC VOS3 FORTRAN                   00012814
 C                                                                       00012816
-      CALL CLOCK                                                        00012820
+C      CALL CLOCK                                                        00012820
 C                                                                       00012900
 C**   WRITE A WELCOME MESSAGE.                                          00013000
 C                                                                       00013100
diff -Nur sals25/srcd/Makefile sals25a/srcd/Makefile
--- sals25/srcd/Makefile	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/srcd/Makefile	2014-04-06 15:53:20.000000000 +0900
@@ -0,0 +1,3 @@
+TARGET  = libsalsd.a
+
+include ../Makefile.in
diff -Nur sals25/srcd/modeld sals25a/srcd/modeld
--- sals25/srcd/modeld	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/srcd/modeld	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,38 @@
+C                                                                       00040200
+C                                                                       00040300
+C---  SUBROUTINE  MODELD  -------  (MEMBER  MODL  , SUB. 12 )           00040400
+C                                                                       00040500
+      SUBROUTINE MODELD (LCALCD, NPARA, NDATA, NC, X, COORD, FOBS, F    00040600
+     1                 , RES, DF, LFIX, MDF)                            00040700
+      IMPLICIT REAL*8(A-H,O-Z)                                          00040750
+C                                                                       00040800
+C                                                                       00040900
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00041000
+C       MODEL FUNCTION SUBROUTINE WHICH CALCULATES THE JACOBIAN MATRIX  00041100
+C       AND THE MODEL FUNCTIONS.                                        00041200
+C                                                                       00041300
+C     DEBUG 6, SUBCHK                                                   00041400
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00041500
+     1         , RES(NDATA), DF(MDF,NPARA), LFIX(NPARA)                 00041600
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00041700
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00041800
+      WRITE(LOUT1, 6010)                                                00041900
+ 6010 FORMAT(24H0***** ERROR    SALS 753, 5X                            00042000
+     1     , 96HSUBROUTINE MODELD TO CALCULATE MODEL FUNCTIONS AND THEIR00042100
+     2 FIRST DERIVATIVES IS CALLED (LMODEL=2)                           00042200
+     3     /29X,  42HBUT IS NOT SUPPLIED BY THE USER.                   00042300
+     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00042400
+     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00042500
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00042600
+      LSKIP = 2                                                         00042700
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00042800
+      LCALCD = LCALCD                                                   00042900
+      X(1) = X(1)                                                       00043000
+      COORD(1,1) = COORD(1,1)                                           00043100
+      FOBS(1) = FOBS(1)                                                 00043200
+      F(1) = F(1)                                                       00043300
+      RES(1) = RES(1)                                                   00043400
+      DF(1,1) = DF(1,1)                                                 00043500
+      LFIX(1) = LFIX(1)                                                 00043600
+      RETURN                                                            00043700
+      END                                                               00043800
diff -Nur sals25/srcd/modelf sals25a/srcd/modelf
--- sals25/srcd/modelf	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/srcd/modelf	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,33 @@
+C                                                                       00037000
+C                                                                       00037100
+C---  SUBROUTINE  MODELF  -------  (MEMBER  MODL  , SUB. 11 )           00037200
+C                                                                       00037300
+      SUBROUTINE MODELF (NPARA, NDATA, NC, X, COORD, FOBS, F, RES)      00037400
+      IMPLICIT REAL*8(A-H,O-Z)                                          00037450
+C                                                                       00037500
+C                                                                       00037600
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00037700
+C       MODEL FUNCTION SUBROUTINE.                                      00037800
+C                                                                       00037900
+C     DEBUG 6, SUBCHK                                                   00038000
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00038100
+     1         , RES(NDATA)                                             00038200
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00038300
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00038400
+      WRITE(LOUT1, 6010)                                                00038500
+ 6010 FORMAT(24H0***** ERROR    SALS 751, 5X                            00038600
+     1    ,100HSUBROUTINE MODELF TO CALCULATE MODEL FUNCTIONS IS CALLED 00038700
+     2(LMODEL=1) BUT IS NOT SUPPLIED BY THE USER.                       00038800
+     3          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00038900
+     4          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00039000
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00039100
+      LSKIP = 2                                                         00039200
+C                                                                       00039300
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00039400
+      X(1) = X(1)                                                       00039500
+      COORD(1,1) = COORD(1,1)                                           00039600
+      FOBS(1) = FOBS(1)                                                 00039700
+      F(1) = F(1)                                                       00039800
+      RES(1) = RES(1)                                                   00039900
+      RETURN                                                            00040000
+      END                                                               00040100
diff -Nur sals25/srcd/modeln sals25a/srcd/modeln
--- sals25/srcd/modeln	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/srcd/modeln	2014-04-06 13:25:41.000000000 +0900
@@ -0,0 +1,42 @@
+C                                                                       00043900
+C                                                                       00044000
+C---  SUBROUTINE  MODELN  -------  (MEMBER  MODL  , SUB. 13 )           00044100
+C                                                                       00044200
+      SUBROUTINE MODELN (LCALCN, NPARA, NDATA, NC, X, COORD, FOBS, F    00044300
+     1                 , RES, AWA, AWY, LFIX, FSIE)                     00044400
+      IMPLICIT REAL*8(A-H,O-Z)                                          00044450
+C                                                                       00044500
+C                                                                       00044600
+C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE USER-CODED SUBROUTINE     00044700
+C       WHICH CALCULATES THE NORMAL EQUATION AS WELL AS THE MODEL       00044800
+C       FUNCTIONS.                                                      00044900
+C                                                                       00045000
+C     DEBUG 6, SUBCHK                                                   00045100
+      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00045200
+     1         , RES(NDATA), AWA(NPARA,NPARA), AWY(NPARA), LFIX(NPARA)  00045300
+     2         , FSIE(NDATA)                                            00045400
+      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00045500
+      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00045600
+      WRITE(LOUT1, 6010)                                                00045700
+ 6010 FORMAT(24H0***** ERROR    SALS 755, 5X                            00045800
+     1     , 90HSUBROUTINE MODELN TO CALCULATE MODEL FUNCTIONS AND NORMA00045900
+     2L EQUATION IS CALLED (LMODEL = 4)                                 00046000
+     3     /29X,  32HBUT IS NOT SUPPLIED BY THE USER.                   00046100
+     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00046200
+     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00046300
+      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00046400
+      LSKIP = 2                                                         00046500
+C                                                                       00046600
+C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00046700
+      LCALCN = LCALCN                                                   00046800
+      X(1) = X(1)                                                       00046900
+      COORD(1,1) = COORD(1,1)                                           00047000
+      FOBS(1) = FOBS(1)                                                 00047100
+      F(1) = F(1)                                                       00047200
+      RES(1) = RES(1)                                                   00047300
+      AWA(1,1) = AWA(1,1)                                               00047400
+      AWY(1) = AWY(1)                                                   00047500
+      LFIX(1) = LFIX(1)                                                 00047600
+      FSIE(1) = FSIE(1)                                                 00047700
+      RETURN                                                            00047800
+      END                                                               00047900
diff -Nur sals25/srcd/modl sals25a/srcd/modl
--- sals25/srcd/modl	2000-04-13 13:30:47.000000000 +0900
+++ sals25a/srcd/modl	2014-04-06 13:25:41.000000000 +0900
@@ -383,119 +383,6 @@
    10 CONTINUE                                                          00036700
       RETURN                                                            00036800
       END                                                               00036900
-C                                                                       00037000
-C                                                                       00037100
-C---  SUBROUTINE  MODELF  -------  (MEMBER  MODL  , SUB. 11 )           00037200
-C                                                                       00037300
-      SUBROUTINE MODELF (NPARA, NDATA, NC, X, COORD, FOBS, F, RES)      00037400
-      IMPLICIT REAL*8(A-H,O-Z)                                          00037450
-C                                                                       00037500
-C                                                                       00037600
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00037700
-C       MODEL FUNCTION SUBROUTINE.                                      00037800
-C                                                                       00037900
-C     DEBUG 6, SUBCHK                                                   00038000
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00038100
-     1         , RES(NDATA)                                             00038200
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00038300
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00038400
-      WRITE(LOUT1, 6010)                                                00038500
- 6010 FORMAT(24H0***** ERROR    SALS 751, 5X                            00038600
-     1    ,100HSUBROUTINE MODELF TO CALCULATE MODEL FUNCTIONS IS CALLED 00038700
-     2(LMODEL=1) BUT IS NOT SUPPLIED BY THE USER.                       00038800
-     3          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00038900
-     4          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00039000
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00039100
-      LSKIP = 2                                                         00039200
-C                                                                       00039300
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00039400
-      X(1) = X(1)                                                       00039500
-      COORD(1,1) = COORD(1,1)                                           00039600
-      FOBS(1) = FOBS(1)                                                 00039700
-      F(1) = F(1)                                                       00039800
-      RES(1) = RES(1)                                                   00039900
-      RETURN                                                            00040000
-      END                                                               00040100
-C                                                                       00040200
-C                                                                       00040300
-C---  SUBROUTINE  MODELD  -------  (MEMBER  MODL  , SUB. 12 )           00040400
-C                                                                       00040500
-      SUBROUTINE MODELD (LCALCD, NPARA, NDATA, NC, X, COORD, FOBS, F    00040600
-     1                 , RES, DF, LFIX, MDF)                            00040700
-      IMPLICIT REAL*8(A-H,O-Z)                                          00040750
-C                                                                       00040800
-C                                                                       00040900
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE ALTERNATIVE USER-CODED    00041000
-C       MODEL FUNCTION SUBROUTINE WHICH CALCULATES THE JACOBIAN MATRIX  00041100
-C       AND THE MODEL FUNCTIONS.                                        00041200
-C                                                                       00041300
-C     DEBUG 6, SUBCHK                                                   00041400
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00041500
-     1         , RES(NDATA), DF(MDF,NPARA), LFIX(NPARA)                 00041600
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00041700
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00041800
-      WRITE(LOUT1, 6010)                                                00041900
- 6010 FORMAT(24H0***** ERROR    SALS 753, 5X                            00042000
-     1     , 96HSUBROUTINE MODELD TO CALCULATE MODEL FUNCTIONS AND THEIR00042100
-     2 FIRST DERIVATIVES IS CALLED (LMODEL=2)                           00042200
-     3     /29X,  42HBUT IS NOT SUPPLIED BY THE USER.                   00042300
-     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00042400
-     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00042500
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00042600
-      LSKIP = 2                                                         00042700
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00042800
-      LCALCD = LCALCD                                                   00042900
-      X(1) = X(1)                                                       00043000
-      COORD(1,1) = COORD(1,1)                                           00043100
-      FOBS(1) = FOBS(1)                                                 00043200
-      F(1) = F(1)                                                       00043300
-      RES(1) = RES(1)                                                   00043400
-      DF(1,1) = DF(1,1)                                                 00043500
-      LFIX(1) = LFIX(1)                                                 00043600
-      RETURN                                                            00043700
-      END                                                               00043800
-C                                                                       00043900
-C                                                                       00044000
-C---  SUBROUTINE  MODELN  -------  (MEMBER  MODL  , SUB. 13 )           00044100
-C                                                                       00044200
-      SUBROUTINE MODELN (LCALCN, NPARA, NDATA, NC, X, COORD, FOBS, F    00044300
-     1                 , RES, AWA, AWY, LFIX, FSIE)                     00044400
-      IMPLICIT REAL*8(A-H,O-Z)                                          00044450
-C                                                                       00044500
-C                                                                       00044600
-C***  DUMMY SYSTEM SUBROUTINE IN PLACE OF THE USER-CODED SUBROUTINE     00044700
-C       WHICH CALCULATES THE NORMAL EQUATION AS WELL AS THE MODEL       00044800
-C       FUNCTIONS.                                                      00044900
-C                                                                       00045000
-C     DEBUG 6, SUBCHK                                                   00045100
-      DIMENSION  X(NPARA), COORD(NDATA,NC), FOBS(NDATA), F(NDATA)       00045200
-     1         , RES(NDATA), AWA(NPARA,NPARA), AWY(NPARA), LFIX(NPARA)  00045300
-     2         , FSIE(NDATA)                                            00045400
-      COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00045500
-      COMMON /SCERR / LERROR, LABN, LSKIP, IERROR, LFAIL                00045600
-      WRITE(LOUT1, 6010)                                                00045700
- 6010 FORMAT(24H0***** ERROR    SALS 755, 5X                            00045800
-     1     , 90HSUBROUTINE MODELN TO CALCULATE MODEL FUNCTIONS AND NORMA00045900
-     2L EQUATION IS CALLED (LMODEL = 4)                                 00046000
-     3     /29X,  32HBUT IS NOT SUPPLIED BY THE USER.                   00046100
-     4          /29X, 44HSOLUTION OF THIS PROBLEM IS TO BE ABANDONED.   00046200
-     5          ,3X, 42HSKIP TO THE NEXT PROBLEM BLOCK.   LSKIP=2.  )   00046300
-      IF(LOUT.NE. LOUT1) WRITE(LOUT, 6010)                              00046400
-      LSKIP = 2                                                         00046500
-C                                                                       00046600
-C*    DUMMY STATEMENT TO SUPPRESS FORTRAN ERROR MESSAGES.               00046700
-      LCALCN = LCALCN                                                   00046800
-      X(1) = X(1)                                                       00046900
-      COORD(1,1) = COORD(1,1)                                           00047000
-      FOBS(1) = FOBS(1)                                                 00047100
-      F(1) = F(1)                                                       00047200
-      RES(1) = RES(1)                                                   00047300
-      AWA(1,1) = AWA(1,1)                                               00047400
-      AWY(1) = AWY(1)                                                   00047500
-      LFIX(1) = LFIX(1)                                                 00047600
-      FSIE(1) = FSIE(1)                                                 00047700
-      RETURN                                                            00047800
-      END                                                               00047900
 C                                                                       00048000
 C                                                                       00048100
 C---  SUBROUTINE  ZRESCH  -------  (MEMBER  MODL  , SUB. 14 )           00048200
diff -Nur sals25/srcd/out sals25a/srcd/out
--- sals25/srcd/out	2000-04-13 13:30:52.000000000 +0900
+++ sals25a/srcd/out	2014-04-06 13:25:42.000000000 +0900
@@ -632,7 +632,8 @@
 C     DEBUG 6, SUBCHK                                                   00055000
       COMMON/SCTIME/ CPTIME, ICLOCK(3), IDAY(2)                         00055100
       COMMON /SCOUT / LOUT, LOUT1, NCHAR                                00055200
-      CALL CLOCK(CPTIME, 5)                                             00055300
+C     CALL CLOCK(CPTIME, 5)                                             00055300
+      CALL CPU_TIME(CPTIME)
       IF (NCHAR .LT. 132)  GO TO 60                                     00055500
       IF(L .EQ. 0)  GO TO 10                                            00055600
       IF(L .EQ. 1) GO TO 20                                             00055700
@@ -1044,8 +1045,26 @@
 C 100 FORMAT(I2,1X,I2,1X,I2,1X,I2)                                      00092668
 C                                                                       00092669
 C                                                                       00092670
-      DIMENSION ICLOCK(3)                                               00092700
-      CALL CLOCK(ICLOCK, 1)                                             00092800
+C*    ORIGINAL
+C     DIMENSION ICLOCK(3)                                               00092700
+C     CALL CLOCK(ICLOCK, 1)                                             00092800
+C
+C
+C*    G77 FORTRAN
+C     CHARACTER*4 ICLOCK(3)
+C     CHARACTER*8 TM
+C     CALL TIME(TM)
+C     ICLOCK(1)=TM(1:4)
+C     ICLOCK(2)=TM(5:8)
+C     ICLOCK(3)='    '
+C
+C
+C*    GFORTRAN
+      CHARACTER*12 ICLOCK
+      INTEGER*4 VAL(8)
+      CALL DATE_AND_TIME(VALUES=VAL)
+      WRITE(ICLOCK,100) VAL(5), VAL(6), VAL(7)
+  100 FORMAT(I2.2, ':', I2.2, ':', I2.2)
       RETURN                                                            00092900
       END                                                               00093000
 C                                                                       00093100
@@ -1073,7 +1092,29 @@
 C*    ACOS-6 FORTRAN                                                    00094144
 C     CALL DATIM(IDAY,T)                                                00094145
 C                                                                       00094146
-      DIMENSION IDAY(2)                                                 00094200
-      CALL DATE(IDAY)                                                   00094300
+C
+C*    ORIGINAL
+C     DIMENSION IDAY(2)                                                 00094200
+C     CALL DATE(IDAY)                                                   00094300
+C
+C
+C*    G77 FORTRAN
+C     CHARACTER*4 IDAY(2)
+C     INTEGER*4 TODAY(3)
+C     CHARACTER*11 ADAY
+C     CALL IDATE(TODAY)
+C     WRITE(ADAY,*) TODAY
+C     WRITE(IDAY(1),'(A2,A1,A1)') ADAY(9:10),'/',ADAY(4:4)
+C     WRITE(IDAY(2),'(A1,A1,A2)') ADAY(5:5),'/',ADAY(2:3)
+C
+C
+C*    GFORTRAN
+      CHARACTER*8 IDAY
+      INTEGER*4 VAL(8)
+      CHARACTER*4 YEAR
+      CALL DATE_AND_TIME(VALUES=VAL)
+      WRITE(YEAR,'(I4.4)') VAL(1)
+      WRITE(IDAY,200) YEAR(3:4), VAL(2), VAL(3)
+  200 FORMAT(A2, '/', I2.2, '/', I2.2)
       RETURN                                                            00094400
       END                                                               00094500
diff -Nur sals25/srcd/sals sals25a/srcd/sals
--- sals25/srcd/sals	2000-04-13 13:28:55.000000000 +0900
+++ sals25a/srcd/sals	2014-04-06 13:25:42.000000000 +0900
@@ -302,7 +302,7 @@
 C       NBITMX  THE LARGEST FLOATING NUMBER IS EXPRESSED BY 2**NBITMX-1 00009820
 C       NBITMN  THE SMALLEST POSITIVE FLOATING NUMBER IS EXPRESSED BY   00009824
 C                 2**(-NBITMN).                                         00009828
-             DATA   NBITR/56/, NBITMX/252/, NBITMN/260/                 00009832
+             DATA   NBITR/53/, NBITMX/1024/, NBITMN/1022/               00009832
 C***  SET THE MACHINE DEPENDENT CONSTANTS IN COMMON/SCEPS/ AND /SCMNMX/.00009836
       EPS = 0.5D00**(NBITR-2)                                           00009840
       EPST = DMAX1(EPS*16.0D00, 1.0D-12)                                00009844
@@ -345,7 +345,7 @@
 C                                                                       00012812
 C*    START THE CPU TIMER ---  FOR HITAC VOS3 FORTRAN                   00012814
 C                                                                       00012816
-      CALL CLOCK                                                        00012820
+C     CALL CLOCK                                                        00012820
 C                                                                       00012900
 C**   WRITE A WELCOME MESSAGE.                                          00013000
 C                                                                       00013100
diff -Nur sals25/test/Makefile sals25a/test/Makefile
--- sals25/test/Makefile	1970-01-01 09:00:00.000000000 +0900
+++ sals25a/test/Makefile	2014-04-06 20:57:25.000000000 +0900
@@ -0,0 +1,41 @@
+SRC	= sjpoly
+OBJS	= $(SRC)_f.o $(SRC)_d.o
+
+#for G77
+#FC	= g77
+#FFLAGS	= -Wno-globals -O
+#LD	= g77
+
+#for GFORTRAN
+FC	= gfortran
+FFLAGS	= -std=legacy -O
+
+LD	= gfortran
+S_LIBS	= -L ../src -lsals
+D_LIBS	= -L ../srcd -lsalsd
+
+test:	$(SRC)_f $(SRC)_d data.txt
+	./$(SRC)_f < data.txt > result_f.txt
+	./$(SRC)_d < data.txt > result_d.txt
+
+$(SRC)_f: $(SRC)_f.o
+	$(LD) $(LDFLAGS) -o $@ $< $(S_LIBS)
+
+$(SRC)_d: $(SRC)_d.o
+	$(LD) $(LDFLAGS) -o $@ $< $(D_LIBS)
+
+$(SRC)_f.f: $(SRC)
+	sed -ne '/CALL .*SALS/,/>/p' $< | sed -e '$$d' > $@
+
+$(SRC)_d.f: $(SRC)
+	sed -ne '/CALL .*SALS/,/>/p' $< | sed -e '$$d' | \
+	awk '{if (/DIMENSION/) {print "      IMPLICIT REAL*8(A-H,O-Z)"; print} else { print }}' > $@
+
+data.txt: $(SRC)
+	sed -ne '/PROBLEM/,/ENDSALS/p' $< > $@
+
+.f.o:
+	$(FC) $(FFLAGS) -c $<
+
+clean:
+	-rm -f $(SRC)_f $(SRC)_d *.f *.o data.txt result_f.txt result_d.txt
