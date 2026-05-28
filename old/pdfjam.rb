class Pdfjam < Formula
  desc "Equivalent of pdfpages for pdfLaTeX"
  homepage "https://rrthomas.github.io/pdfjam/"
  url "https://rrthomas.github.io/pdfjam/releases/pdfjam_208.tgz"
  version "2.08"
  sha256 "c731c598cfad076c985526ff89cbf34423a216101aa5e2d753a71de119ecc0f3"

  #depends_on :tex

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfjam", "-h"
  end
end
