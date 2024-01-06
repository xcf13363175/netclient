include $(TOPDIR)/rules.mk

PKG_NAME:=netbird
PKG_VERSION:=0.25.3
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/netbirdio/netbird.git
PKG_SOURCE_VERSION:=5469de53c521890bfde5fa6f6a29a915b2ee8f0e
PKG_SOURCE_DATE:=20240116
PKG_MIRROR_HASH:=skip

PKG_CONFIG_DEPENDS:=CONFIG_NETBIRD_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host upx/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/netbirdio/netbird
GO_PKG_BUILD_PKG:=github.com/netbirdio/netbird/client
GO_PKG_LDFLAGS:=-s -w
#GO_PKG_LDFLAGS_X:=github.com/netbirdio/netbird/version.version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)/config
config NETBIRD_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default n
endef

define Package/netbird
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Connect your devices into a single secure private WireGuard®-based mesh network
  URL:=https://github.com/netbirdio/netbird
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifneq ($(CONFIG_NETBIRD_COMPRESS_UPX),)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/client
endif
endef

define Package/netbird/conffiles
/etc/netbird/config.json
endef

define Package/netbird/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))

	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/client $(1)/usr/bin/netbird

	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/netbird.init $(1)/etc/init.d/netbird
endef

$(eval $(call GoBinPackage,netbird))
$(eval $(call BuildPackage,netbird))
