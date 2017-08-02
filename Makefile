Version=0.4

PREFIX = /usr/local
SYSCONFDIR = /etc

BASE = \
	$(wildcard base/Packages-*) \
	base/profile.conf

INFO = \
	repo_info

LIVE_ETC = \
	base/live-overlay/etc/issue \
	base/live-overlay/etc/fstab

LIVE_ETC_DEFAULT = \
	$(wildcard base/live-overlay/etc/default/*)

LIVE_ETC_PAM = \
	$(wildcard base/live-overlay/etc/pam.d/*)

LIVE_ETC_SUDOERS = \
	$(wildcard base/live-overlay/etc/sudoers.d/*)

LXQT = \
	$(wildcard lxqt/Packages-*) \
	lxqt/profile.conf

CINNAMON = \
	$(wildcard cinnamon/Packages-*) \
	cinnamon/profile.conf

CINNAMON_LIGHTDM = \
	$(wildcard cinnamon/desktop-overlay/etc/lightdm/*.conf)

install_base:
	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles
	install -m0644 ${INFO} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base
	install -m0644 ${BASE} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc
	install -m0644 ${LIVE_ETC} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/default
	install -m0644 ${LIVE_ETC_DEFAULT} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/default

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/pam.d
	install -m0644 ${LIVE_ETC_PAM} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/pam.d

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/sudoers.d
	install -m0644 ${LIVE_ETC_SUDOERS} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/sudoers.d

install_profiles:
	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/lxqt
	install -m0644 ${LXQT} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/lxqt

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon
	install -m0644 ${CINNAMON} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon

	install -dm0755 $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon/desktop-overlay/etc/lightdm
	install -m0644 ${CINNAMON_LIGHTDM} $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon/desktop-overlay/etc/lightdm

uninstall_base:
	for f in ${INFO}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/$$f; done
	for f in ${BASE}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/$$f; done
	for f in ${LIVE_ETC}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/$$f; done
	for f in ${LIVE_ETC_DEFAULT}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/default/$$f; done
	for f in ${LIVE_ETC_PAM}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/pam.d/$$f; done
	for f in ${LIVE_ETC_SUDOERS}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/base/live-overlay/etc/sudoers.d/$$f; done

uninstall_profiles:
	for f in ${LXQT}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/lxqt/$$f; done
	for f in ${CINNAMON}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon/$$f; done
	for f in ${CINNAMON_LIGHTDM}; do rm -f $(DESTDIR)$(PREFIX)/share/artools/iso-profiles/cinnamon/desktop-overlay/etc/lightdm/$$f; done

install: install_base install_profiles

uninstall: uninstall_base uninstall_profiles

dist:
	git archive --format=tar --prefix=iso-profiles-$(Version)/ $(Version) | gzip -9 > iso-profiles-$(Version).tar.gz
	gpg --detach-sign --use-agent iso-profiles-$(Version).tar.gz

.PHONY: install uninstall dist