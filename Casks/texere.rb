cask "texere" do
  version "0.2.3-alpha"
  sha256 "4a714bff1bd9700942753e9609f5378cab77d4ca6ef70d11f22055552092254b"

  url "https://github.com/Endlex-net/Texere/releases/download/v0.2.3-alpha/Texere-0.2.3-alpha-aarch64.dmg"
  name "Texere"
  desc "Quick draft tool for deep input workflows"
  homepage "https://github.com/Endlex-net/Texere"

  app "Texere.app"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/Texere.app"]
  end
end
