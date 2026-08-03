include $(TOPDIR)/rules.mk

PKG_NAME:=aliyundrive-webdav
PKG_VERSION:=2.3.3
PKG_RELEASE:=2

PKG_LICENSE:=MIT
PKG_MAINTAINER:=messense <messense@icloud.com>

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
  PKG_HASH:=10abbe819b02b538aa9c65c5bad07be04209bdf507f3b1a40525b58b015f9e53
  PKG_SHA256_HASH:=61516fd0abdab4f0c54b519f8093121ff838982a4bcb0beccf7f3b5dad475ae8
else ifeq ($(ARCH),arm)
  ifeq ($(PKG_LIBC),musleabihf)
    PKG_HASH:=b5f97e5af0a640208db1fcf1f0c8d9f9621638ae47b433b1b1388f9bcd8dbfdc
    PKG_SHA256_HASH:=0dee2f4ebddd286deb34a772abf70782a4a650f02c466e997df5a1af3f97ee21
  else
    PKG_HASH:=f7e01a7ed2f75e7d7172ff11596e6305d4ea57bde98843f00e4e02e50ab75fab
    PKG_SHA256_HASH:=23125cd9bd6b2b997e73e29c3031c4309164c2aade9b8097cea9b216899b0d4f
  endif
else ifeq ($(ARCH),i386)
  PKG_HASH:=fd36a7f00cebc9ef4ce2369420536db6e871998030950841db3975682a14be96
  PKG_SHA256_HASH:=aa4163f09eed6d33328f3d6d2f4c6b0332bde38a7e0ea7035909007ca4d6591d
else ifeq ($(ARCH),mips)
  PKG_HASH:=9c1c9c90848c3a44ebf590efaaf31c05b47c02cceefd4505e970b69ed2b9e201
  PKG_SHA256_HASH:=3f73dea61bc381afb0a3eca853bb41d7d864dbd885db321c27bc6e29fed0150d
else ifeq ($(ARCH),mipsel)
  PKG_HASH:=148e3c643c0d13fea135eccb0842fc6fcd7eedbceb11ff46bbadd672c1afdcfb
  PKG_SHA256_HASH:=041069429c7d31fd640e1096c5900e033c041b55930954d1641675614745f355
else
  PKG_HASH:=768122795280e54a818d74d47c6ae71ba8584f0d0c41193bf1d959cf5d3b6cb8
  PKG_SHA256_HASH:=6e1d58886af23ea9339f56c926ba63cd9fa32ad08b160124c1fb4ae1ec371fe3
endif

PKG_SOURCE:=aliyundrive-webdav-v$(PKG_VERSION).$(PKG_ARCH)-unknown-linux-$(PKG_LIBC).tar.gz
PKG_SOURCE_URL:=https://github.com/messense/aliyundrive-webdav/releases/download/v$(PKG_VERSION)/

include $(INCLUDE_DIR)/package.mk

define Package/aliyundrive-webdav
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=WebDAV server for AliyunDrive
  URL:=https://github.com/messense/aliyundrive-webdav
endef

define Package/aliyundrive-webdav/description
  WebDAV server for AliyunDrive.
endef

define Package/aliyundrive-webdav/conffiles
/etc/config/aliyundrive-webdav
endef

define Download/sha256sum
	FILE:=$(PKG_SOURCE).sha256
	URL_FILE:=$(FILE)
	URL:=$(PKG_SOURCE_URL)
	HASH:=$(PKG_SHA256_HASH)
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
	echo "aliyundrive-webdav using precompiled binary."
endef

define Package/aliyundrive-webdav/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/aliyundrive-webdav $(1)/usr/bin/aliyundrive-webdav
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/aliyundrive-webdav.init $(1)/etc/init.d/aliyundrive-webdav
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/aliyundrive-webdav.config $(1)/etc/config/aliyundrive-webdav
endef

$(eval $(call BuildPackage,aliyundrive-webdav))
