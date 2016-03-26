require "formula"

class Levmar < Formula
  homepage "http://www.ics.forth.gr/~lourakis/levmar/"
  url "http://users.ics.forth.gr/~lourakis/levmar/levmar-2.6.tgz"
  sha1 "118bd20b55ab828d875f1b752cb5e1238258950b"

  def install
    system "make", "CC=clang", "LAPACKLIBS=-framework Accelerate"
    include.install "levmar.h"
    lib.install "liblevmar.a"
    libexec.install "lmdemo"
    share.install "lmdemo.c"
  end

  test do
    system "#{libexec}/lmdemo"
  end
end
