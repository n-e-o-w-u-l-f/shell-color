VERSION := $(shell cat VERSION)

.PHONY: all test test-bsd test-linux test-windows test-bsd lint ci-linux ci-windows tarball deb rpm arch packages clean

all: test

test: test-linux test-bsd test-windows

test-linux:
	./tests/test-linux.sh
	sh ./tests/test-netbsd.sh
	./tests/test-links.sh

test-bsd:
	sh ./tests/test-netbsd.sh
	sh ./tests/test-freebsd.sh

test-windows:
	@if command -v pwsh >/dev/null 2>&1; then pwsh -NoProfile -File ./tests/test-windows.ps1; else echo "pwsh not installed; Windows tests skipped"; fi

lint:
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck bin/shell-color ci/linux.sh install/*.sh profile.d/shell-color.sh scripts/*.sh tests/*.sh; else echo "shellcheck not installed; lint skipped"; fi

ci-linux:
	./ci/linux.sh

ci-windows:
	@if command -v pwsh >/dev/null 2>&1; then pwsh -NoProfile -File ./ci/windows.ps1; else echo "pwsh is required for Windows CI" >&2; exit 1; fi

tarball:
	./scripts/build-tarball.sh

deb:
	./scripts/build-deb.sh

rpm:
	./scripts/build-rpm.sh

arch:
	./scripts/build-arch.sh

packages:
	./scripts/build-packages.sh

clean:
	rm -rf -- build dist
