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
IMX_GPU_MALI_INSTALL_STAGING = YES

define IMX_GPU_MALI_EXTRACT_CMDS
	$(call NXP_EXTRACT_HELPER,$(IMX_GPU_MALI_DL_DIR)/$(IMX_GPU_MALI_SOURCE))
endef

define IMX_GPU_MALI_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include $(STAGING_DIR)/usr/lib
	cp -fr -t $(STAGING_DIR)/usr/include $(@D)/usr/include/*
	cp -fr -t $(STAGING_DIR)/usr/lib \
		$(@D)/usr/lib/*.so* $(@D)/usr/lib/pkgconfig
endef

define IMX_GPU_MALI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc $(TARGET_DIR)/usr/lib $(TARGET_DIR)/usr/bin
	cp -fr -t $(TARGET_DIR)/etc $(@D)/etc/*
	cp -fr -t $(TARGET_DIR)/usr/lib \
		$(@D)/usr/lib/*.so.* $(@D)/usr/lib/libmali.so $(@D)/usr/lib/firmware
	cp -fr -t $(TARGET_DIR)/usr/bin $(@D)/usr/bin

	$(INSTALL) -D -m 644 -t $(TARGET_DIR)/usr/lib/udev/rules.d \
		$(IMX_GPU_MALI_PKGDIR)/51-mali.rules 
endef

$(eval $(generic-package))
