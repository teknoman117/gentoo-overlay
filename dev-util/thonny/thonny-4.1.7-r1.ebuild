# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8,9,10,11,12,13} )
PYTHON_REQ_USE="tk"

inherit distutils-r1 xdg-utils desktop

DESCRIPTION="Python IDE meant for learning programming"
HOMEPAGE="https://thonny.org"
SRC_URI="https://codeload.github.com/thonny/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/asttokens-2.0[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.18.1[${PYTHON_USEDEP}]
	>=dev-python/mypy-0.761[${PYTHON_USEDEP}]
	>=dev-python/send2trash-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/pylint-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyserial-3.4[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	>=dev-python/setuptools-45.2.0[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	newmenu packaging/linux/org.thonny.Thonny.desktop thonny.desktop
	doicon thonny/res/thonny.png
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
