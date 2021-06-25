class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "2.0.4",
    revision: "84cc3ccc4ef1408299801a3fd24f9fd482f061e0"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

  bottle do
    root_url "https://github.com/saadparwaiz1/homebrew-personal/releases/download/lua-language-server-1.21.2"
    sha256 cellar: :any,                 catalina:     "17f3249d73585e2121985c2214d2e3e1196bbf1c9d72183410526795eb87efa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe5da6b8caf5757ddaab271c599649d7191b27020f1fa099f8de989b05530288"
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
