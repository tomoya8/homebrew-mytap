class Levmar < Formula
  homepage "http://www.ics.forth.gr/~lourakis/levmar/"
  url "http://users.ics.forth.gr/~lourakis/levmar/levmar-2.6.tgz"
  sha256 "3bf4ef1ea4475ded5315e8d8fc992a725f2e7940a74ca3b0f9029d9e6e94bad7"

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
