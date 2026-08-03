include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

ifeq ($(ARCH),arm)
  ifeq ($(CPU_TYPE),cortex-a9)
	PKG_ARCH_PHT:=arm_cortex-a9-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=e1cf84fe6d803b83dfb45d40160c12f2fb97a4dc67f69c4ec7d9a5018e323525
  else ifeq ($(CPU_SUBTYPE),neon-vfpv4)
	PKG_ARCH_PHT:=arm_cortex-a7_neon-vfpv4-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=828bcaadeb0e6333defa96b2858fd4194a0a9992d929f07dcdfd4c90deda8db5
  else
	PKG_ARCH_PHT:=arm_cortex-a7-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=0b72d3c46919d29f71eb8b54a2442868ce993f809d60340d8c1751f8833e5737
  endif
endif
ifeq ($(ARCH),aarch64)
  ifeq ($(CPU_TYPE),cortex-a53)
	PKG_ARCH_PHT:=aarch64_cortex-a53-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=a3d8c5e48ea9d5c2a2906dba01769a34403d5088de9e2b561c42313216f6d4f5
  else ifeq ($(CPU_TYPE),cortex-a72)
	PKG_ARCH_PHT:=aarch64_cortex-a72-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=4e543fa2ae95b384adffcb6086b0e30d673efe7eb14cb01e9a6bcf85164ab733
  else
	PKG_ARCH_PHT:=aarch64_generic-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=4e543fa2ae95b384adffcb6086b0e30d673efe7eb14cb01e9a6bcf85164ab733
  endif
endif
ifeq ($(ARCH),mips)
	PKG_ARCH_PHT:=mips_24kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=78883aa10d56b6bb91291782e14f956e15f3efb8ae2039c79d730238a93e733f
endif
ifeq ($(ARCH),mipsel)
  ifeq ($(CPU_TYPE),74kc)
	PKG_ARCH_PHT:=mipsel_74kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=e84a9fdbac1e786f49c8f2d3c505a1f608f6c86bc059fb0948a0d04d019c683e
  else
	PKG_ARCH_PHT:=mipsel_24kc-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=9d224f3ee8f22fe642bc23d1863b06b62e807a3dc682a43f08c8b1db3633674d
  endif
endif
ifeq ($(BOARD),x86)
  ifeq ($(ARCH),x86_64)
	PKG_ARCH_PHT:=x86_64-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=85a03a2f43bcb01f0017b39694a23bae567fbfe3dee1e523c77e62e37d586cfa
  else ifeq ($(CPU_TYPE),pentium4)
	PKG_ARCH_PHT:=i386_pentium4-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=0200f8512b394b6f7e40e40579a3d624a6a3f24a74f3cc7e2b202a35634b0ea1
  else
	PKG_ARCH_PHT:=i386_pentium-mmx-$(LIBC)-unknown
	PKG_PRIMARY_HASH:=709cf1c2185964bd2c9f7198322d48eb7e4748044cbc84dbb210959f121f1048
  endif
endif

PKG_NAME:=phtunnel
PKG_VERSION:=1.0.0
PKG_RELEASE:=2

PKG_SOURCE:=phtunnel-$(PKG_ARCH_PHT)
PKG_SOURCE_URL:=https://mirrors.oray.com/orayos/packages/$(PKG_NAME)/$(PKG_ARCH_PHT)/$(PKG_VERSION)/bin
PKG_SOURCE_URL_FILE:=phtunnel
PKG_HASH:=$(PKG_PRIMARY_HASH)

PKG_MAINTAINER:=Oray <developer@oray.com>

include $(INCLUDE_DIR)/package.mk

define Package/phtunnel
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  DEPENDS:=@(arm||aarch64||mips||mipsel||i386||x86_64) \
	+libc +libpthread +librt
  TITLE:=HSK Intranet penetration
  URL:=https://hsk.oray.com/
endef

define Package/phtunnel/description
  PHTunnel is the core component of HSK intranet penetration, which can easily implement high-performance
  reverse proxy applications, supports TCP, HTTP, HTTPS protocols, end-to-end TLS encrypted communication,
  black and white list anti-black verification, etc. Through PHTunnel, external network devices can easily
  penetrate various complex routes and firewalls to access devices on the internal network.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	mv $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)/phtunnel
	chmod +x $(PKG_BUILD_DIR)/phtunnel
endef

define Build/Compile
	true
endef

define Package/phtunnel/conffiles
/etc/phtunnel.json
endef

define Package/phtunnel/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DIR) $(1)/usr/sbin

	$(CP) $(PKG_BUILD_DIR)/phtunnel $(1)/usr/sbin
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d
	$(INSTALL_CONF) ./files/etc/config/* $(1)/etc/config
	$(INSTALL_BIN) ./files/etc/hotplug.d/iface/* $(1)/etc/hotplug.d/iface
endef

define Package/phtunnel/preinst
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] && {
		pidof phtunnel > /dev/null && \
			test -f $${PKG_ROOT}etc/init.d/phtunnel && \
				/etc/init.d/phtunnel stop; true
	}
	exit 0
endef

$(eval $(call BuildPackage,phtunnel))
