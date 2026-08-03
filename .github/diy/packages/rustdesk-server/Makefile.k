# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=rustdesk-server
PKG_VERSION:=1.1.13
PKG_RELEASE:=5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/rustdesk/rustdesk-server/tar.gz/$(PKG_VERSION)?
PKG_HASH:=10e4d014f339c13cd5958b8d49c454ddaeced3d77a382b700bfd7580dc9318a5

PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

HBB_COMMON_VERSION:=49c6b24a7a8c39d4448e07b743007ef1a3febd43
HBB_COMMON_FILE:=hbb_common-$(HBB_COMMON_VERSION).tar.gz

define Download/hbb_common
  FILE:=$(HBB_COMMON_FILE)
  URL:=https://codeload.github.com/rustdesk/hbb_common/tar.gz/$(HBB_COMMON_VERSION)?
  HASH:=ebd8d284a22bab98ae15b234c2b5a23fd9453582e3e6c83fa29da2196cf0a5a7
endef
$(eval $(call Download,hbb_common))

define Package/rustdesk-server
  SECTION:=net
  CATEGORY:=Network
  TITLE:=RustDesk Server Program
  DEPENDS:=@(aarch64||arm||x86_64) @(!arm||TARGET_bcm53xx||HAS_FPU)
  URL:=https://rustdesk.com/server
endef

define Package/rustdesk-server/description
  Self-host your own RustDesk server, it is free and open source.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(INSTALL_DIR) $(PKG_BUILD_DIR)/libs/hbb_common
	$(TAR) -xf $(DL_DIR)/$(HBB_COMMON_FILE) --strip-components=1 -C $(PKG_BUILD_DIR)/libs/hbb_common
endef

Build/Compile:=$(call Build/Compile/Cargo,,--locked)

$(eval $(call RustBinPackage,rustdesk-server))
$(eval $(call BuildPackage,rustdesk-server))
