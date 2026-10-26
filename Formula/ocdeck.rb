class Ocdeck < Formula
  desc "自托管的 opencode 任务编排 Web 控制台"
  homepage "https://github.com/Endlex-net/ex-ocdeck"
  version "0.0.30"

  on_arm do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.30/ocdeck_darwin_arm64.tar.gz"
    sha256 "6360b6abfec30d418c681dc395ca758d9f30c3143a3ea4f0714f453692d0a245"
  end

  on_intel do
    url "https://github.com/Endlex-net/ex-ocdeck/releases/download/v0.0.30/ocdeck_darwin_amd64.tar.gz"
    sha256 "9e14f9f566f3412d8ea55c2191dafb4d340f0f14d8377c9461d19618dca6e51e"
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
