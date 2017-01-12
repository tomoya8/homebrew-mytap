# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Jnethack360 < Formula
  desc "Japanese localization of Nethack"
  homepage "https://ja.osdn.net/projects/jnethack/"
  #url "https://ja.osdn.net/dl/jnethack/nethack-360-src.tgz"
  url "file:///Users/kon/Downloads/nethack-360-src.tgz"
  version "3.6.0-0.7"
  sha256 "1ade698d8458b8d87a4721444cb73f178c74ed1b6fde537c12000f8edf2cb18a"

  depends_on "nkf" => :build

  # Dont't remove save folder
  skip_clean "save"

  patch do
    #url "https://ja.osdn.net/dl/jnethack/jnethack-3.6.0-0.7.diff.gz"
    url "file:///Users/kon/Downloads/jnethack-3.6.0-0.7.diff.gz"
    sha256 "bfd51e28551cb34ddc36e1dd0b32a9163bdab6a734ea6b9156d4b9cce3f07527"
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV.deparallelize

    inreplace "sys/unix/hints/macosx10.10",
	    /^PREFIX:=\$\(wildcard ~\)/,
	    "PREFIX:=#{prefix}"
    
    inreplace "sys/unix/hints/macosx10.10",
	    /^CC=gcc/,
	    "CC=clang"

    inreplace "sys/unix/hints/macosx10.10",
	    /^CFLAGS\+=-Wall -Wextra.*$/,
	    "CFLAGS+=#{ENV.cflags} -Wno-invalid-source-encoding -Wno-pointer-sign -Wno-incompatible-pointer-types-discards-qualifiers -Wno-logical-not-parentheses -Wno-comment"
	
    system "sh", "sys/unix/setup.sh", "sys/unix/hints/macosx10.10"

    system "find", ".", "-type", "f",
	                "-exec", "nkf", "-e", "--overwrite", "{}", ";"

    system "make", "install"
    (libexec+"save").mkpath
  end
end
