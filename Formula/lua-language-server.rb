class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "1.16.0",
    revision: "ebbf09bb27bf54168701f92af51ca774205b77d0"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

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
        #{opt_prefix}/macOS/lua-language-server -E #{opt_prefix}/main.lua
      EOS
    end

    on_linux do
      IO.write "lua-langserver", <<~EOS
        #!/bin/sh
        #{opt_prefix}/Linux/lua-language-server -E #{opt_prefix}/main.lua
      EOS
    end

    bin.install "lua-langserver"
  end

  test do
    system "echo", "0"
  end
end
