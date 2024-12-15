# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..11} )

inherit cmake python-single-r1

DESCRIPTION="Portable FPGA place and route tool"
HOMEPAGE="https://github.com/YosysHQ/nextpnr"
SRC_URI="https://github.com/YosysHQ/$PN/archive/$P.tar.gz"

S="${WORKDIR}/${PN}-${P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

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

PATCHES=(
	"${FILESDIR}/exact-python-version.patch"
	"${FILESDIR}/boost.patch"
)

src_configure() {
	version=${PYTHON_SINGLE_TARGET#"python"}
	version=${version//_/.}
	local mycmakeargs=(
		-DARCH="$(usex ice40 'ice40;' '')$(usex ecp5 'ecp5;' '')$(usex nexus 'nexus' '')"
		-DBUILD_GUI=$(usex qt5 'ON' 'OFF')
		-DUSE_OPENMP=ON
		-DBUILD_SHARED_LIBS=OFF
		-DBUILD_PYTHON_VERSION=${version}
	)
	cmake_src_configure
}
