# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib autotools

DESCRIPTION="Groupware with BBS/Email/XMPP Server, Collaboration and Calendar"
HOMEPAGE="http://www.citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gc ldap pam pie postfix ssl"

DB_SLOT=4.5

RDEPEND="
	dev-libs/expat
	>=dev-libs/libcitadel-${PV}
	dev-libs/libev
	dev-libs/libical
	mail-filter/libsieve
	net-dns/c-ares
	net-misc/curl
	sys-libs/db:${DB_SLOT}
	virtual/libiconv
	virtual/libintl
	gc? ( dev-libs/boehm-gc )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl:* )
	"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure-ac-db.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-autosysconfdir=/var/lib/${PN}/data \
		--with-datadir=/var/lib/${PN} \
		--with-docdir=/usr/share/doc/${PF} \
		--with-helpdir=/usr/share/${PN}-server \
		--with-localedir=/usr/share \
		--with-rundir=/var/run/${PN} \
		--with-spooldir=/var/spool/${PN} \
		--with-ssldir=/etc/ssl/${PN} \
		--with-staticdatadir=/etc/${PN} \
		--with-sysconfdir=/etc/${PN} \
		--with-utility-bindir=/usr/$(get_libdir)/${PN} \
		\
		--with-db-include=/usr/include/db${DB_SLOT}/ \
		--with-db-lib=/usr/$(get_libdir) \
		--with-db-name=db-${DB_SLOT} \
		\
		$(use_with gc with_gc) \
		$(use_with ldap with_ldap) \
		$(use_with pam) \
		$(use_enable pie) \
		$(use_with ssl)
}

src_install() {
	emake DESTDIR="${D}" install-new

	if use postfix ; then
		rm -v "${D}"/usr/sbin/sendmail || die
	fi
}
