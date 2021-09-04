# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Figure out how to test all this and maybe support other versions
ADA_COMPAT=( gnat_2019 )
inherit ada multiprocessing llvm

DESCRIPTION="The GHDL VHDL simulator."
HOMEPAGE="http://ghdl.free.fr/"
SRC_URI="https://github.com/ghdl/ghdl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPLv2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=11

RDEPEND="
	<=sys-devel/llvm-11.1:=
"
DEPEND="
	${RDEPEND}
	${ADA_DEPS}
	test? (
		dev-python/pytest
		dev-python/pydecor
		=dev-python/pyVHDLModel-0.8.0
	)
"
RDEPEND="${DEPEND}"
BDEPEND=""

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/ghdl_1.0.0_configuration.patch
)

pkg_setup() {
	ada_pkg_setup
	llvm_pkg_setup
	local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
}

src_configure() {
	local llvm_config="$(get_llvm_prefix "$LLVM_MAX_SLOT")/bin/llvm-config"
	econf --with-llvm-config=${llvm_config}
}

src_test() {
	GHDL_PREFIX="${S}/ghdl" default
}
