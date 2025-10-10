################################################################################
#
# optee-client
#
################################################################################

OPTEE_CLIENT_VERSION = $(call qstrip,$(BR2_PACKAGE_OPTEE_CLIENT_VERSION))
OPTEE_CLIENT_LICENSE = BSD-2-Clause
OPTEE_CLIENT_LICENSE_FILES = LICENSE
OPTEE_CLIENT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL),y)
OPTEE_CLIENT_TARBALL = $(call qstrip,$(BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL_LOCATION))
OPTEE_CLIENT_SITE = $(patsubst %/,%,$(dir $(OPTEE_CLIENT_TARBALL)))
OPTEE_CLIENT_SOURCE = $(notdir $(OPTEE_CLIENT_TARBALL))
else
OPTEE_CLIENT_SITE = $(call github,OP-TEE,optee_client,$(OPTEE_CLIENT_VERSION))
endif

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT):$(BR2_PACKAGE_OPTEE_CLIENT_LATEST),y:)
BR_NO_CHECK_HASH_FOR += $(OPTEE_CLIENT_SOURCE)
endif

OPTEE_CLIENT_CONF_OPTS = \
	-DCFG_TEE_FS_PARENT_PATH=$(BR2_PACKAGE_OPTEE_CLIENT_TEE_FS_PATH) \
	-DCFG_WERROR=OFF

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT_RPMB_EMU),y)
OPTEE_CLIENT_CONF_OPTS += -DRPMB_EMU=ON
else
OPTEE_CLIENT_CONF_OPTS += -DRPMB_EMU=OFF
endif

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT_SUPP_PLUGINS),y)
OPTEE_CLIENT_CONF_OPTS += -DCFG_TEE_SUPP_PLUGINS=ON
else
OPTEE_CLIENT_CONF_OPTS += -DCFG_TEE_SUPP_PLUGINS=OFF
endif

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT_TEEACL),y)
OPTEE_CLIENT_DEPENDENCIES += host-pkgconf util-linux
OPTEE_CLIENT_CONF_OPTS += -DWITH_TEEACL=ON
else
OPTEE_CLIENT_CONF_OPTS += -DWITH_TEEACL=OFF
endif

define OPTEE_CLIENT_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(OPTEE_CLIENT_PKGDIR)/S30tee-supplicant \
		$(TARGET_DIR)/etc/init.d/S30tee-supplicant
endef

define OPTEE_CLIENT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D $(@D)/tee-supplicant/tee-supplicant@.service \
		$(TARGET_DIR)/usr/lib/systemd/system/tee-supplicant@.service
	$(INSTALL) -m 0644 -D $(@D)/tee-supplicant/optee-udev.rules \
		$(TARGET_DIR)/etc/udev/rules.d/99-optee-udev.rules
	$(INSTALL) -m 0700 -d $(TARGET_DIR)/var/lib/tee
endef

define OPTEE_CLIENT_USERS
	- - teepriv -1 * - - - -
	- - tee -1 * - - - -
	teesuppl -1 teesuppl -1 * /var/lib/tee /sbin/nologin teepriv -
endef

ifeq ($(BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL)$(BR_BUILDING),yy)
ifeq ($(call qstrip,$(BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL_LOCATION)),)
$(error No tarball location specified. Please check BR2_PACKAGE_OPTEE_CLIENT_CUSTOM_TARBALL_LOCATION)
endif
endif

$(eval $(cmake-package))
