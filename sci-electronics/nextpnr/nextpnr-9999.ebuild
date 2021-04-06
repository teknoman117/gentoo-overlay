# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Portable FPGA place and route tool"
HOMEPAGE="https://github.com/YosysHQ/nextpnr"
EGIT_REPO_URI="https://github.com/YosysHQ/nextpnr"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

IUSE="+ecp5 +ice40 qt5"

DEPEND="
	ecp5? (
		sci-electronics/prjtrellis
		sci-electronics/yosys
	)
	ice40? (
		sci-electronics/icestorm
		sci-electronics/yosys
	)
	qt5? ( dev-qt/qtcore:5 )
	dev-cpp/eigen:3
	dev-libs/boost:=[threads]
	"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DARCH="$(usex ice40 'ice40;' '')$(usex ecp5 'ecp5' '')"
		-DBUILD_GUI=ON
		-DUSE_OPENMP=ON
		-DBUILD_SHARE_LIBS=OFF
	)
	cmake-utils_src_configure
}
