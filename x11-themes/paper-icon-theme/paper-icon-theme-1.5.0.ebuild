# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Paper is a modern freedesktop icon theme whose design is based around the use of bold colours and simple geometric shapes to compose icons"
HOMEPAGE="https://github.com/snwh/paper-icon-theme"
SRC_URI="https://github.com/snwh/paper-icon-theme/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v.${PV}"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

DEPEND="x11-themes/adwaita-icon-theme"
RDEPEND="${DEPEND}"
