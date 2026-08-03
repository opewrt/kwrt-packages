#
# Copyright (C) 2017-2024
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=CloudDrive2
PKG_VERSION:=0.7.21
PKG_RELEASE=1

STRIP:=true

ifeq ($(ARCH),x86_64)
	PKG_ARCH:=x86_64
	PKG_HASH:=53cb61edc100143060f8257a0c45f4627a9a336f8d24d2a6c80fc846d9d6112a
endif

ifeq ($(ARCH),arm64)
	PKG_ARCH:=aarch64
	PKG_HASH:=2da0153b8a74b127ec1a614f4b3972d47ce8fade2863a9a06937671eb86ed2f2
endif

ifeq ($(ARCH),aarch64)
	PKG_ARCH:=aarch64
	PKG_HASH:=2da0153b8a74b127ec1a614f4b3972d47ce8fade2863a9a06937671eb86ed2f2
endif

ifeq ($(ARCH),arm)
	PKG_ARCH:=armv7
	PKG_HASH:=f7a9e9dbf630dff4957a0cd0d8a219a6a976bc9eeac39a0db13c1aa8af19d8c1
endif

include $(INCLUDE_DIR)/package.mk

define Package/clouddrive2
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=@(arm||aarch64||x86_64) +fuse-utils +fuse3-utils
  TITLE:=CloudDrive2
endef

define Package/clouddrive2/description
  CloudDrive2 is a cloud storage mounting tool for OpenWrt.
endef

define Download/clouddrive2
  URL:=https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v$(PKG_VERSION)
  URL_FILE:=clouddrive-2-linux-$(PKG_ARCH)-$(PKG_VERSION).tgz
  FILE:=clouddrive-2-linux-$(PKG_ARCH)-$(PKG_VERSION).tgz
  HASH:=$(PKG_HASH)
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	tar -xzvf $(DL_DIR)/clouddrive-2-linux-$(PKG_ARCH)-$(PKG_VERSION).tgz -C $(PKG_BUILD_DIR)/ --strip-components=1
endef

define Build/Compile
endef

define Package/clouddrive2/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/clouddrive2.init $(1)/etc/init.d/clouddrive2
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/clouddrive2.config $(1)/etc/config/clouddrive2
	$(INSTALL_DIR) $(1)/usr/share/clouddrive2
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/clouddrive-2-linux-$(PKG_ARCH)-$(PKG_VERSION)/clouddrive $(1)/usr/share/clouddrive2/
	cp -rf $(PKG_BUILD_DIR)/clouddrive-2-linux-$(PKG_ARCH)-$(PKG_VERSION)/wwwroot $(1)/usr/share/clouddrive2/
endef

$(eval $(call Download,clouddrive2))
$(eval $(call BuildPackage,clouddrive2))
