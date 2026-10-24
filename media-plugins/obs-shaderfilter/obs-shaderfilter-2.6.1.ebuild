# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OBS Studio filter for applying custom shaders to sources"
HOMEPAGE="https://github.com/exeldro/obs-shaderfilter"
SRC_URI="https://github.com/exeldro/obs-shaderfilter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-video/obs-studio
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/-Werror$/d' cmake/ObsPluginHelpers.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_OUT_DIR=/$(get_libdir)/obs-plugins
		-DLINUX_PORTABLE=OFF
	)

	cmake_src_configure
}
