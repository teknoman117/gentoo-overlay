# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib rpm

MY_P="${PN}-${PV%.*}-${PV##*.}"
DESCRIPTION="Brother scanner driver"
HOMEPAGE="http://www.brother.com/"
SRC_URI="${MY_P}.x86_64.rpm"

LICENSE="Brother-lpr no-source-code"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch strip"

RDEPEND="media-gfx/sane-backends
	virtual/libusb:0"

S="${WORKDIR}/opt/brother/scanner/${PN}"

pkg_nofetch() {
	einfo "please download ${MY_P}.x86_64.rpm"
}

src_install() {
	local lib=$(get_libdir)
	local dest=/opt/brother/scanner/${PN}

	insinto /etc${dest}
	doins Brsane4.ini brsanenetdevice4.cfg
	doins -r models4
	dosym /etc${dest}/Brsane4.ini ${dest}/Brsane4.ini
	dosym /etc${dest}/brsanenetdevice4.cfg ${dest}/brsanenetdevice4.cfg
	dosym /etc${dest}/models4 ${dest}/models4

	into ${dest}
	dobin brsaneconfig4
	dosym ${dest}/bin/brsaneconfig4 /usr/bin/brsaneconfig4

	dolib.so "${WORKDIR}"/usr/lib*/sane/libsane-brother4.so.1.0.7
	dosym ${dest}/${lib}/libsane-brother4.so.1.0.7 \
		  /usr/${lib}/sane/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so

	insinto /etc/sane.d/dll.d
	newins - ${PN} <<< "brother4"
}
