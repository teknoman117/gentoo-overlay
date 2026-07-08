# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="Realtek WiFi 5 (rtw88) out-of-tree driver, backported from wireless-next"
HOMEPAGE="https://github.com/lwfinger/rtw88"
EGIT_REPO_URI="https://github.com/lwfinger/rtw88.git"

# Sources are SPDX "GPL-2.0 OR BSD-3-Clause".
LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
IUSE="firmware"

# rtw88 is a mac80211 driver, so the kernel must provide the 802.11 stack.
# It builds fine as long as MAC80211/CFG80211 are available; the PCI, SDIO
# (MMC) and USB glue modules are compiled conditionally by upstream's
# Makefile based on the running kernel's CONFIG_PCI / CONFIG_MMC config.
CONFIG_CHECK="MAC80211 CFG80211"

# Upstream states compatibility with Linux 5.4 and newer.
MODULES_KERNEL_MIN=5.4

# When not shipping the bundled blobs, pull them from linux-firmware, which
# carries the in-tree rtw88 firmware. Enabling USE=firmware installs the
# repository's own copies instead (see the warning in pkg_setup).
RDEPEND="!firmware? ( sys-kernel/linux-firmware )"

pkg_setup() {
	if use firmware; then
		ewarn "USE=firmware installs the firmware blobs bundled in this"
		ewarn "repository into /lib/firmware/rtw88. These files share names"
		ewarn "with sys-kernel/linux-firmware and will collide with it."
		ewarn "Only enable this flag if you specifically need the bundled"
		ewarn "firmware and are not relying on sys-kernel/linux-firmware."
	fi

	linux-mod-r1_pkg_setup
}

src_compile() {
	# The upstream Makefile's default target ('all') recurses into the
	# kernel build system with 'M=$PWD modules'. It looks up the kernel
	# build tree via KSRC, so point that at KV_OUT_DIR (the configured/
	# built kernel objtree). MODULES_MAKEARGS carries the toolchain
	# (CC/LD/ARCH/...) which make propagates to the recursive sub-make.
	local modargs=(
		KSRC="${KV_OUT_DIR}"
		JOBS="$(makeopts_jobs)"
	)

	emake "${MODULES_MAKEARGS[@]}" "${modargs[@]}"
}

src_install() {
	# Install into updates/ so the out-of-tree modules outrank any
	# equivalently placed in-kernel ones; the shipped modprobe config
	# additionally blacklists the in-kernel rtw88_* modules.
	linux_moduleinto updates/rtw88

	local mod
	for mod in rtw_*.ko; do
		[[ -f ${mod} ]] || die "no built modules found (rtw_*.ko missing)"
		linux_domodule "${mod}"
	done

	# strip -> sign -> compress the installed modules and register them
	# with the eclass (also required so pkg_postinst runs depmod).
	modules_post_process

	# Module options + blacklist of the conflicting in-kernel drivers.
	insinto /etc/modprobe.d
	doins rtw88.conf

	if use firmware; then
		insinto /lib/firmware/rtw88
		doins firmware/*.bin
	fi

	# reload_rtw88.sh is a systemd system-sleep helper for BIOSes that
	# mishandle D3hot->D0 on resume; ship it as documentation rather than
	# assuming systemd is in use.
	dodoc README.md reload_rtw88.sh
	einstalldocs
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	elog "The in-kernel rtw88 drivers are blacklisted via"
	elog "  /etc/modprobe.d/rtw88.conf"
	elog "which also sets the default module parameters. Review that file"
	elog "if you want to change options such as rtw_usb switch_usb_mode."
	elog
	elog "If your adapter fails to resume from suspend/hibernate, the"
	elog "reload_rtw88.sh helper (installed under /usr/share/doc/${PF})"
	elog "can be placed in your init system's sleep hooks to unload and"
	elog "reload the driver around a sleep cycle."

	if ! use firmware; then
		elog
		elog "Firmware is provided by sys-kernel/linux-firmware. Enable"
		elog "USE=firmware only if you need the blobs bundled with this repo."
	fi
}
