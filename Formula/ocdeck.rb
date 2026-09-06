class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.13"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.13/ocdeck_darwin_arm64.tar.gz"
    sha256 "fbf9c6595144af04676edc9e8a4f1e66b4e279cf7e4a444645ce7714f69c80f9"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.13/ocdeck_darwin_amd64.tar.gz"
    sha256 "70866fc7e5ba3b08163fd4a701c31f9a951b5e36ad7a9649db6d0e551bf01650"
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
