# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 multilib-minimal toolchain-funcs autotools

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="https://cairographics.org/cairomm/"
SRC_URI="https://cairographics.org/releases/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="1.16"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="aqua doc +svg X"

RDEPEND="
	>=x11-libs/cairo-1.12.10[aqua=,svg=,X=,${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.99.1:3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz )
"

src_prepare() {
	eapply "${FILESDIR}"/libsigc++3.0.patch
	eautoreconf
	# don't waste time building examples because they are marked as "noinst"
	sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' Makefile.in || die

	# don't waste time building tests
	# they require the boost Unit Testing framework, that's not in base boost
	sed -i 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' Makefile.in || die
	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		--disable-tests \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
