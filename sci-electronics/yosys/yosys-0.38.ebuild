EAPI=7

ABC_GIT_COMMIT=896e5e7dedf9b9b1459fa019f1fa8aa8101fdf43
S=$WORKDIR/$PN-$P

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/$PN/archive/$P.tar.gz -> $P.tar.gz
	 https://github.com/YosysHQ/abc/archive/$ABC_GIT_COMMIT.tar.gz -> abc-$ABC_GIT_COMMIT.tar.gz"
LICENSE=ISC
SLOT=0
KEYWORDS="~amd64"

DEPEND="dev-vcs/git
	media-gfx/xdot
	dev-libs/boost"

src_prepare() {
	ln -s ${WORKDIR}/abc-${ABC_GIT_COMMIT} ${S}/abc
	eapply_user
}

src_configure() {
	emake config-gcc
	echo "ENABLE_LIBYOSYS=1" >> Makefile.conf
	echo "ABCREV=default" >> Makefile.conf
	echo "ABCPULL=0" >> Makefile.conf
	echo "PREFIX=/usr" >> Makefile.conf
	echo "DESTDIR=\"${D}\"" >> Makefile.conf
}

src_compile() {
	emake
}

src_install() {
	emake install
}
