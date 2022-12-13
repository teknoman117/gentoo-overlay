# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The fast free Verilog/SystemVerilog simulator"
HOMEPAGE="https://www.veripool.org/wiki/verilator"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/verilator/${PN}"
else
	SRC_URI="https://github.com/verilator/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="0"

DEPEND="
	dev-lang/perl
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

src_prepare() {
	default
	eautoconf --force
}
