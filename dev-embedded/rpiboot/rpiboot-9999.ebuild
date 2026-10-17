# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="USB boot and mass storage gadget loader for Raspberry Pi Compute Modules and Pi 4/5"
HOMEPAGE="https://github.com/raspberrypi/usbboot"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raspberrypi/usbboot.git"
	# rpi-eeprom submodule is not needed by the build or install
	EGIT_SUBMODULES=()
else
	MY_PV="${PV/./-}"
	# boot.img in the 20261002-115811 release is corrupted, use the one
	# from upstream commit 861a703 ("mass-storage-gadget64: Fix corrupted boot.img")
	BOOTIMG_COMMIT="861a703d8b51f42b76bcdff49da3e0f2766966bf"
	SRC_URI="
		https://github.com/raspberrypi/usbboot/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://raw.githubusercontent.com/raspberrypi/usbboot/${BOOTIMG_COMMIT}/mass-storage-gadget64/boot.img -> ${PN}-mass-storage-gadget64-boot-${BOOTIMG_COMMIT:0:7}.img
	"
	S="${WORKDIR}/usbboot-${MY_PV}"
	KEYWORDS="~amd64 ~arm64"
fi

# boot.img images contain a Linux kernel and initramfs
LICENSE="Apache-2.0 GPL-2 raspberrypi-videocore-bin"
SLOT="0"
RESTRICT="mirror"
# Prebuilt Raspberry Pi firmware blobs
QA_PREBUILT="usr/share/rpiboot/*"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( Readme.md )

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		# the boot.img distfile is not an archive, it is copied in src_prepare
		unpack ${P}.tar.gz
	fi
}

src_prepare() {
	default
	if [[ ${PV} != 9999 ]]; then
		cp "${DISTDIR}/${PN}-mass-storage-gadget64-boot-${BOOTIMG_COMMIT:0:7}.img" \
			mass-storage-gadget64/boot.img || die
	fi
	sed -i "s:\`pkg-config :\`$(tc-getPKG_CONFIG) :" Makefile || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		INSTALL_PREFIX="${EPREFIX}/usr"
		# always use the bundled bin2c rather than xxd if it happens to be installed
		HAVE_XXD=
	)
	if [[ ${PV} == 9999 ]]; then
		myemakeargs+=( GIT_VER="${EGIT_VERSION:0:8}" )
	else
		myemakeargs+=(
			GIT_VER=
			PKG_VER="${MY_PV}"
			BUILD_DATE="${PV:0:4}/${PV:4:2}/${PV:6:2}"
		)
	fi
	if [[ -n ${SOURCE_DATE_EPOCH} ]]; then
		myemakeargs+=( BUILD_DATE="$(date -u -d "@${SOURCE_DATE_EPOCH}" "+%Y/%m/%d")" )
	fi
	emake "${myemakeargs[@]}"
}

src_install() {
	emake INSTALL_PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	dostrip -x /usr/share/rpiboot
	# upstream only ships the udev rule on its debian branch
	udev_dorules "${FILESDIR}"/70-rpiboot.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Non-root access to Raspberry Pi devices in USB boot mode is granted"
		elog "through the udev uaccess tag, which requires systemd-logind or elogind."
		elog "Without either, run rpiboot as root."
	fi
}

pkg_postrm() {
	udev_reload
}
