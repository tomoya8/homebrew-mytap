class Eblook < Formula
  desc "Electronic dictionary search command using EB library"
  homepage "http://green.ribbon.to/~ikazuhiro/lookup/lookup.html"
  url "http://green.ribbon.to/~ikazuhiro/lookup/files/eblook-1.6.1+media-20130919.tar.gz"
  version "20130919"
  sha256 "d66fb9ac372d11f7b66f5019998ed02d86db0d44ce886f13542f9ee6bbe748f4"

  depends_on "eb"

  def install
    system "./configure", "--prefix=#{prefix}"
                          "--with-eb-conf=/usr/local/etc/eb.conf"
    system "make", "install"
  end
end
