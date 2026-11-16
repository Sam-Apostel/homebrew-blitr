class Blitr < Formula
  desc "Render SwiftUI previews to PNG without a simulator"
  homepage "https://github.com/Sam-Apostel/blitr"
  version "1.1.0"
  license "MIT"

  depends_on :macos

  on_arm do
    url "https://github.com/Sam-Apostel/blitr/releases/download/v1.1.0/blitr-v1.1.0-macos-arm64.tar.gz"
    sha256 "d3faf8ea657a593e1092c8115783035351047c8a151685f8ff2c886e5a0926e3"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/blitr"
  end

  def caveats
    <<~TEXT
      blitr compiles your SwiftUI code with Xcode's Swift compiler (or the Command Line Tools':
      xcode-select --install). For Apple's own fonts instead of the open substitutes, run:
        #{opt_libexec}/share/blitr/fetch-apple-fonts.sh --accept-apple-font-license
    TEXT
  end

  test do
    (testpath/"Hello.swift").write <<~SWIFT
      import SwiftUI
      #Preview { Text("Hello") }
    SWIFT
    ENV["BLITR_CACHE"] = testpath/"cache"
    system bin/"blitr", "render", testpath/"Hello.swift", "-o", testpath/"hello.png"
    assert_path_exists testpath/"hello.png"
  end
end
