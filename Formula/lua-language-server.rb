class LuaLanguageServer < Formula
  desc "Language Server For Lua"
  homepage "https://github.com/sumneko/lua-language-server"
  url "https://github.com/sumneko/lua-language-server.git",
    tag:      "1.17.4",
    revision: "3faac26bdbf07e758d99889e9971a80c1d04d3d9"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git"

  bottle do
    root_url "https://github.com/saadparwaiz1/homebrew-personal/releases/download/lua-language-server-1.17.4"
    sha256 cellar: :any,                 catalina:     "ed285cf2f7ad50ccb5f9e10cf73e94f4b2b0edb71f35bd9de35cfc37ae8ca833"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5411f6bdceae9ac4a17c2faa2d49da2ec2dcf23e077cc5830a398fcc409e9d1"
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
