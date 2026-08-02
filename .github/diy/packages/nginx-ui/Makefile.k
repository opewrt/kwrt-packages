include $(TOPDIR)/rules.mk

PKG_NAME:=nginx-ui
PKG_VERSION:=2.0.0-beta.42
PKG_RELEASE:=7

PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/0xJacky/nginx-ui/archive/refs/tags/
PKG_HASH:=5a03cfeb91e6acfd5332bef19cee9b665c21c3577c1f844c9245ec5a0b4ffbcf

PNPM_VERSION:=9.15.0
PNPM_FILE:=pnpm-$(PNPM_VERSION).tgz

PKG_BUILD_DEPENDS:=node/host golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Kiddin9

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/nginx-ui
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Web UI for Nginx
  URL:=https://nginxui.com
  DEPENDS:=+nginx-ssl
endef

define Package/nginx-ui/description
  Nginx UI is a web interface for Nginx configuration management
endef

define Package/nginx-ui/conffiles
/etc/nginx-ui/
/etc/config/nginx-ui
endef

define Download/pnpm
  URL:=https://registry.npmjs.org/pnpm/-
  URL_FILE:=pnpm-$(PNPM_VERSION).tgz
  FILE:=$(PNPM_FILE)
  HASH:=09a8fe31a34fda706354680619f4002f4ccef6dadff93240d24ef6c831f0fd28
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	mkdir -p $(PKG_BUILD_DIR)/.pnpm
	tar -xzf $(DL_DIR)/$(PNPM_FILE) -C $(PKG_BUILD_DIR)/.pnpm
endef

define Build/Compile
	cd $(PKG_BUILD_DIR)/app && \
		node ../.pnpm/package/bin/pnpm.cjs install --frozen-lockfile && \
		node ../.pnpm/package/bin/pnpm.cjs run build
	cd $(PKG_BUILD_DIR) && \
	export GOOS=linux && \
	export GOARCH=$(GO_ARCH) && \
	export CGO_ENABLED=1 && \
	$(GO_BIN_PATH) CC="$(TARGET_CC)" go build -mod=readonly -buildvcs=false -tags=jsoniter \
		-ldflags "-w --extldflags '-static' -X 'github.com/0xJacky/Nginx-UI/settings.buildTime=$(shell date +%s)'" \
		-o $(PKG_BUILD_DIR)/nginx-ui -v main.go
endef

define Package/nginx-ui/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nginx-ui $(1)/usr/bin/
	$(INSTALL_CONF) ./files/etc/config/nginx-ui $(1)/etc/config/
	$(INSTALL_BIN) ./files/etc/init.d/nginx-ui $(1)/etc/init.d/
endef

define Package/nginx-ui/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	# 确保目录存在
	mkdir -p /etc/nginx/sites-available
	mkdir -p /etc/nginx/sites-enabled
	mkdir -p /etc/nginx/streams-available
	mkdir -p /etc/nginx/streams-enabled

	ln -sf /etc/nginx/uci.conf /etc/nginx/nginx.conf

	grep -q sites-enabled files/etc/nginx/uci.conf.template || sed -i '/include conf\.d\/\*\.conf;/a 	include /etc/nginx/sites-enabled/*;' /etc/nginx/uci.conf.template;
	/etc/init.d/nginx restart

fi
exit 0
endef

$(eval $(call Download,pnpm))
$(eval $(call BuildPackage,nginx-ui))
