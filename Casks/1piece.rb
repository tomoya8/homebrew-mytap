cask '1piece' do
  version '0.19.0'
  sha256 'd8123550484267a34c18ba671ed6743fb70cc8e337b1b547cb26b66bddb1c23c'

  url 'http://www001.upp.so-net.ne.jp/app1piece/1Piece-0.19.0.zip'
  name '1Piece'
  homepage 'http://www001.upp.so-net.ne.jp/app1piece/'

  accessibility_access true

  app '1Piece.app'

  uninstall quit:       'jp.fuji.1Piece',
            login_item: '1Piece'

  zap trash: '~/Library/Preferences/jp.fuji.1Piece.plist'
end
