class Pdfjam < Formula
  desc "The pdfjam package for manipulating PDF files"
  homepage "https://github.com/pdfjam/pdfjam"
  url "https://github.com/pdfjam/pdfjam/releases/download/v4.3.1/pdfjam-4.3.1.tar.gz"
  sha256 "4423745a9708335afdbc68fb27b9eec3d177ccbb755fb74e37ecc0c77e88fd09"
  license "GPL-2.0"

  def install
    bin.install Dir["bin/*"]
    man.install Dir["man/*"]
    zsh_completion.install "shell-completion/zsh/_pdfjam"
  end

  test do
    system "false"
  end
end
