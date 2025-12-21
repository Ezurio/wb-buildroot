################################################################################
#
# imx-gpu-mali
#
################################################################################

IMX_GPU_MALI_VERSION = r54p1.2
IMX_GPU_MALI_REVISION = 1fd73cb
IMX_GPU_MALI_SITE = $(FREESCALE_IMX_SITE)
IMX_GPU_MALI_SOURCE = mali-imx-$(IMX_GPU_MALI_VERSION)-$(IMX_GPU_MALI_REVISION).bin
IMX_GPU_MALI_LICENSE = NXP Semiconductor Software License Agreement
IMX_GPU_MALI_LICENSE_FILES = EULA COPYING
IMX_GPU_MALI_PROVIDES = libegl libgles libgbm

define IMX_GPU_MALI_EXTRACT_CMDS
	$(call NXP_EXTRACT_HELPER,$(IMX_GPU_MALI_DL_DIR)/$(IMX_GPU_MALI_SOURCE))
endef

define IMX_GPU_MALI_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib $(STAGING_DIR)/usr/include
	cp -fr $(@D)/usr/lib/*.so* $(STAGING_DIR)/usr/lib
	cp -fr $(@D)/usr/include/* $(STAGING_DIR)/usr/include
endef

define IMX_GPU_MALI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib $(TARGET_DIR)/usr/bin $(TARGET_DIR)/etc
	cp -fr $(@D)/usr/lib/* $(TARGET_DIR)/usr/lib
	cp -fr $(@D)/usr/bin/* $(TARGET_DIR)/usr/bin
	cp -fr $(@D)/etc/* $(TARGET_DIR)/etc
endef

$(eval $(generic-package))
