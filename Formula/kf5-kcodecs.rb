class Kf5Kcodecs < Formula
  desc "Collection of methods to manipulate strings"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.58/kcodecs-5.58.0.tar.xz"
  sha256 "6e5b3c2083c840947e255d58b338128a5e498a4176969f6ac724d56ca3cae8ef"

  head "git://anongit.kde.org/kcodecs.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gperf" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "ninja" => :build

  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Codecs REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
