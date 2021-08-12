class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "2.3.6",
    revision: "ccf476f0459ee983c97bfc06b0f7b888af918a07"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

  bottle do
    root_url "https://github.com/saadparwaiz1/homebrew-personal/releases/download/lua-language-server-2.3.6"
    sha256 cellar: :any,                 catalina:     "8f9fdb5a474a129d6893421dad1a11708ae6646d7117e3624e3a45cd3fdb20f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5633856ea37cc3cdfba0b013dc2ac61eff73a3a636729dff58511fc65b69a7a7"
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
