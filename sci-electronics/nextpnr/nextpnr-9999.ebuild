# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{5..13} )

inherit cmake git-r3 python-single-r1

DESCRIPTION="Portable FPGA place and route tool"
HOMEPAGE="https://github.com/YosysHQ/nextpnr"
EGIT_REPO_URI="https://github.com/YosysHQ/$PN"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

IUSE="+ecp5 +ice40 nexus qt5"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	ecp5? (
		sci-electronics/prjtrellis
		sci-electronics/yosys
	)
	ice40? (
		sci-electronics/icestorm
		sci-electronics/yosys
	)
	nexus? (
		sci-electronics/prjoxide
		sci-electronics/yosys
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtopengl:5
	)
	dev-cpp/eigen:3
	>=dev-libs/boost-1.77:=
	"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DARCH="$(usex ice40 'ice40;' '')$(usex ecp5 'ecp5;' '')$(usex nexus 'nexus' '')"
		-DBUILD_GUI=$(usex qt5 'ON' 'OFF')
		-DUSE_OPENMP=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}
