# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="https://yosyshq.net/yosys/"
# Use the bundled release tarball, which vendors all git submodules
# (abc, cxxopts, fmt, tomlplusplus, slang, ...) that the plain GitHub
# archive omits. It is a tarbomb, so relocate it into ${S} in src_unpack.
SRC_URI="https://github.com/YosysHQ/${PN}/releases/download/v${PV}/yosys.tar.gz -> ${P}-bundle.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/libffi:=
	sys-libs/readline:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}
	media-gfx/xdot
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	dev-lang/python
"

src_unpack() {
	# Upstream ships a tarbomb; extract it into ${S} so cmake.eclass does
	# not warn about S=WORKDIR.
	mkdir "${S}" || die
	cd "${S}" || die
	unpack ${A}
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DYOSYS_INSTALL_LIBRARY=ON
	)
	cmake_src_configure
}
