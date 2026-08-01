include $(TOPDIR)/rules.mk

PKG_NAME:=antiblock-openwrt-package
PKG_VERSION:=2.0.0
PKG_RELEASE:=18

ifeq ("$(wildcard ../antiblock)", "")
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/karen07/antiblock
PKG_SOURCE_VERSION:=86fd68b15888674e04720c4407e527a9a241ac82
PKG_MIRROR_HASH:=8686e4a4702a96676e4362bf2fd7873a1bbe12137d508131c878596511378db9
endif

PKG_MAINTAINER:=Khachatryan Karen <karen0734@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/antiblock-openwrt-package
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libcurl
  TITLE:=AntiBlock
  URL:=https://github.com/karen07/antiblock
endef

define Package/antiblock-openwrt-package/description
  AntiBlock program proxies DNS requests.
  The IP addresses of the specified domains are added to
  the routing table for routing through the specified interface.
endef

define Package/antiblock-openwrt-package/conffiles
/etc/config/antiblock
endef

ifneq ("$(wildcard ../antiblock)", "")
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ../antiblock/* $(PKG_BUILD_DIR)/
endef
endif

define Package/antiblock-openwrt-package/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/antiblock $(1)/usr/bin/antiblock

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/antiblock $(1)/etc/init.d/antiblock

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/antiblock $(1)/etc/config/antiblock
endef

$(eval $(call BuildPackage,antiblock-openwrt-package))
