EAPI=8

#S=$WORKDIR/$PN-$P

CXXOPTS_COMMIT="4bf61f08697b110d9e3991864650a405b3dd515d"

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/$PN/archive/v$PV.tar.gz -> $P.tar.gz
	https://github.com/YosysHQ/abc/archive/v$PV.tar.gz -> abc-$P.tar.gz
	https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz -> cxxopts-$P.tar.gz"
LICENSE=ISC
SLOT=0
KEYWORDS="~amd64"

DEPEND="dev-vcs/git
	media-gfx/xdot
	dev-libs/boost"

src_prepare() {
	mv ${WORKDIR}/abc-${PV}/{.,}* ${S}/abc
	mv ${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}/{.,}* ${S}/libs/cxxopts
	eapply_user
}

src_configure() {
	emake config-gcc
	echo "ENABLE_LIBYOSYS=1" >> Makefile.conf
	echo "PREFIX=/usr" >> Makefile.conf
	echo "DESTDIR=\"${D}\"" >> Makefile.conf
}

src_compile() {
	emake
}

src_install() {
	emake install
}
