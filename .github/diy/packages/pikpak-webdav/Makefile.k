include $(TOPDIR)/rules.mk

PKG_NAME:=pikpak-webdav
PKG_VERSION:=0.0.3
PKG_RELEASE:=2

PKG_LICENSE:=MIT
PKG_MAINTAINER:=ykxVK8yL5L

PKG_LIBC:=musl
ifeq ($(ARCH),arm)
  PKG_LIBC:=musleabi

  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_LIBC:=musleabihf
  endif
endif

PKG_ARCH=$(ARCH)
ifeq ($(ARCH),i386)
  PKG_ARCH:=i686
endif

ifeq ($(ARCH),aarch64)
  PKG_ARCHIVE_HASH:=6e1db0bc7b0ddb0f2f19d7164ed4357492a9b6113c613be28547e18a62d8934b
  PKG_CHECKSUM_HASH:=dbe14cbfd5f339190178489ec1719b40080e780a1d7bf73f0698755780a31992
else ifeq ($(ARCH),arm)
  ifeq ($(PKG_LIBC),musleabihf)
    PKG_ARCHIVE_HASH:=64b26dedb0c7d8f77784aa14d37a4021ca72d7d429b52eb40f09d8210f76afb5
    PKG_CHECKSUM_HASH:=d2791a22eb6ad50518d771a04e5bcaf9c0959ab1e8ee2d2a23126da4271c0230
  else
    PKG_ARCHIVE_HASH:=a467d2f426970fb41efaff51b55f2e8beb3c5184be1104e9402beef19005042e
    PKG_CHECKSUM_HASH:=a4d8c4cdff4bdf6d259f430fa13d8a7647f85a1f0fe8e28383662967aa50fbd1
  endif
else ifeq ($(ARCH),i386)
  PKG_ARCHIVE_HASH:=47465cfd413155a854a99305ed0806b9e66db84ef95dafe85a6c2c42738e7ca3
  PKG_CHECKSUM_HASH:=6e4e95e4e8bfc35358898869c2414c865e35cd90959217df52368ec5c7680957
else ifeq ($(ARCH),mips)
  PKG_ARCHIVE_HASH:=3bd78806bdb185e042908511fca8738a0ac7d600376aabf2f7099aa2baa23e5d
  PKG_CHECKSUM_HASH:=76f70812756a5c3e55dcf937ce66faa87cdcc4317b1b2aedf9f5de5182cca7be
else ifeq ($(ARCH),mipsel)
  PKG_ARCHIVE_HASH:=d1eb62403d2bb49c6282c57054a9bcb1c2d824c6791db204e1e53ba36c788466
  PKG_CHECKSUM_HASH:=bad34a26b18de46a06f510610ff823da0a7dd2eb2954f66796ff75c4ad06ceaa
else ifeq ($(ARCH),x86_64)
  PKG_ARCHIVE_HASH:=57242fc7134926409576f08a788c0c8d9743613bd848f7cf4a8043120f88e90e
  PKG_CHECKSUM_HASH:=af3d6107924b67487a6c19f4f81dc6d9458130db09c65c0253987d44d53ed224
endif

PKG_SOURCE:=pikpak-webdav-v$(PKG_VERSION).$(PKG_ARCH)-unknown-linux-$(PKG_LIBC).tar.gz
PKG_SOURCE_URL:=https://github.com/ykxVK8yL5L/pikpak-webdav/releases/download/v$(PKG_VERSION)/
PKG_HASH:=$(PKG_ARCHIVE_HASH)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=multimedia
	CATEGORY:=Multimedia
	TITLE:=WebDAV server for Pikpak
	URL:=https://github.com/ykxVK8yL5L/pikpak-webdav
endef

define Package/$(PKG_NAME)/description
WebDAV server for Pikpak.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/pikpak-webdav
endef

define Download/sha256sum
	FILE:=$(PKG_SOURCE).sha256
	URL_FILE:=$(FILE)
	URL:=$(PKG_SOURCE_URL)
	HASH:=$(PKG_CHECKSUM_HASH)
endef
$(eval $(call Download,sha256sum))

define Build/Prepare
	mv $(DL_DIR)/$(PKG_SOURCE).sha256 .
	cp $(DL_DIR)/$(PKG_SOURCE) .
	shasum -a 256 -c $(PKG_SOURCE).sha256
	rm $(PKG_SOURCE).sha256 $(PKG_SOURCE)

	tar -C $(PKG_BUILD_DIR)/ -zxf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile
	echo "$(PKG_NAME) using precompiled binary."
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pikpak-webdav $(1)/usr/bin/pikpak-webdav
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/pikpak-webdav.init $(1)/etc/init.d/pikpak-webdav
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/pikpak-webdav.config $(1)/etc/config/pikpak-webdav
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
