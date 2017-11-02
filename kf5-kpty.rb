require "formula"

class Kf5Kpty < Formula
  desc "Pty abstraction"
  homepage "http://www.kde.org/"
  url "https://download.kde.org/stable/frameworks/5.39/kpty-5.39.0.tar.xz"
  sha256 "16d26608a7bb5feb085aba7162e6d0ed151f1aace6fbdf7c68a8ccc1c76b060a"

  head "git://anongit.kde.org/kpty.git"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "qt"
  depends_on "KDE-mac/kde/kf5-kcoreaddons"
  depends_on "KDE-mac/kde/kf5-kjs"
  depends_on "KDE-mac/kde/kf5-ki18n"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end
end
