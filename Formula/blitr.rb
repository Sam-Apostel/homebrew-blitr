class Blitr < Formula
  desc "Render SwiftUI previews to PNG without a simulator"
  homepage "https://github.com/Sam-Apostel/blitr"
  version "1.0.0"

  depends_on :macos

  on_arm do
    url "https://github.com/Sam-Apostel/blitr/releases/download/v1.0.0/blitr-v1.0.0-macos-arm64.tar.gz"
    sha256 "1a2cbce34ce68102444370141fa0db5c0924d0cbf0dedb01c946ce9e6266e891"
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
