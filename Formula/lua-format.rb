class LuaFormat < Formula
  desc "Formatter For Lua"
  homepage "https://github.com/Koihik/LuaFormatter"
  url "https://github.com/Koihik/LuaFormatter.git",
    tag:      "1.3.5",
    revision: "638ec8a7c114a0082ce60481afe8f46072e427e5"
  license "MIT"
  head "https://github.com/Koihik/LuaFormatter.git"

  depends_on "cmake" => :build

  def install
    system "cmake", "."
    system "make"
    system "make", "install"
  end

  test do
    system "lua-format -h"
  end
end
