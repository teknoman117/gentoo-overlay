EAPI=7

S=$WORKDIR/$PN-$P

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/$PN/archive/$P.tar.gz -> $P.tar.gz
	 https://github.com/YosysHQ/$PN/releases/download/$P/abc.tar.gz -> abc-$P.tar.gz"
LICENSE=ISC
SLOT=0
KEYWORDS="~amd64"

DEPEND="dev-vcs/git
	media-gfx/xdot
	dev-libs/boost"

src_prepare() {
	mv ${WORKDIR}/abc-yosys-experimental/{.,}* ${S}/abc
	eapply_user
}

src_configure() {
	emake config-gcc
	echo "ENABLE_LIBYOSYS=1" >> Makefile.conf
#	echo "ABCREV=default" >> Makefile.conf
#	echo "ABCPULL=0" >> Makefile.conf
	echo "PREFIX=/usr" >> Makefile.conf
	echo "DESTDIR=\"${D}\"" >> Makefile.conf
}

src_compile() {
	emake
}

src_install() {
	emake install
}
