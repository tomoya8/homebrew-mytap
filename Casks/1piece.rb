cask '1piece' do
  version '1.2'
  sha256 '2c70832ae15b881cc2f4178b45b30e1af611015a70e59fff202db22bbdfe427a'

  url 'https://app1piece.com/1Piece-1.2.zip'
  name '1Piece'
  homepage 'http://www001.upp.so-net.ne.jp/app1piece/'

  #accessibility_access true

  app '1Piece.app'

  uninstall quit:       'jp.fuji.1Piece',
            login_item: '1Piece'

  zap trash: '~/Library/Preferences/jp.fuji.1Piece.plist'
end
