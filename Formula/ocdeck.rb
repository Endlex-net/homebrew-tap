class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.17"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.17/ocdeck_darwin_arm64.tar.gz"
    sha256 "57ba94b69a9c6e9ce3d83475802d6fbe7a9f80cf8c117de97ee31fb2b9a10682"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.17/ocdeck_darwin_amd64.tar.gz"
    sha256 "464af78152e45ac3d76385288613f343c71490a526d6f9347e276d1c5d09a64b"
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
