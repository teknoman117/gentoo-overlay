# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="OBS Studio plugin to use an Android or iOS device as a camera source"
HOMEPAGE="https://github.com/dev47apps/droidcam-obs-plugin"
SRC_URI="https://github.com/dev47apps/droidcam-obs-plugin/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/droidcam-obs-plugin-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="android ios qt6"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-video/ffmpeg:=
	media-video/obs-studio
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)
	ios? (
		app-pda/libimobiledevice:=
		app-pda/libusbmuxd:=
	)
"
RDEPEND="
	${DEPEND}
	android? ( dev-util/android-tools )
	ios? ( app-pda/usbmuxd )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-optional-ios.patch
)

src_compile() {
	tc-export CXX PKG_CONFIG
	mkdir build || die

	# Variables are passed through the environment because the Makefile
	# appends to them, which a command-line assignment would override.
	CXXFLAGS="${CXXFLAGS}" \
	LDD_LIBS="$(${PKG_CONFIG} --libs libavcodec libavutil || die) $(usev qt6 -lobs-frontend-api)" \
	LDD_FLAG="${LDFLAGS}" \
	ENABLE_GUI=$(usex qt6) \
	ENABLE_IOS=$(usex ios) \
	LIBUSBMUXD=libusbmuxd-2.0 \
	LIBIMOBILEDEV=libimobiledevice-1.0 \
	FFMPEG_INCLUDES="${ESYSROOT}/usr/include" \
	LIBOBS_INCLUDES="${ESYSROOT}/usr/include/obs" \
	emake
}

src_install() {
	insinto /usr/$(get_libdir)/obs-plugins
	doins build/droidcam-obs.so

	insinto /usr/share/obs/obs-plugins/droidcam-obs
	doins -r data/.

	einstalldocs
}

pkg_postinst() {
	use ios && elog "iOS USB support requires the usbmuxd service to be running."
}
