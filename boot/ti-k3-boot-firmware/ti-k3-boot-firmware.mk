################################################################################
#
# ti-k3-boot-firmware
#
################################################################################

TI_K3_BOOT_FIRMWARE_VERSION = 11.00.10
TI_K3_BOOT_FIRMWARE_SITE = https://git.ti.com/cgit/processor-firmware/ti-linux-firmware/snapshot
TI_K3_BOOT_FIRMWARE_SOURCE = ti-linux-firmware-$(TI_K3_BOOT_FIRMWARE_VERSION).tar.xz
TI_K3_BOOT_FIRMWARE_INSTALL_IMAGES = YES
TI_K3_BOOT_FIRMWARE_LICENSE = TI Proprietary
TI_K3_BOOT_FIRMWARE_LICENSE_FILES = LICENSE.ti

TI_K3_BOOT_FIRMWARE_CPU = $(call qstrip,$(BR2_TARGET_TI_K3_BOOT_FIRMWARE_CPU))

ifeq ($(BR2_TARGET_TI_K3_BOOT_FIRMWARE_VPU),y)
define TI_K3_BOOT_FIRMWARE_INSTALL_VPU_CMDS
	$(INSTALL) -D -m 0644 -t $(TARGET_DIR)/usr/lib/firmware/cnm \
		$(@D)/cnm/wave521c_k3_codec_fw.bin 
endef
endif

ifeq ($(BR2_TARGET_TI_K3_BOOT_FIRMWARE_MCU_DEMO),y)
ifeq ($(TI_K3_BOOT_FIRMWARE_CPU),am62xx)
define TI_K3_BOOT_FIRMWARE_INSTALL_MCU_DEMO_CMDS
	$(INSTALL) -D -m 0644 -t $(TARGET_DIR)/usr/lib/firmware \
		$(@D)/ti-ipc/am62xx/*
endef
else ifeq ($(TI_K3_BOOT_FIRMWARE_CPU),j722s)
define TI_K3_BOOT_FIRMWARE_INSTALL_MCU_DEMO_CMDS
	$(INSTALL) -D -m 0644 \
		$(@D)/ti-ipc/j722s/ipc_echo_test_mcu3_0_release_strip.xer5f \
		$(TARGET_DIR)/lib/firmware/j722s-main-r5f0_0-fw
	
	$(INSTALL) -D -m 0644 \
		$(@D)/ti-ipc/j722s/ipc_echo_test_mcu2_0_release_strip.xer5f \
		$(TARGET_DIR)/lib/firmware/j722s-mcu-r5f0_0-fw
endef
endif
endif

define TI_K3_BOOT_FIRMWARE_INSTALL_IMAGES_CMDS
	cp -dpfr $(@D)/ti-sysfw $(BINARIES_DIR)/
	cp -dpfr $(@D)/ti-dm $(BINARIES_DIR)/

	$(TI_K3_BOOT_FIRMWARE_INSTALL_VPU_CMDS)
	$(TI_K3_BOOT_FIRMWARE_INSTALL_MCU_DEMO_CMDS)
endef

$(eval $(generic-package))
