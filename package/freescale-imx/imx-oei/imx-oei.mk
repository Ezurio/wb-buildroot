################################################################################
#
# imx-oei
#
################################################################################

IMX_OEI_VERSION = 6.18.20-2.0.0
IMX_OEI_SITE = $(call github,nxp-imx,imx-oei,lf-$(IMX_OEI_VERSION))
IMX_OEI_LICENSE = BSD-3-Clause
IMX_OEI_LICENSE_FILES = LICENSE.txt

IMX_OEI_DEPENDENCIES = host-arm-gnu-toolchain
IMX_OEI_DDR_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_IMX_OEI_DDR_CONFIG_FILE))

IMX_OEI_MAKE_ARGS = \
	OEI_CROSS_COMPILE=$(HOST_DIR)/bin/arm-none-eabi- \
	board=$(BR2_PACKAGE_IMX_OEI_BOARD_ID) \
	DEBUG=1 \
	all

ifneq ($(IMX_OEI_DDR_CONFIG_FILE),)
IMX_OEI_MAKE_ARGS += DDR_CONFIG=$(basename $(notdir $(IMX_OEI_DDR_CONFIG_FILE)))
ifneq ($(dir $(IMX_OEI_DDR_CONFIG_FILE)),./)
define IMX_OEI_POST_EXTRACT_CMDS
	cp -ft $(@D)/boards/$(BR2_PACKAGE_IMX_OEI_BOARD_ID)/ddr \
	 	$(IMX_OEI_DDR_CONFIG_FILE) 
endef
IMX_OEI_POST_EXTRACT_HOOKS += IMX_OEI_POST_EXTRACT_CMDS
endif
endif

ifeq ($(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX95A0),y)
define IMX_OEI_BUILD_CMDS
	$(MAKE) -C $(@D) $(IMX_OEI_MAKE_ARGS) oei=ddr r=A0
	$(MAKE) -C $(@D) $(IMX_OEI_MAKE_ARGS) oei=tcm r=A0
endef
else ifeq ($(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX95B0),y)
define IMX_OEI_BUILD_CMDS
	$(MAKE) -C $(@D) $(IMX_OEI_MAKE_ARGS) oei=ddr r=B0
endef
endif

define IMX_OEI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(@D)/build/$(BR2_PACKAGE_IMX_OEI_BOARD_ID)/ddr/oei-m33-*.bin
endef

$(eval $(generic-package))
