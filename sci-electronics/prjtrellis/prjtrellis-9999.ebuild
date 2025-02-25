# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{5..13} )

DESCRIPTION="Documenting the Lattice ECP5 bit-stream format."
HOMEPAGE=""

inherit cmake git-r3 python-single-r1

EGIT_REPO_URI="https://github.com/YosysHQ/prjtrellis"
EGIT_SUBMODULES=("database")

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

DEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	dev-embedded/openocd[ftdi]"
RDEPEND="${DEPEND}"
BDEPEND=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CMAKE_IN_SOURCE_BUILD=1
CMAKE_USE_DIR="${S}/libtrellis"
