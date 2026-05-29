class Artifact < Formula
  desc "Package, deploy and run evaluators"
  homepage "https://github.com/impractical-ventures/artifact"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/impractical-ventures/homebrew-artifact/releases/download/v0.1.2/artifact-aarch64-apple-darwin.tar.xz"
      sha256 "88ada73229975708ee7475e2eb56c65c1cb0714b084cadde0837bb9582318b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/impractical-ventures/homebrew-artifact/releases/download/v0.1.2/artifact-x86_64-apple-darwin.tar.xz"
      sha256 "95613c80d46388f3c09588b0501d9d25c8766231c057411196c16e55a2c231f0"
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
      bin.install "artifact"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "artifact"
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
    generate_completions_from_executable(bin/"artifact", "completions", shells: [:bash, :zsh, :fish])
  end

end
