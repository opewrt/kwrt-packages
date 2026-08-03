include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

ifeq ($(ARCH),arm)
  ifeq ($(CPU_TYPE),cortex-a9)
	PKG_ARCH_PGYYPN:=arm_cortex-a9-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=97d696b4ded904a708b8cf051528216772f7073348b11cdba2897d72e9cccdc0
	PKG_EXTRA_HASH:=a46cf1977a6b951b17f806943f6eac976cd11fb36969c3d3bccdf2ecb970123a
  else ifeq ($(CPU_SUBTYPE),neon-vfpv4)
	PKG_ARCH_PGYYPN:=arm_cortex-a7_neon-vfpv4-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=cffaaa3be7a8e5e9e0410b39d05e80841fba0234cd3b8217f0ef4b29d1f3da20
	PKG_EXTRA_HASH:=517e01d4733cf51dff3ef8d05aac632c93cf02ee91027e2a8b749f7e6a1d5ac1
  else
	PKG_ARCH_PGYYPN:=arm_cortex-a7-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=9cd12f3a3d1b7699339155742b495c4947317ad91be4051a24d03c1e0774896d
	PKG_EXTRA_HASH:=998ac88301ee68016684aaa51e279664eb762303b02ee94ed6545e213aafcc28
  endif
endif
ifeq ($(ARCH),aarch64)
  ifeq ($(CPU_TYPE),cortex-a53)
	PKG_ARCH_PGYYPN:=aarch64_cortex-a53-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=a693e8ab2f4f48a3de3ddac15c5f3431be956e0cb77abc3f9ae07dee013d9a04
	PKG_EXTRA_HASH:=8190927d85b9a2e50cffdf709778fe12ac71c0c527b8ea324c0bf5f55961d0dd
  else ifeq ($(CPU_TYPE),cortex-a72)
	PKG_ARCH_PGYYPN:=aarch64_cortex-a72-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=b638c22b16b974a7488dff88afc4f43d45ed5c693a2001a2dab900c7bae5f46e
	PKG_EXTRA_HASH:=e59852c443fc4a570652e6764a50468b725b0ebe275b6e68e260b646cc91461e
  else
	PKG_ARCH_PGYYPN:=aarch64_generic-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=2a4f3648f9d4b8720c2c9536a1dc2f80165e9c5a1f03ed73a1a59495aadd65f6
	PKG_EXTRA_HASH:=e59852c443fc4a570652e6764a50468b725b0ebe275b6e68e260b646cc91461e
  endif
endif
ifeq ($(ARCH),mips)
	PKG_ARCH_PGYYPN:=mips_24kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=dc420529026c32f879ff47b5937d193ef1cbc6b3befebd365aeebd6d5a4479c4
	PKG_EXTRA_HASH:=be6c2e478d7f534b2a1ba898792c1d2517be4b2abb3dcfede68c28532c8881fb
endif
ifeq ($(ARCH),mipsel)
  ifeq ($(CPU_TYPE),74kc)
	PKG_ARCH_PGYYPN:=mipsel_74kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=c7b434690d4031f5f83ab6a70d0ec0bf2c6bec64594dd145cb06bbb0a7edd76d
	PKG_EXTRA_HASH:=45e2665711c3e63e5cb3c8e426cd0e105c53fab74503c667143f829fd87108ad
  else
	PKG_ARCH_PGYYPN:=mipsel_24kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=d77ec93919ad4c88b7e9e165e6b87aa7eb567cc5b189506a9309d7ed9c27c67d
	PKG_EXTRA_HASH:=ed4820f5380225a5896ee59a4294a285155792387e66e6bce8c0c11738340c11
  endif
endif
ifeq ($(BOARD),x86)
  ifeq ($(ARCH),x86_64)
	PKG_ARCH_PGYYPN:=x86_64-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=584a356d578eca83419d38f6cf47862640faa0b418f01557ae7c86400b44894f
	PKG_EXTRA_HASH:=dbd9b89976fdbb6ed6f49687e7c98b09c64d9e5c443dd08d22d0e36a8dce472d
  else
	PKG_ARCH_PGYYPN:=i386_pentium-mmx-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=6d3879026dcae6d0fd8e81d6f7a3fb098f07fe8225704045082c921dc6316b87
	PKG_EXTRA_HASH:=b23b5cb7d1daff2fdf7cedaea1a9ad395719cf44908f39894d5af62dd0614f76
  endif
endif

PKG_NAME:=pgyvpn
PKG_VERSION:=3.1.0
PKG_RELEASE:=2

PKG_SOURCE:=pgyvpnsvr-$(PKG_ARCH_PGYYPN)
PKG_SOURCE_URL:=https://mirrors.oray.com/orayos/packages/$(PKG_NAME)/$(PKG_ARCH_PGYYPN)/$(PKG_VERSION)/bin
PKG_SOURCE_URL_FILE:=pgyvpnsvr
PKG_HASH:=$(PKG_PRIMARY_HASH)

PKG_MAINTAINER:=Oray <developer@oray.com>

include $(INCLUDE_DIR)/package.mk

define Package/pgyvpn
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  DEPENDS:=@(arm||aarch64||mips||mipsel||i386||x86_64) \
	+iptables +libc +libopenssl +librt \
	+libpthread +libstdcpp +kmod-tun
  TITLE:=PuGongYing VPN, Fast networking
  URL:=https://pgy.oray.com/
endef

define Package/pgyvpn/description
  PuGongYing VPN is a product of Oray Company, support custom network, account security
  system, traffic monitoring, cloud application access, virtual serial port, etc.
endef

define Download/extra
  FILE:=pgyvpn_oraysl-$(PKG_ARCH_PGYYPN)
  URL_FILE:=pgyvpn_oraysl
  URL:=$(PKG_SOURCE_URL)
  HASH:=$(PKG_EXTRA_HASH)
endef
$(eval $(call Download,extra))

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	mv $(DL_DIR)/pgyvpn_oraysl-$(PKG_ARCH_PGYYPN) $(PKG_BUILD_DIR)/pgyvpn_oraysl
	mv $(DL_DIR)/pgyvpnsvr-$(PKG_ARCH_PGYYPN) $(PKG_BUILD_DIR)/pgyvpnsvr
	chmod +x $(PKG_BUILD_DIR)/{pgyvpn_oraysl,pgyvpnsvr}
endef

define Build/Compile
	true
endef

define Package/pgyvpn/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/share/pgyvpn

	$(CP) $(PKG_BUILD_DIR)/pgyvpn_oraysl $(1)/usr/sbin
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d
	$(INSTALL_CONF) ./files/etc/config/* $(1)/etc/config
	$(INSTALL_BIN) ./files/etc/hotplug.d/iface/* $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) ./files/usr/share/pgyvpn/* $(1)/usr/share/pgyvpn
endef

define Package/pgyvpn/preinst
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] && {
		pidof pgyvpnsvr > /dev/null && \
			test -f $${PKG_ROOT}etc/init.d/pgyvpn && \
				/etc/init.d/pgyvpn stop; true
	}
	exit 0
endef

define Package/pgyvpn/postinst
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] && {
		/etc/init.d/pgyvpn restart; true
	}
	exit 0
endef

$(eval $(call BuildPackage,pgyvpn))
