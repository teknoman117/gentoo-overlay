EAPI=7

GIT_COMMI=0ccc7229c02449618209a20d66b9fa07e3ea79f2
ABC_GIT_COMMIT=4f5f73d18b137930fb3048c0b385c82fa078db38
S=$WORKDIR/$PN-$GIT_COMMIT

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/$PN/archive/0ccc72.tar.gz -> $P.tar.gz
	 https://github.com/YosysHQ/abc/archive/4f5f73.tar.gz -> abc-4f5f73.tar.gz"
LICENSE=ISC
SLOT=0
KEYWORDS=

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
