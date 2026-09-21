class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.24"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.24/ocdeck_darwin_arm64.tar.gz"
    sha256 "621b7b9651f4bc07ed5133798c9ce6fd57380f805ff961901bfd6da4dee386cd"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.24/ocdeck_darwin_amd64.tar.gz"
    sha256 "7be3d781a5e5fe06443fb4d9aa2ff3ea2bdb63e0376bf1fc7bea5cfbee7888c5"
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
