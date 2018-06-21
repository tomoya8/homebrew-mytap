cask 'gfortran' do
  version '5.2-Yosemite'
  sha256 '01726f9d23fed4301bf7f30b7819c78cebed31d8895d3430e578003c515f21ad'

  url "http://coudert.name/software/gfortran-#{version}.dmg"
  name 'Gfortran'
  homepage 'https://gcc.gnu.org/wiki/GFortran'
  # license :gpl

  pkg "gfortran-#{version}/gfortran.pkg"

  uninstall :pkgutil => 'com.gnu.gfortran',
            :delete => '/usr/local/bin/gfortran'
end
