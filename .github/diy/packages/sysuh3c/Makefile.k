include $(TOPDIR)/rules.mk

PKG_NAME:=sysuh3c
PKG_VERSION:=1.0
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/haswelliris/h3c.git
PKG_SOURCE_VERSION:=8a3e0b5a9a5d989e7d8b2105d09a394c3663e016
PKG_MIRROR_HASH:=41e069fd93cd5f4c0b3e1fd4d28576636be449d55673da9bde0df1075cff0f17

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

TARGET_CFLAGS += -ffunction-sections -fdata-sections -fcommon -flto
TARGET_LDFLAGS += -Wl,--gc-sections,--as-needed

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=H3C client
endef

define Build/Configure
	$(call Build/Configure/Default)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/h3c $(1)/usr/sbin/sysuh3c
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/sysuh3c.config $(1)/etc/config/sysuh3c
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/sysuh3c.init $(1)/etc/init.d/sysuh3c
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DATA) ./files/sysuh3c.defaults $(1)/etc/uci-defaults/sysuh3c
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
