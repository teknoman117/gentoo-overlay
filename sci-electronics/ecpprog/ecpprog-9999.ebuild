# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/gregdavill/ecpprog"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

DEPEND="=dev-embedded/libftdi-1*"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/ecpprog"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
