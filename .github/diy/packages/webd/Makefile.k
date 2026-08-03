# Copyright (C) 2020-2022 Hyy2001X <https://github.com/Hyy2001X>
# See more information at https://webd.cf/

include $(TOPDIR)/rules.mk

PKG_NAME:=webd
PKG_VERSION:=20240223
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A Lightweight self-hosted netdisk application
	DEPENDS:=@(arm||x86_64||mipsel||mips||aarch64)
	URL:=https://webd.cf
endef

ifeq ($(ARCH),x86_64)
	TARGET_ARCH:=x86_64
	TARGET_BOARD:=musl
	PKG_HASH:=c087f79a80370b4758a59f0a411e2f5f38e9b6a86c4a8987edbca990ab649775
endif

ifeq ($(ARCH),mipsel)
	TARGET_ARCH:=mipsel
	ifeq ($(BOARD),bcm47xx)
		TARGET_BOARD:=musl.brcm47xx-mips74k
		PKG_HASH:=87ad7dd1870cdddc139712f2a0ba765a072d417f02eace8e36f54e7f8665f2a0
	endif
	ifeq ($(BOARD),ramips)
		TARGET_BOARD:=musl.ramips-mt7620
		PKG_HASH:=017c5259eacf406c6479ca19a2aa5307411079cead3659f76fc882aca9ed2b2a
	endif
endif

ifeq ($(ARCH),mips)
	TARGET_ARCH:=mips
	ifeq ($(BOARD),ath79)
		TARGET_BOARD:=musl.ath79
	endif
	ifeq ($(BOARD),bcm63xx)
		TARGET_BOARD:=uclibc.brcm63xx
		PKG_HASH:=88c9b3f68df404a78b87ecb9d73df3c0d17002cda657cffcbed116cd2976e71b
	endif
	ifeq ($(BOARD),ar71xx)
		TARGET_BOARD:=uclibc.ar71xx
		PKG_HASH:=35a7df182e6ed89cbfbc171916a632f1964ab82ef237265d602e0f8926fbec09
	endif
endif

ifeq ($(ARCH),arm)
	TARGET_ARCH:=arm
	ifeq ($(BOARD),ipq806x)
		TARGET_BOARD:=muslgnueabi.ipq806x
		PKG_HASH:=aa7e2f864c51e696711fcfe49b2fc68477af6db87e614b8e26eadd4f3ace33da
	endif
	ifeq ($(BOARD),ipq40xx)
		TARGET_BOARD:=muslgnueabi.ipq40xx
		PKG_HASH:=8b910184f1e0fe13646677d293b8b0b1959032e55ad9bac4dfea2057356115b7
	endif
	ifeq ($(BOARD),bcm53xx)
		TARGET_BOARD:=muslgnueabi.bcm53xx
		PKG_HASH:=86b03b015bc77477a3859cb87c71e29ded511994940bddfcdfc69d0091a1d066
	endif
	ifeq ($(BOARD),oxnas)
		TARGET_BOARD:=muslgnueabi.oxnas
		PKG_HASH:=269d7892011092e6c8f69dbc09f9ff9dba04182c64d4e6bd9d9f5511e77336d1
	endif
	ifeq ($(BOARD),kirkwood)
		TARGET_BOARD:=muslgnueabi.kirkwood
		PKG_HASH:=5a9824843cb531a4474c9c24d28bb6b325ebc98074968386b0438c52b9f58679
	endif
	ifeq ($(BOARD),mvebu)
		TARGET_BOARD:=muslgnueabi.mvebu-cortexa9
		PKG_HASH:=f941b4eed82a6df1a1e9da6adf3b20ee7bf7500443ee0fa4b521abf53ff3c1a1
	endif
endif

ifeq ($(ARCH),aarch64)
	TARGET_ARCH:=aarch64
	ifeq ($(BOARD),cortex-a53)
		TARGET_BOARD:=musl.brcm2708-bcm2710
		PKG_HASH:=96389049b1cebe62f4ade64da1bbc516cc627a10c4f8a5f14b1ec550b8935f0f
	endif
	ifeq ($(BOARD),rockchip)
		TARGET_BOARD:=musl.rockchip-armv8
		PKG_HASH:=2281d7be86eea54f527f049e68431d2a4382c7e412baa426b6982f04eccd9199
	endif
endif

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(TARGET_ARCH)-openwrt-linux-$(TARGET_BOARD).tar.gz
PKG_SOURCE_URL:=https://webd.cf/webd/webd_dl/$(PKG_VERSION)/

UNTAR_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

define Build/Prepare
	mkdir -p $(UNTAR_DIR)
	tar -zxvf $(DL_DIR)/$(PKG_SOURCE) -C $(UNTAR_DIR)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(UNTAR_DIR)/webd/webd $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/share/$(PKG_NAME)
	$(INSTALL_BIN) $(UNTAR_DIR)/webd/web/.player.htm $(1)/usr/share/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) $(UNTAR_DIR)/webd/webd.conf $(1)/etc/webd.conf.example
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
