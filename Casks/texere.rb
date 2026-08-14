cask "texere" do
  version "0.2.5-alpha"
  sha256 "e34365a2eb7a67c0b38d8875f934b5935e05518a0176496f83bd893a9c5d44d2"

  url "https://github.com/Endlex-net/Texere/releases/download/v0.2.5-alpha/Texere-0.2.5-alpha-aarch64.dmg"
  name "Texere"
  desc "Quick draft tool for deep input workflows"
  homepage "https://github.com/Endlex-net/Texere"

  app "Texere.app"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/Texere.app"]
  end
end
