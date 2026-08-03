include $(TOPDIR)/rules.mk

PKG_NAME:=homebox
PKG_VERSION:=0.0.0-dev.2020062901
PKG_RELEASE:=4

PKG_SOURCE_URL_FILE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/XGHeaven/homebox/archive/refs/tags/
PKG_HASH:=815a2a0fc5458245769648ef5b394f69fdec2573a1403b789146be0c4217a443

HOMEBOX_BINARY_SOURCE:=homebox-server-linux-amd64-$(PKG_VERSION).tar.gz
define Download/homebox-binary
  URL:=https://github.com/XGHeaven/homebox/releases/download/v$(PKG_VERSION)
  URL_FILE:=server-linux-amd64.tar.gz
  FILE:=$(HOMEBOX_BINARY_SOURCE)
  HASH:=5362b79947870d6771daf5a769985712c3e7a32ad9d09f9b7cc6e650e628b5a7
endef

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=A Toolbox for Home Local Networks
  URL:=https://github.com/XGHeaven/homebox
  DEPENDS:=@TARGET_x86_64
  MENU:=1
endef

define Package/$(PKG_NAME)/description
  A Toolbox for Home Local Networks Speed Test
endef

TAR_OPTIONS:=--strip-components 1 $(TAR_OPTIONS)
TAR_CMD=$(HOST_TAR) -C $(1) $(TAR_OPTIONS)

define Build/Prepare
	$(call Build/Prepare/Default)
	$(INSTALL_DIR) $(PKG_BUILD_DIR)/build
	$(TAR) -xzf $(DL_DIR)/$(HOMEBOX_BINARY_SOURCE) -C $(PKG_BUILD_DIR)/build
	mv $(PKG_BUILD_DIR)/build/server-linux-amd64 $(PKG_BUILD_DIR)/build/server
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/config $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/server $(1)/usr/bin/homebox
	$(INSTALL_CONF) ./files/homebox.config $(1)/etc/config/homebox
	$(INSTALL_BIN) ./files/homebox.init $(1)/etc/init.d/homebox
	$(INSTALL_BIN) ./files/homebox.uci-default $(1)/etc/uci-defaults/homebox
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/homebox
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/uci-defaults/homebox ] && /etc/uci-defaults/homebox && rm -f /etc/uci-defaults/homebox
	exit 0
fi
endef

$(eval $(call Download,homebox-binary))
$(eval $(call BuildPackage,homebox))
