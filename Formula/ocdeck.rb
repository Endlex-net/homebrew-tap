class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.15"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.15/ocdeck_darwin_arm64.tar.gz"
    sha256 "34c4af39f4a1bc05d625ca9fc698759599ab88947f80e785f526f0d6931f51dc"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.15/ocdeck_darwin_amd64.tar.gz"
    sha256 "b9d1fcb871a24b7f9677353df6d3ff447a667e74c890c06a6bdf7684c5fbfffe"
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
