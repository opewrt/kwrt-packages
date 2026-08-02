# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021-2022  sirpdboy  <herboy2008@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lucky
PKG_VERSION:=2.14.0
PKG_RELEASE:=3

LUCKY_SUPPORTED:=0

ifeq ($(ARCH),mipsel)
	LUCKY_ARCH:=mipsle_softfloat
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=16c459a9afaf946e6be9c3b578138754e02537f68c1f20917623dd86ad397525
endif
ifeq ($(ARCH),mips)
	LUCKY_ARCH:=mips_softfloat
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=8cce972cd2ec77183b648a3ac3f63af66644abca603c4a32674dfe46e4da1621
endif
ifeq ($(ARCH),arm)
	LUCKY_ARCH:=armv5
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=cb76bd595f5daac0054c77deefdaa42b1719d19b172db08fd2c24d07f9c9af1c
endif
ifeq ($(BOARD),kirkwood)
	LUCKY_ARCH:=armv5
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=cb76bd595f5daac0054c77deefdaa42b1719d19b172db08fd2c24d07f9c9af1c
endif
ifeq ($(ARCH),armv7)
	LUCKY_ARCH:=armv7
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=6c71700dc494462374397701c750239373c9ec81474c579908462637cc388fc1
endif
ifeq ($(ARCH),aarch64)
	LUCKY_ARCH:=arm64
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=198a85d8e93b4eb947690353db607fda06f174e4b51d8f0af633409f8d717763
endif
ifeq ($(ARCH),arm64)
	LUCKY_ARCH:=arm64
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=198a85d8e93b4eb947690353db607fda06f174e4b51d8f0af633409f8d717763
endif
ifeq ($(ARCH),armv8)
	LUCKY_ARCH:=arm64
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=198a85d8e93b4eb947690353db607fda06f174e4b51d8f0af633409f8d717763
endif
ifeq ($(ARCH),i386)
	LUCKY_ARCH:=i386
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=0e0fc6e74a79daee1ee580e65e97b533f874b2dd5a39ebbbfc7416530648cc64
endif
ifeq ($(ARCH),x86_64)
	LUCKY_ARCH:=x86_64
	LUCKY_SUPPORTED:=1
	LUCKY_HASH:=e27ee660008d795e3d8bb290cb56a983804cc3bca53eee08afcc78b48869e38b
endif

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=GDY666 <gdy666@foxmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=3626928d4a45ae606856b834614e45997b5da235
LUCKY_FILE:=$(PKG_NAME)_$(PKG_VERSION)_Linux_$(LUCKY_ARCH).tar.gz

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lucky dynamic domain name ddns-go service, socat,frp
	DEPENDS:=@(i386||x86_64||arm||aarch64||mipsel||mips)
	URL:=https://github.com/gdy666/lucky
endef

define Package/$(PKG_NAME)/description
  Main functions of Lucky: dynamic domain name ddns-go service, socat,reverse proxy ,wake on lan
endef

define Download/lucky
	URL:=https://github.com/gdy666/lucky/releases/download/v$(PKG_VERSION)
	FILE:=$(LUCKY_FILE)
	HASH:=$(LUCKY_HASH)
endef

define Build/Prepare
	[ "$(LUCKY_SUPPORTED)" = "1" ] || { echo "lucky: unsupported ARCH=$(ARCH) BOARD=$(BOARD)" >&2; false; }
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	tar -xzf $(DL_DIR)/$(LUCKY_FILE) -C $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lucky $(1)/usr/bin/lucky
endef

$(eval $(call Download,lucky))
$(eval $(call BuildPackage,$(PKG_NAME)))
