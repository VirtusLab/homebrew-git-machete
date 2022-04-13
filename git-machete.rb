class GitMachete < Formula
  include Language::Python::Virtualenv
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.8.0.tar.gz"
  sha256 "54bced07116e19a1f5f724ad1d458415b0c8f349e807eff9b9e29cdd671cce2a"
  depends_on "python"

  def install
    virtualenv_install_with_resources

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "master\n  develop"
    expected_output = "  master\n  | \n  | Other commit\n  o-develop *\n"
    assert_match expected_output, shell_output("git machete status --list-commits")
  end
end
