cask :v1 => 'apple-gfortran42' do
  version '4.2.3'
  sha256 '1643263096d10dbdb8288480e84bb0422c42c73e24c1fa8fb8b5c7e4de95ca41'

  url 'ftp://sodium-benzoate.csclub.uwaterloo.ca/CRAN/bin/macosx/tools/gfortran-4.2.3.dmg'
  name 'Apple Gfortran'
  homepage 'http://r.research.att.com/tools/'
  license :unknown    # todo: change license and remove this comment; ':unknown' is a machine-generated placeholder

  pkg 'gfortran.pkg'

  uninstall :pkgutil => 'org.r-project.mac.tools.gfortran'
end
