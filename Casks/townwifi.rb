cask 'townwifi' do
  version '1.0.1'
  sha256 '7e493488f4139645d5060f52651a59a906e46b12efe8a2993a0c07e2e505435b'

  url 'https://storage.googleapis.com/townwifi-downloads/mac/installer/TownWifi.pkg'
  name 'TownWifi'
  homepage 'http://townwifi.jp/'

  pkg 'TownWifi.pkg'

  uninstall pkgutil: 'jp.townwifi.townwifi'

  zap trash: [
	'~/Library/Application Support/jp.townwifi.townwifi',
	'~/Library/Preferences/jp.townwifi.townwifi.plist',
	]
end
