include $(TOPDIR)/rules.mk

PKG_NAME:=easytier
PKG_VERSION:=2.1.2

APP_SUPPORTED:=0

ifeq ($(ARCH),mipsel)
	APP_ARCH:=mipsel
	APP_SUPPORTED:=1
	APP_HASH:=40ff4e5ee54f3e11966e465d7520178f8af81e1215719282a27b427b8f1c24ea
endif
ifeq ($(ARCH),mips)
	APP_ARCH:=mips
	APP_SUPPORTED:=1
	APP_HASH:=8250f43a99129136b4a40035e7ea4f4d6403bfbcdd39d0d9d48840a9c2f7c1bf
endif
ifeq ($(ARCH),arm)
	APP_ARCH:=arm
	APP_SUPPORTED:=1
	APP_HASH:=6edf061fdabe675b17d9d880327f05256f43be3ea5d70f10438fd7e82aa715bc
endif
ifeq ($(BOARD),kirkwood)
	APP_ARCH:=arm
	APP_SUPPORTED:=1
	APP_HASH:=6edf061fdabe675b17d9d880327f05256f43be3ea5d70f10438fd7e82aa715bc
endif
ifeq ($(ARCH),armv7)
	APP_ARCH:=armv7
	APP_SUPPORTED:=1
	APP_HASH:=45781bc72036680bd65245e43827bed848b8e84e303fb635338dc1b56d3a7867
endif
ifeq ($(ARCH),aarch64)
	APP_ARCH:=aarch64
	APP_SUPPORTED:=1
	APP_HASH:=5e12bd29f387762a6a1c0ad5a39cb4ba9ee90f51905db4cc35886d649b1956e7
endif
ifeq ($(ARCH),arm64)
	APP_ARCH:=aarch64
	APP_SUPPORTED:=1
	APP_HASH:=5e12bd29f387762a6a1c0ad5a39cb4ba9ee90f51905db4cc35886d649b1956e7
endif
ifeq ($(ARCH),armv8)
	APP_ARCH:=aarch64
	APP_SUPPORTED:=1
	APP_HASH:=5e12bd29f387762a6a1c0ad5a39cb4ba9ee90f51905db4cc35886d649b1956e7
endif
ifeq ($(ARCH),x86_64)
	APP_ARCH:=x86_64
	APP_SUPPORTED:=1
	APP_HASH:=3b481daef9b4ca59e4a6ef998853bc00a6cb344b9df919dba48691b90dc894d4
endif

APP_FILE:=$(PKG_NAME)-linux-$(APP_ARCH)-v$(PKG_VERSION).zip
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A simple, decentralized mesh VPN with WireGuard support.
	DEPENDS:=@(x86_64||arm||aarch64||mipsel||mips) +kmod-tun
	URL:=https://github.com/EasyTier/EasyTier
endef

define Package/$(PKG_NAME)/description
  A simple, decentralized mesh VPN with WireGuard support.
endef

define Download/easytier
	URL:=https://github.com/EasyTier/EasyTier/releases/download/v$(PKG_VERSION)
	FILE:=$(APP_FILE)
	HASH:=$(APP_HASH)
endef

define Build/Prepare
	[ "$(APP_SUPPORTED)" = "1" ] || { echo "easytier: unsupported ARCH=$(ARCH) BOARD=$(BOARD)" >&2; false; }
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	unzip -j $(DL_DIR)/$(APP_FILE) -d $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/easytier-core $(1)/usr/bin/easytier-core
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/easytier-cli $(1)/usr/bin/easytier-cli
	[ "$(APP_ARCH)" != "mips" ] && [ "$(APP_ARCH)" != "mipsel" ] && $(INSTALL_BIN) $(PKG_BUILD_DIR)/easytier-web $(1)/usr/bin/easytier-web || true
endef

$(eval $(call Download,easytier))
$(eval $(call BuildPackage,$(PKG_NAME)))
