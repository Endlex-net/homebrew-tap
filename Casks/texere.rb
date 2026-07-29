cask "texere" do
  version "0.2.4-alpha"
  sha256 "f3e4f3059c1c4af61393b513b632f20bd812ead97dcc69f62d7c830ef3df24bc"

  url "https://github.com/Endlex-net/Texere/releases/download/v0.2.4-alpha/Texere-0.2.4-alpha-aarch64.dmg"
  name "Texere"
  desc "Quick draft tool for deep input workflows"
  homepage "https://github.com/Endlex-net/Texere"

  app "Texere.app"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/Texere.app"]
  end
end
