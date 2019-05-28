class Kpat < Formula
  desc "Solitaire card games"
  homepage "http://games.kde.org/"
  url "https://download.kde.org/stable/applications/19.04.0/src/kpat-19.04.0.tar.xz"
  version "19.04"
  revision 0
  sha256 "bcd295a3df422b5cfa8258bb3cd0be7e4405f44604681d98589f2982c44414a1"
  head "git://anongit.kde.org/kpat.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "KDE-mac/kde/kf5-plasma-framework" => :build
  depends_on "ninja" => :build

  depends_on "hicolor-icon-theme"
  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kactivities"
  depends_on "KDE-mac/kde/kf5-kitemmodels"
  depends_on "KDE-mac/kde/kf5-knewstuff"
  depends_on "KDE-mac/kde/kf5-threadweaver"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
    # Extract Qt plugin path
    qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kate.app/Contents/Info.plist"
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kwrite.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/kate"
    mkdir_p HOMEBREW_PREFIX/"share/kwrite"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kate/icontheme.rcc"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kwrite/icontheme.rcc"
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
     "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
  EOS
  end

  test do
    assert `"#{bin}/kate.app/Contents/MacOS/kate" --help | grep -- --help` =~ /--help/
    assert `"#{bin}/kwrite.app/Contents/MacOS/kwrite" --help | grep -- --help` =~ /--help/
  end
end
