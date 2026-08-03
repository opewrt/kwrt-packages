# zPonds <admin@shinenet.cn>

include $(TOPDIR)/rules.mk

PKG_NAME:=nezha-agent
PKG_VERSION:=1.6.1
PKG_RELEASE:=23

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Nezha Agent is the client of the Nezha panel
	URL:=https://github.com/naiba/nezha/
endef


define Package/$(PKG_NAME)/description
Nezha Agent is the client of the Nezha panel
endef

# 禁止OpenWrt对二进制文件进行strip
STRIP:=true

ifeq ($(ARCH),i386)
	PKG_ARCH_NEZHA_AGENT:=386
	PKG_HASH:=b6543618cb42316990cfe4e3ca4a89870e3a742d7d391a44749bb1aabcc474a9
endif

ifeq ($(ARCH),x86_64)
	PKG_ARCH_NEZHA_AGENT:=amd64
	PKG_HASH:=f71e350cc807b5c42c46b66eecd2d474c4f5dc039a70364a86f85b2b4436a030
endif

ifeq ($(ARCH),mipsel)
	PKG_ARCH_NEZHA_AGENT:=mipsle
	PKG_HASH:=aa6d3a087f4077a83574cc772c5482a56368b30f18114960d25be96aa8c85c92
endif

ifeq ($(ARCH),mips)
	PKG_ARCH_NEZHA_AGENT:=mips
	PKG_HASH:=17d0133877cdc9a85d5afa433ac871142fbe676dc17dbe27da2dee388413a036
endif

ifeq ($(ARCH),arm)
	PKG_ARCH_NEZHA_AGENT:=arm
	PKG_HASH:=592008995d39aabfb3a313da86ffc4fecc4e2aea8ab0295006c8706d299c5f5b
endif

ifeq ($(ARCH),arm64)
	PKG_ARCH_NEZHA_AGENT:=arm64
	PKG_HASH:=56c34a84265e7e8ac769e99d7f886033a3bb4aedb4817b5ff041cac47c11d2fb
endif

ifeq ($(ARCH),aarch64)
	PKG_ARCH_NEZHA_AGENT:=arm64
	PKG_HASH:=56c34a84265e7e8ac769e99d7f886033a3bb4aedb4817b5ff041cac47c11d2fb
endif

PKG_SOURCE:=nezha-agent_linux_$(PKG_ARCH_NEZHA_AGENT).zip
PKG_SOURCE_URL:=https://github.com/nezhahq/agent/releases/download/v$(PKG_VERSION)/

TAR_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/$(PKG_NAME)-TAR

define Build/Prepare
	mkdir -vp $(TAR_DIR)
	unzip $(DL_DIR)/$(PKG_SOURCE) -d $(TAR_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(TAR_DIR)/nezha-agent $(1)/usr/bin/$(PKG_NAME)
	chmod 755 $(1)/usr/bin/$(PKG_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
