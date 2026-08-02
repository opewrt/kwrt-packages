# Copyright (C) 2020-2022 Hyy2001X <https://github.com/Hyy2001X>

include $(TOPDIR)/rules.mk

PKG_NAME:=upx-static
PKG_VERSION:=3.96
PKG_RELEASE:=2

UPX_SUPPORTED:=0

ifeq ($(ARCH),x86_64)
	PKG_ARCH:=amd64
	UPX_SUPPORTED:=1
	UPX_HASH:=ac75f5172c1c530d1b5ce7215ca9e94586c07b675a26af3b97f8421b8b8d413d
endif
ifeq ($(ARCH),i386)
	PKG_ARCH:=i386
	UPX_SUPPORTED:=1
	UPX_HASH:=ef4ce4a2dea1bae801aa09e13eb0839884ec86515ab40d4a400eb5e63074a19d
endif
ifeq ($(ARCH),mipsel)
	PKG_ARCH:=mipsel
	UPX_SUPPORTED:=1
	UPX_HASH:=129cfec3f035a8476e9ed2972578012dfb8aabc1f4096caa14d8cdf14aabdff9
endif
ifeq ($(ARCH),mips)
	PKG_ARCH:=mips
	UPX_SUPPORTED:=1
	UPX_HASH:=d032c546e2d70b409ba21f61d3884f12ac82bf610050df2ebddf4db14a233bf1
endif
ifeq ($(ARCH),armeb)
	PKG_ARCH:=armeb
	UPX_SUPPORTED:=1
	UPX_HASH:=33a80affcbbef7a3268add163d63ce6a6102b1fce1a76995321f73c5448903bb
endif
ifeq ($(ARCH),arm)
	PKG_ARCH:=arm
	UPX_SUPPORTED:=1
	UPX_HASH:=7c568b9ef05a0a129f3f4da3c825ffa8968b1ec5a31f3ce21485a87c61748c96
endif
ifeq ($(ARCH),aarch64)
	PKG_ARCH:=arm64
	UPX_SUPPORTED:=1
	UPX_HASH:=a075eccc7fd84ed46dff50692e1869e42b1bd6fc25a81f651b9a13c1146476fc
endif
ifeq ($(ARCH),arm64)
	PKG_ARCH:=arm64
	UPX_SUPPORTED:=1
	UPX_HASH:=a075eccc7fd84ed46dff50692e1869e42b1bd6fc25a81f651b9a13c1146476fc
endif
ifeq ($(ARCH),powerpc)
	PKG_ARCH:=powerpc
	UPX_SUPPORTED:=1
	UPX_HASH:=5096b2b2ecfedd7aef8b3b108de4f6526a4d051336f1eedecccc90f90f1f5af7
endif
ifeq ($(ARCH),powerpc64)
	PKG_ARCH:=powerpc64le
	UPX_SUPPORTED:=1
	UPX_HASH:=df854565df1b37299d1b0f0eee2bdd6588bf98638f8be9fe3776d4e5dd89746f
endif

UPX_FILE:=upx-$(PKG_VERSION)-$(PKG_ARCH)_linux.tar.xz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SUBMENU:=Compression
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=UPX - The Ultimate Packer for eXecutables
	DEPENDS:=@(x86_64||i386||mipsel||mips||armeb||arm||aarch64||arm64||powerpc||powerpc64)
	URL:=https://upx.github.io
endef

define Package/$(PKG_NAME)/description
UPX - The Ultimate Packer for eXecutables
endef

define Download/upx-static
	URL:=https://github.com/upx/upx/releases/download/v$(PKG_VERSION)
	FILE:=$(UPX_FILE)
	HASH:=$(UPX_HASH)
endef

define Build/Prepare
	[ "$(UPX_SUPPORTED)" = "1" ] || { echo "upx-static: unsupported ARCH=$(ARCH)" >&2; false; }
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	tar -xJf $(DL_DIR)/$(UPX_FILE) -C $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/upx-$(PKG_VERSION)-$(PKG_ARCH)_linux/upx $(1)/bin/upx
endef

$(eval $(call Download,upx-static))
$(eval $(call BuildPackage,$(PKG_NAME)))
