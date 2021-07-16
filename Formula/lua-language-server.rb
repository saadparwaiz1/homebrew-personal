class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "2.3.0",
    revision: "9889dc0d1c9673575ebbfa62f3d47d59d0ff8664"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

  bottle do
    root_url "https://github.com/saadparwaiz1/homebrew-personal/releases/download/lua-language-server-2.3.0"
    sha256 cellar: :any,                 catalina:     "edeb9448208d25fc4996ba3f6a3e919750d1c71d66b9111d9f188e21d3faaaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a81539e6df6132e14630e435f3989326036c9e74dc5cc8be4b9eec8809dedc54"
  end

  depends_on "ninja" => :build

  def install
    cd "#{buildpath}/3rd/luamake" do
      on_macos do
        system "ninja", "-f", "compile/ninja/macos.ninja"
      end

      on_linux do
        system "ninja", "-f", "compile/ninja/linux.ninja"
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
