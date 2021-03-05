# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Project IceStorm - Lattice iCE40 FPGAs Bitstream Documentation"
HOMEPAGE="https://www.clifford.at/icestorm"

inherit git-r3

EGIT_REPO_URI="https://github.com/YosysHQ/icestorm"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

DEPEND="dev-embedded/libftdi"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
}
