# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} )

inherit distutils-r1

DESCRIPTION="Pipe stdin to stdout at a bandwidth capped by time of day"
HOMEPAGE="https://github.com/teknoman117/pacer"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/teknoman117/pacer.git"
else
	SRC_URI="https://github.com/teknoman117/pacer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

distutils_enable_tests pytest
