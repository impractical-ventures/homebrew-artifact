class Artifact < Formula
  desc "Package, deploy and run evaluators"
  homepage "https://github.com/impractical-ventures/artifact"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/impractical-ventures/artifact/releases/download/v0.1.1/artifact-aarch64-apple-darwin.tar.xz"
      sha256 "fb754b9201cec292598ace971daf6c173d76c586cc71ff835f77f167fcb742a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/impractical-ventures/artifact/releases/download/v0.1.1/artifact-x86_64-apple-darwin.tar.xz"
      sha256 "09e079cd99403adcab20c6ced3c587c4fdb24c14535e09ec0301cee9398d9218"
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
