################################################################################
#
# imx-oei
#
################################################################################

IMX_SM_VERSION = 2026q2
IMX_SM_SITE = $(call github,nxp-imx,imx-sm,rel_imx_sm_$(IMX_SM_VERSION))
IMX_SM_LICENSE = BSD-3-Clause
IMX_SM_LICENSE_FILES = LICENSE.txt

IMX_SM_DEPENDENCIES = host-arm-gnu-toolchain
IMX_SM_CONFIG = $(call qstrip,$(BR2_PACKAGE_IMX_SM_CONFIG))

IMX_SM_MAKE_ENV = \
	SM_CROSS_COMPILE=$(HOST_DIR)/bin/arm-none-eabi- \
	config=$(IMX_SM_CONFIG) \
	all

define IMX_SM_BUILD_CMDS
	$(MAKE) -C $(@D) $(IMX_SM_MAKE_ENV)
endef

define IMX_SM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(@D)/build/$(IMX_SM_CONFIG)/m33_image.bin
endef

$(eval $(generic-package))
