class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.9"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.9/ocdeck_darwin_arm64.tar.gz"
    sha256 "a33f4d683172afb1fa16cda88342dd4b3cd23615478711ad82da2bb086d47732"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.9/ocdeck_darwin_amd64.tar.gz"
    sha256 "f9f03351fd7975362ad2c68d51827a17909842c2c575f587a77ade8d6152be69"
  end

  depends_on "tmux"
  depends_on "git"

  def install
    bin.install "ocdeck-server"
  end

  service do
    run [opt_bin/"ocdeck-server"]
    run_at_load true
    keep_alive true
    # launchd 默认 PATH 不含 Homebrew 前缀，opencode/tmux 会找不到
    environment_variables PATH: std_service_path_env
    log_path var/"log/ocdeck.log"
    error_log_path var/"log/ocdeck.log"
  end

  def caveats
    <<~EOS
      首次启动前必须创建 ~/.config/ocdeck/env 且至少包含：
        OCDECK_TOKEN=<token>
      可选：OCDECK_LISTEN_PORT / OCDECK_SERVE_PORT_RANGE 等。
      改配置后执行：brew services restart ocdeck
    EOS
  end
end
