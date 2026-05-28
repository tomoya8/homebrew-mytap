class PdfjamExtras < Formula
  desc "Some unsupported 'wrapper' scripts for pdfjam"
  homepage "https://github.com/tomoya8/pdfjam-extras"
  url "https://github.com/tomoya8/pdfjam-extras/archive/refs/tags/v2.09.zip"
  sha256 "4f5079483460046de1d2606c77a77aa620956230b58dbd647e0184f54ddb88ef"
  license "GPL-2.0"

  depends_on "pdfjam"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "false"
  end
end
