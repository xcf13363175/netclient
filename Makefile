#
# Copyright (C) 2019 sbilly <superli_1980@hotmail.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=netclient
PKG_VERSION:=0.20.6
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/gravitl/netclient.git
PKG_SOURCE_VERSION:=41a4298d18a73f8b2a1151513f2022ec16ce8ee8
PKG_SOURCE_DATE:=20230815
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=AGPL-3.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=sbilly <superli_1980@hotmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/gravitl/netclient
GO_PKG_INSTALL_EXTRA:=extra/file extra/dir
GO_PKG_EXCLUDES:=gui
GO_PKG_LDFLAGS:=-s -w


include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/netclient
$(call Package/netclient/Default)
$(call GoPackage/GoSubMenu)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
endef

define Package/netclient/Default
  TITLE:=Netclient for OpenWRT
  URL:=https://github.com/gravitl/netclient
  DEPENDS:=$(GO_ARCH_DEPENDS)
  MAINTAINER:=sbilly <superli_1980@hotmail.com>
endef

define Package/netclient/Default/description
Netclient is a platform for creating and managing fast, secure, and 
dynamic virtual overlay networks using WireGuard. This project offers
OpenWRT packages for Netclient.
endef

define Package/netclient/description
$(call Package/netclient/Default/description)

This package contains the binaries.
endef

define Package/netclient/install
	$(INSTALL_DIR) $(1)/etc/netclient
	$(INSTALL_DIR) $(1)/etc/systemd/
	$(INSTALL_DIR) $(1)/etc/systemd/system
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/netclient $(1)/usr/bin/
	$(CP) ./root/* $(1)/
endef

define Package/netclient/postinst
#!/bin/sh
	#chmod +x ./etc/init.d/netclient
	#chmod +x ./etc/netclient
	chmod +x /etc/hotplug.d/iface/*
endef

$(eval $(call GoBinPackage,netclient))
$(eval $(call BuildPackage,netclient))
