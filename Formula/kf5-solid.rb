class Kf5Solid < Formula
  desc "Hardware integration and detection"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.58/solid-5.58.0.tar.xz"
  sha256 "7d7f2daaffe8536ee9373375b866c94b949e58f0365990dfe16f9cc05f98bd00"

  head "git://anongit.kde.org/solid.git"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flex" => :build
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
    # setTime_t function is deprecated since 5.8.
    args << "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050700"
    args << "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050700"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Solid REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
