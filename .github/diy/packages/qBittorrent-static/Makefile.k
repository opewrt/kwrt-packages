#
# Copyright (C) 2017-2020
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qBittorrent-static
PKG_VERSION:=4.5.2_v2.0.8
PKG_RELEASE=1

STRIP:=true

ifeq ($(ARCH),x86_64)
	PKG_ARCH:=x86_64
	PKG_HASH:=ceaf566b0212bd173abb5ecc6a041eaaf945a44aa79ca3921db7eef26cc929cd
endif

ifeq ($(ARCH),arm64)
	PKG_ARCH:=aarch64
	PKG_HASH:=b32706eb9d30c6319f428304d614fdfcac8bfc7d52b40a0a359b2fa825bf37c3
endif

ifeq ($(ARCH),aarch64)
	PKG_ARCH:=aarch64
	PKG_HASH:=b32706eb9d30c6319f428304d614fdfcac8bfc7d52b40a0a359b2fa825bf37c3
endif

ifeq ($(ARCH),arm)
	PKG_ARCH:=armv7
	PKG_HASH:=57a93578920dbfa0683d71fe4eb7504652163de27f95997b808bd3b61212372c
endif

include $(INCLUDE_DIR)/package.mk

define Package/qBittorrent-static
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=@(arm||aarch64||x86_64)
  SUBMENU:=BitTorrent
  TITLE:=bittorrent client programmed in C++ / Qt
  URL:=https://www.qbittorrent.org/
endef

define Package/qBittorrent-static/description
  qBittorrent is a bittorrent client programmed in C++ / Qt that uses
  libtorrent (sometimes called libtorrent-rasterbar) by Arvid Norberg.
  It aims to be a good alternative to all other bittorrent clients out
  there. qBittorrent is fast, stable and provides unicode support as
  well as many features.
endef

define Download/qbittorrent
  URL:=https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-$(PKG_VERSION)
  URL_FILE:=$(PKG_ARCH)-qbittorrent-nox
  FILE:=$(PKG_ARCH)-qbittorrent-nox
  HASH:=$(PKG_HASH)
endef

define Build/Compile
endef

define Package/qBittorrent-static/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/$(PKG_ARCH)-qbittorrent-nox $(1)/usr/bin/qbittorrent-nox
endef

$(eval $(call Download,qbittorrent))
$(eval $(call BuildPackage,qBittorrent-static))
