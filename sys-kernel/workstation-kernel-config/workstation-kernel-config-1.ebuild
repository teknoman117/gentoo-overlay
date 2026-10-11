# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Kernel config fragments for sys-kernel/gentoo-kernel on workstation profiles"
HOMEPAGE="https://github.com/teknoman117/gentoo-overlay"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto /etc/kernel/config.d
	doins "${FILESDIR}"/10-workstation.config
}

pkg_postinst() {
	elog "Kernel config fragments are only applied when the kernel is built."
	elog "If they changed, rebuild the kernel with:"
	elog "  emerge --oneshot sys-kernel/gentoo-kernel"
}
