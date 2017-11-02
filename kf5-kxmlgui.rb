require "formula"

class Kf5Kxmlgui < Formula
  desc "User configurable main windows"
  homepage "http://www.kde.org/"
  url "https://download.kde.org/stable/frameworks/5.39/kxmlgui-5.39.0.tar.xz"
  sha256 "2584cf5b39414b4bf76817d5f09dcdf5cd2e1554ac424386a0f0fa0173089e7f"

  head "git://anongit.kde.org/kxmlgui.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "qt"
  depends_on "KDE-mac/kde/kf5-kglobalaccel"
  depends_on "KDE-mac/kde/kf5-ktextwidgets"
  depends_on "KDE-mac/kde/kf5-attica"

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
