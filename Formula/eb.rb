class Eb < Formula
  desc "Library to access electronic books"
  homepage "http://quruli.ivory.ne.jp/document/eb_4.4.3/eb.html"
  url "ftp://ftp.sra.co.jp/pub/misc/eb/eb-4.4.3.tar.bz2"
  version "4.4.3"
  sha256 "abe710a77c6fc3588232977bb2f30a2e69ddfbe9fa8d0b05b0d67d95e36f4b5f"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
