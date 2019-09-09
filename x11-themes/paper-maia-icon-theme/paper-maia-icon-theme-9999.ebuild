# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Maia variation of the paper icon theme."
HOMEPAGE="https://bitbucket.org/vaibhavlinux/paper-maia-icon-theme"
EGIT_REPO_URI="https://bitbucket.org/vaibhavlinux/paper-maia-icon-theme.git"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

DEPEND="x11-themes/paper-icon-theme"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/icons
	doins -r Paper-Maia
	doins -r Paper-Maia-Mono-Dark

	ln -s /usr/share/icons/Paper-Mono-Dark/22x22 "${D}/usr/share/icons/Paper-Maia-Mono-Dark"
	ln -s /usr/share/icons/Paper-Mono-Dark/24x24 "${D}/usr/share/icons/Paper-Maia-Mono-Dark"
}
