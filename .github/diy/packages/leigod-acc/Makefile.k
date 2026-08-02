#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=leigod-acc
PKG_VERSION:=1.3.0.30
PKG_RELEASE:=4

ACC_SUPPORTED:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Powerful Leigod Game Accelerater
	DEPENDS:=@(x86_64||arm||mipsel||aarch64)
	URL:=https://www.leigod.com/
endef

define Package/$(PKG_NAME)/description
leigod-acc is a powerful game accelerater
endef

ifeq ($(ARCH),x86_64)
	acc-arch:=amd64
	ACC_SUPPORTED:=1
	ACC_HASH:=c26e2cde79ef21991834a94232520d1e5ac2df88a6382cb436a61865a8d9c15e
endif

ifeq ($(ARCH),mipsel)
	acc-arch:=mipsle
	ACC_SUPPORTED:=1
	ACC_HASH:=ac35cf6e19fc5028ac1da9921456726a14e0726339e89fe3e14c01a713140e57
endif

ifeq ($(ARCH),arm)
	acc-arch:=arm
	ACC_SUPPORTED:=1
	ACC_HASH:=c904bb3f41910d50ae6e8abc1e2a0b73eed6d74fb5c3b55274b82e9d4662a426
endif

ifeq ($(ARCH),aarch64)
	acc-arch:=arm64
	ACC_SUPPORTED:=1
	ACC_HASH:=316a604645f4216276dc5642d5f638a005b342771fb436a3c63826d85c5b5c1b
endif

ACC_FILE:=acc-gw.linux.$(acc-arch)

define Download/leigod-acc
	URL:=http://119.3.40.126/router_plugin
	FILE:=$(ACC_FILE)
	HASH:=$(ACC_HASH)
endef

define Build/Prepare
	[ "$(ACC_SUPPORTED)" = "1" ] || { echo "leigod-acc: unsupported ARCH=$(ARCH)" >&2; false; }
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)/bin
	$(CP) $(DL_DIR)/$(ACC_FILE) $(PKG_BUILD_DIR)/bin/$(ACC_FILE)
	chmod +x $(PKG_BUILD_DIR)/bin/$(ACC_FILE)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin/leigod
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/$(ACC_FILE) $(1)/usr/sbin/leigod/$(ACC_FILE)
	$(INSTALL_BIN) ./files/leigod_uninstall.sh $(1)/usr/sbin/leigod/leigod_uninstall.sh
	$(INSTALL_BIN) ./files/plugin_common.sh $(1)/usr/sbin/leigod/plugin_common.sh
	$(INSTALL_BIN) ./files/leigod-helper.sh $(1)/usr/sbin/leigod/leigod-helper.sh
	$(INSTALL_BIN) ./files/update_plugin $(1)/usr/sbin/leigod/update_plugin
	$(INSTALL_DATA) ./files/version $(1)/usr/sbin/leigod/version
endef

$(eval $(call Download,leigod-acc))
$(eval $(call BuildPackage,$(PKG_NAME)))
