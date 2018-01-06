cask '1piece' do
  version '0.18.0'
  sha256 'afa2bebb4d530e19058f9c745a1bc64ac85bfc4cd6cd3888c6cb995831a6fb4c'

  url 'http://www001.upp.so-net.ne.jp/app1piece/1Piece-0.18.0.zip'
  name '1Piece'
  homepage 'http://www001.upp.so-net.ne.jp/app1piece/'

  accessibility_access true

  app '1Piece.app'

  uninstall quit:       'jp.fuji.1Piece',
            login_item: '1Piece'

  zap trash: '~/Library/Preferences/jp.fuji.1Piece.plist'
end
