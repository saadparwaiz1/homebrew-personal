class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://github.com/zdharma/zinit"
  url "https://github.com/zdharma/zinit.git",
    tag:      "v3.7",
    revision: "1641f10c7a77ba3edcacba4f4347eef2bb620c74"
  license "MIT"
  head "https://github.com/zdharma/zinit.git"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      In order to use zinit, please add the following to your .zshrc:

      typeset -gA ZINIT
      export ZINIT[BIN_DIR]=#{opt_prefix}
      export ZINIT[HOME_DIR]=#{opt_prefix}
      export ZINIT[ZCOMPDUMP_PATH]=path to zcompdump ~/.zcompdump by default
      export ZINIT[MUTE_WARNINGS]=1

      source $ZINIT[HOME_DIR]/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh"
  end
end
