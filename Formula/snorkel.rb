class Snorkel < Formula
  desc "Package, deploy and run evaluators"
  homepage "https://github.com/impractical-ventures/artifact"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/impractical-ventures/artifact/releases/download/v0.1.0/snorkel-aarch64-apple-darwin.tar.xz"
      sha256 "1a0e58bef6a145bb431ba232442094aba062d59ee490fd00b9bbe3329b7a7ec1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/impractical-ventures/artifact/releases/download/v0.1.0/snorkel-x86_64-apple-darwin.tar.xz"
      sha256 "bfa2e7c0fbaa950abea8d42f4cfe522d8a6a5e95a7bb1690bc3ef465d71c3c0c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "snorkel"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "snorkel"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
  def post_install
    generate_completions_from_executable(bin/"snorkel", "completions", shells: [:bash, :zsh, :fish])
  end

end
