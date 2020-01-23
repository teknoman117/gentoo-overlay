# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An open source program for controlling the MiniPRO TL866xx series of chip programmers"
HOMEPAGE="https://gitlab.com/DavidGriffith/minipro"
SRC_URI="https://gitlab.com/DavidGriffith/minipro/-/archive/${PV}/minipro-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
}
