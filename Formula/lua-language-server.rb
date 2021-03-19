class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "1.19.0",
    revision: "cbb6e6224094c4eb874ea192c5f85a6cba099588"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

  bottle do
    root_url "https://github.com/saadparwaiz1/homebrew-personal/releases/download/lua-language-server-1.19.0"
    sha256 cellar: :any,                 catalina:     "31f643fc175469656cb8f68fdde1eed883de7ed9f9491b328afb5e6e988f5d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0152cd11cc16fffca85f7e541adee96976fb9c8c938d043ca682bae66d3b2fb0"
  end

  depends_on "ninja" => :build

  def install
    cd "#{buildpath}/3rd/luamake" do
      on_macos do
        system "ninja", "-f", "ninja/macos.ninja"
      end

      on_linux do
        system "ninja", "-f", "ninja/linux.ninja"
      end
    end

    system "3rd/luamake/luamake", "rebuild"

    prefix.install "locale"
    prefix.install "meta"
    prefix.install "script"
    prefix.install "main.lua"
    prefix.install "platform.lua"
    prefix.install "debugger.lua"

    on_macos do
      prefix.install "bin/macOS" => "macOS"
    end

    on_linux do
      prefix.install "bin/Linux" => "Linux"
    end

    on_macos do
      IO.write "lua-langserver", <<~EOS
        #!/bin/sh
        #{opt_prefix}/macOS/lua-language-server #{opt_prefix}/main.lua --logpath=#{var}/log/lua-language-server --metapath=#{opt_prefix}/meta
      EOS
    end

    on_linux do
      IO.write "lua-langserver", <<~EOS
        #!/bin/sh
        #{opt_prefix}/Linux/lua-language-server #{opt_prefix}/main.lua --logpath=#{var}/log/lua-language-server --metapath=#{opt_prefix}/meta
      EOS
    end

    bin.install "lua-langserver"
  end

  test do
    (testpath/"test.lua").write('print("test")')
    on_macos do
      system "#{opt_prefix}/macOS/lua-language-server", (testpath/"test.lua")
    end
    on_linux do
      system "#{opt_prefix}/Linux/lua-language-server", (testpath/"test.lua")
    end
  end
end
