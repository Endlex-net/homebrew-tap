class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.22"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.22/ocdeck_darwin_arm64.tar.gz"
    sha256 "b62cb796c386d8bf603d2c4f3672d214b905323e14196d7564028208d410b451"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.22/ocdeck_darwin_amd64.tar.gz"
    sha256 "fea7b247933b9d3b4f8816e2c0e37ec7f93091656af8213e692e6f137cd04088"
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
