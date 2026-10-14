EAPI=8

DESCRIPTION="Customizable xterm-256 Bash prompt colors"
HOMEPAGE="https://github.com/n-e-o-w-u-l-f/shell-color"
SRC_URI="https://github.com/n-e-o-w-u-l-f/shell-color/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RDEPEND="app-shells/bash"

src_install() {
  dobin bin/shell-color
  insinto /usr/share/shell-color
  doins src/shell-color.sh
  insinto /etc/profile.d
  doins profile.d/shell-color.sh
}
