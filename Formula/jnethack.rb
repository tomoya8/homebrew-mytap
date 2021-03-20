require "etc"

# Nethack the way God intended it to be played: from a terminal.

# This formula is based on Nethack formula.
# The patches in DATA section are shamelessly stolen from MacPorts' jnethack portfile.

class Jnethack < Formula
  desc "Japanese localization of Nethack"
  homepage "http://jnethack.sourceforge.jp/"
  url "https://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz"
  version "3.4.3-0.11"
  sha256 "bb39c3d2a9ee2df4a0c8fdde708fbc63740853a7608d2f4c560b488124866fe4"

#  fails_with :llvm do
#    build 2334
#  end

  # needs X11 locale for i18n
  #depends_on :x11

  # Don't remove save folder
  skip_clean "libexec/save"

  patch do
    url "http://iij.dl.sourceforge.jp/jnethack/58545/jnethack-3.4.3-0.11.diff.gz"
    sha256 "fbc071f6b33c53d89e8f13319ced952e605499a21d2086077296c631caff7389"
  end

  patch do
    url "http://surveyor.web.fc2.com/jnethack/fighter.patch"
    sha256 "9e31746a54cc2d33ea57e6dfd1f798bdf0da2a9ae511f3ddbe0001cc6a6a4922"
  end

  patch do
    url "http://surveyor.web.fc2.com/jnethack/menucolor.diff"
    sha256 "5d6e17d22b0490547f9e591861640c0867cca22970db7dcb1711f7630b22d981"
  end

  patch do
    url "http://surveyor.web.fc2.com/jnethack/hpmon.diff" 
    sha256 "31127c3d146ef2240fee993e9852ca88c52a1386d276bf06c3e8474b79ff4115"
  end 

  patch do
    url "http://surveyor.web.fc2.com/jnethack/for_hpmon.patch"
    sha256 "876449ca52eb6fcc5704d9793f0b5830a68d1b60fc5f32c3183c73b86e940d1e"
  end
 
  patch do
    url "http://surveyor.web.fc2.com/jnethack/for_menucolor.patch"
    sha256 "d41bba9d265d56c7f9aee2bab9af467cfb11a0e199aa95ec8f6c1861bfad91b5"
  end

  patch :DATA

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    ENV["HOMEBREW_CFLAGS"] = ENV.cflags

    # Symlink makefiles
    system "sh", "sys/unix/setup.sh"

    inreplace "include/config.h",
      /^#\s*define HACKDIR.*$/,
      "#define HACKDIR \"#{libexec}\""

    # Enable wizard mode for the current user
    wizard = Etc.getpwuid.name

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD\s+"wizard"/,
      "#define WIZARD \"#{wizard}\""

    inreplace "include/config.h",
      /^#\s*define\s+WIZARD_NAME\s+"wizard"/,
      "#define WIZARD_NAME \"#{wizard}\""

    cd "dat" do
      system "make"

      %w[perm logfile].each do |f|
        touch f
        libexec.install f
      end

      # Stage the data
      libexec.install %w[jhelp jhh jcmdhelp jhistory jopthelp jwizhelp dungeon license data jdata.base joracles options jrumors quest.dat jquest.txt]
      libexec.install Dir["*.lev"]
    end

    # Make the game
    ENV.append_to_cflags "-I../include"
    cd "src" do
      system "make"
    end

    bin.install "src/jnethack"
    (libexec+"save").mkpath
  end
end

__END__
diff --git a/include/config.h b/include/config.h
index 5f67fe1..6974858 100644
--- a/include/config.h
+++ b/include/config.h
@@ -371,8 +371,8 @@ typedef unsigned char	uchar;
 
 #if defined(TTY_GRAPHICS) || defined(MSWIN_GRAPHICS)
 # define MENU_COLOR
