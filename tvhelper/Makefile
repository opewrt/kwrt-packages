include $(TOPDIR)/rules.mk

PKG_NAME:=tvhelper
PKG_VERSION:=2.0.5
PKG_RELEASE:=3

PKG_SOURCE:=tv.sh
PKG_SOURCE_URL:=https://raw.githubusercontent.com/wukongdaily/tvhelper/4b83f0becd957b02c4c92bb83f717366dc0b632b/shells/
PKG_HASH:=96f2f71e49ba3bc072966d135fff15da43e5f1f9ec736cd98b43ad185679dda6

include $(INCLUDE_DIR)/package.mk

define Package/tvhelper
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=TV Helper
  DEPENDS:=+bash
endef

define Package/tvhelper/description
  tv.sh script from @wukongdaily.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tvhelper/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tv.sh $(1)/usr/bin/tv.sh
	$(INSTALL_DIR) $(1)/root
	ln -sf /usr/bin/tv.sh $(1)/root/tv.sh
endef

$(eval $(call BuildPackage,tvhelper))
