EAPI=7

GIT_COMMIT=cfe940a98b08f1a5d08fb44427db155ba1f18b62
ABC_GIT_COMMIT=f6fa2ddcfc89099726d60386befba874c7ac1e0d
S=$WORKDIR/$PN-$GIT_COMMIT

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/$PN/archive/$GIT_COMMIT.tar.gz -> $P.tar.gz
	 https://github.com/YosysHQ/abc/archive/$ABC_GIT_COMMIT.tar.gz -> abc-$ABC_GIT_COMMIT.tar.gz"
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
