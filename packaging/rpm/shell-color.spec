Name:           shell-color
Version:        @VERSION@
Release:        1%{?dist}
Summary:        Customizable xterm-256 Bash prompt colors
License:        MIT
URL:            https://github.com/n-e-o-w-u-l-f/shell-color
BuildArch:      noarch
Requires:       bash
Source0:        shell-color.sh
Source1:        shell-color
Source2:        shell-color-profile.sh
Source3:        LICENCE.md

%description
shell-color colors Bash prompts, paths, numbers, links and selected command
output without wrapping privileged or interactive system commands.

%prep

%build

%install
install -Dpm 0755 %{SOURCE1} %{buildroot}%{_bindir}/shell-color
install -Dpm 0644 %{SOURCE0} %{buildroot}%{_datadir}/shell-color/shell-color.sh
install -Dpm 0644 %{SOURCE2} %{buildroot}%{_sysconfdir}/profile.d/shell-color.sh
install -Dpm 0644 %{SOURCE3} %{buildroot}%{_licensedir}/shell-color/LICENCE.md

%files
%license %{_licensedir}/shell-color/LICENCE.md
%{_bindir}/shell-color
%{_datadir}/shell-color/shell-color.sh
%config(noreplace) %{_sysconfdir}/profile.d/shell-color.sh

%changelog
* Mon Aug 10 2026 Neowulf <megalod0n@live.de> - @VERSION@-1
- Initial shell-color package