-# define MENU_COLOR_REGEX
-# define MENU_COLOR_REGEX_POSIX
+/* # define MENU_COLOR_REGEX */
+/* # define MENU_COLOR_REGEX_POSIX */
 /* if MENU_COLOR_REGEX is defined, use regular expressions (regex.h,
  * GNU specific functions by default, POSIX functions with
  * MENU_COLOR_REGEX_POSIX).
diff --git a/src/options.c b/src/options.c
index 7ab20ed..c240d33 100644
--- a/src/options.c
+++ b/src/options.c
@@ -146,7 +146,7 @@ static struct Bool_Opt
 #else
 	{"news", (boolean *)0, FALSE, SET_IN_FILE},
 #endif
-	{"null", &flags.null, TRUE, SET_IN_GAME},
+	{"null", &flags.null, FALSE, SET_IN_GAME},
 #ifdef MAC
 	{"page_wait", &flags.page_wait, TRUE, SET_IN_GAME},
 #else
diff --git a/sys/unix/Makefile.doc b/sys/unix/Makefile.doc
index a0b6c8d..c7a75df 100644
--- a/sys/unix/Makefile.doc
+++ b/sys/unix/Makefile.doc
@@ -40,8 +40,8 @@ Guidebook.dvi:	Guidebook.tex
 	latex Guidebook.tex
 
 
-GAME	= nethack
-MANDIR	= /usr/local/man/man6
+GAME	= jnethack
+MANDIR	= $(DESTDIR)HOMEBREW_PREFIX/share/man/man6
 MANEXT	= 6
 
 # manual installation for most BSD-style systems
diff --git a/sys/unix/Makefile.src b/sys/unix/Makefile.src
index e032a52..facedc4 100644
--- a/sys/unix/Makefile.src
+++ b/sys/unix/Makefile.src
@@ -36,7 +36,7 @@ SHELL=/bin/sh
 # SHELL=E:/GEMINI2/MUPFEL.TTP
 
 # Normally, the C compiler driver is used for linking:
-LINK=$(CC)
+LINK=$(CC) $(CFLAGS)
 
 # Pick the SYSSRC and SYSOBJ lines corresponding to your desired operating
 # system.
@@ -72,7 +72,7 @@ JOBJ = jconj.o jtrns.o jlib.o
 #
 #	If you are using GCC 2.2.2 or higher on a DPX/2, just use:
 #
-CC = gcc
+#CC = gcc
 #
 #	For HP/UX 10.20 with GCC:
 # CC = gcc -D_POSIX_SOURCE
@@ -154,8 +154,8 @@ GNOMEINC=-I/usr/lib/glib/include -I/usr/lib/gnome-libs/include -I../win/gnome
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -W -g -O -I../include
-LFLAGS = 
+CFLAGS = $(HOMEBREW_CFLAGS) -I../include
+LFLAGS = $(LDFLAGS)
 
 # The Qt and Be window systems are written in C++, while the rest of
 # NetHack is standard C.  If using Qt, uncomment the LINK line here to get
diff --git a/sys/unix/Makefile.top b/sys/unix/Makefile.top
index d4d8cda..f1ea549 100644
--- a/sys/unix/Makefile.top
+++ b/sys/unix/Makefile.top
@@ -14,18 +14,18 @@
 # MAKE = make
 
 # make NetHack
-PREFIX	 = /usr
+PREFIX	 = $(DESTDIR)HOMEBREW_PREFIX
 GAME     = jnethack
 # GAME     = nethack.prg
 GAMEUID  = games
-GAMEGRP  = bin
+GAMEGRP  = games
 
 # Permissions - some places use setgid instead of setuid, for instance
 # See also the option "SECURE" in include/config.h
-GAMEPERM = 04755
-FILEPERM = 0644
+GAMEPERM = 02755
+FILEPERM = 0664
 EXEPERM  = 0755
-DIRPERM  = 0755
+DIRPERM  = 0775
 
 # GAMEDIR also appears in config.h as "HACKDIR".
 # VARDIR may also appear in unixconf.h as "VAR_PLAYGROUND" else GAMEDIR
@@ -35,9 +35,9 @@ DIRPERM  = 0755
 # therefore there should not be anything in GAMEDIR that you want to keep
 # (if there is, you'll have to do the installation by hand or modify the
 # instructions)
-GAMEDIR  = $(PREFIX)/games/lib/$(GAME)dir
+GAMEDIR  = $(PREFIX)/share/$(GAME)dir
 VARDIR  = $(GAMEDIR)
-SHELLDIR = $(PREFIX)/games
+SHELLDIR = $(PREFIX)/bin
 
 # per discussion in Install.X11 and Install.Qt
 VARDATND = 
diff --git a/sys/unix/Makefile.utl b/sys/unix/Makefile.utl
index 87a36f3..bc00ae3 100644
--- a/sys/unix/Makefile.utl
+++ b/sys/unix/Makefile.utl
@@ -15,7 +15,7 @@
 
 # if you are using gcc as your compiler,
 #	uncomment the CC definition below if it's not in your environment
-CC = gcc
+#CC = gcc
 #
 #	For Bull DPX/2 systems at B.O.S. 2.0 or higher use the following:
 #
@@ -89,8 +89,8 @@ CC = gcc
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -O -I../include
-LFLAGS =
+CFLAGS = $(HOMEBREW_CFLAGS) -I../include
+LFLAGS = $(LDFLAGS)
 
 LIBS =
  
@@ -276,7 +276,7 @@ lintdgn:
 #	dependencies for recover
 #
 recover: $(RECOVOBJS)
-	$(CC) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
+	$(CC) $(CFLAGS) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
 
 recover.o: recover.c $(CONFIG_H) ../include/date.h
 
diff --git a/sys/unix/nethack.sh b/sys/unix/nethack.sh
index 9c9b603..d73d052 100644
--- a/sys/unix/nethack.sh
+++ b/sys/unix/nethack.sh
@@ -5,6 +5,7 @@ HACKDIR=/usr/games/lib/nethackdir
 export HACKDIR
 HACK=$HACKDIR/nethack
 MAXNROFPLAYERS=20
+COCOT="HOMEBREW_PREFIX/bin/cocot -t UTF-8 -p EUC-JP"
 
 # JP
 # set LC_ALL, NETHACKOPTIONS etc..
@@ -26,6 +27,10 @@ if [ "X$USERFILESEARCHPATH" = "X" ] ; then
 	export USERFILESEARCHPATH
 fi
 
+if [ "X$LANG" = "Xja_JP.eucJP" ] ; then
+	COCOT=""
+fi
+
 #if [ "X$DISPLAY" ] ; then
 #	xset fp+ $HACKDIR
 #fi
@@ -84,9 +89,9 @@ fi
 cd $HACKDIR
 case $1 in
 	-s*)
-		exec $HACK "$@"
+		exec $COCOT $HACK "$@"
 		;;
 	*)
-		exec $HACK "$@" $MAXNROFPLAYERS
+		exec $COCOT $HACK "$@" $MAXNROFPLAYERS
 		;;
 esac
diff --git a/win/tty/termcap.c b/win/tty/termcap.c
index f9a7103..59fbab1 100644
--- a/win/tty/termcap.c
+++ b/win/tty/termcap.c
@@ -861,7 +861,7 @@ cl_eos()			/* free after Robert Viduya */
 
 #include <curses.h>
 
-#ifndef LINUX
+#if !defined(LINUX) && !defined(__APPLE__)
 extern char *tparm();
 #endif
 
