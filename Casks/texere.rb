cask "texere" do
  version "0.2.2-alpha"
  sha256 "b7d025d23a8841effccb888a4db06a29dc320f8a0686f800e9d3bf60286d7dbe"

  url "https://github.com/Endlex-net/Texere/releases/download/v0.2.2-alpha/Texere-0.2.2-alpha-aarch64.dmg"
  name "Texere"
  desc "Quick draft tool for deep input workflows"
  homepage "https://github.com/Endlex-net/Texere"

  app "Texere.app"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/Texere.app"]
  end
end
