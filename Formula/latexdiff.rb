class Latexdiff < Formula
  homepage "http://latexdiff.berlios.de/"
  url "http://mirrors.ctan.org/support/latexdiff.zip"
  version "1.0.3"
  sha1 "b56629c619465a3f7c2b12f17f05980b579e5a62"

  def install
    prefix.install %w(COPYING README contrib doc example)
    bin.install %w(latexdiff latexdiff-fast latexdiff-so latexdiff-vc latexrevise)
    man1.install Dir["*.1"]
  end
end
