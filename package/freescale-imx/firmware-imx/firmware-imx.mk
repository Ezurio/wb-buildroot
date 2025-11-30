################################################################################
#
# firmware-imx
#
################################################################################

FIRMWARE_IMX_VERSION = 8.29
FIRMWARE_IMX_REVISION = 8741a3b
FIRMWARE_IMX_SITE = $(FREESCALE_IMX_SITE)
FIRMWARE_IMX_SOURCE = firmware-imx-$(FIRMWARE_IMX_VERSION)-$(FIRMWARE_IMX_REVISION).bin

FIRMWARE_IMX_LICENSE = NXP Semiconductor Software License Agreement
FIRMWARE_IMX_LICENSE_FILES = EULA COPYING SCR.txt
FIRMWARE_IMX_REDISTRIBUTE = NO

FIRMWARE_IMX_INSTALL_IMAGES = YES

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE),y)
FIRMWARE_IMX_DEPENDENCIES += linux-firmware
endif

define FIRMWARE_IMX_EXTRACT_CMDS
	$(call NXP_EXTRACT_HELPER,$(FIRMWARE_IMX_DL_DIR)/$(FIRMWARE_IMX_SOURCE))
endef

#
# DDR firmware
#

define FIRMWARE_IMX_PREPARE_DDR_FW
	$(TARGET_OBJCOPY) -I binary -O binary \
		--pad-to $(BR2_PACKAGE_FIRMWARE_IMX_IMEM_LEN) --gap-fill=0x0 \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1)).bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1))_pad.bin
	$(TARGET_OBJCOPY) -I binary -O binary \
		--pad-to $(BR2_PACKAGE_FIRMWARE_IMX_DMEM_LEN) --gap-fill=0x0 \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2)).bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2))_pad.bin
	cat $(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(1))_pad.bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(2))_pad.bin > \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(strip $(3)).bin
endef

ifeq ($(BR2_PACKAGE_HOST_IMX_MKIMAGE),y)
define FIRMWARE_IMX_MERGED_DDR_FW
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		$(1)$(subst XXX,imem,$(2))$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		$(1)$(subst XXX,dmem,$(2))$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		$(1)$(subst _XXX,,$(2))_fw)
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		$(1)$(subst XXX,imem,$(3))$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		$(1)$(subst XXX,dmem,$(3))$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		$(1)$(subst _XXX,,$(3))_fw)
	cat $(FIRMWARE_IMX_DDRFW_DIR)/$(1)$(subst _XXX,,$(2))_fw.bin \
		$(FIRMWARE_IMX_DDRFW_DIR)/$(1)$(subst _XXX,,$(3))_fw.bin > \
		$(BINARIES_DIR)/$(1)_fw.bin
	ln -sf $(1)_fw.bin $(BINARIES_DIR)/ddr_fw.bin
endef
else
define FIRMWARE_IMX_MERGED_DDR_FW
endef
endif

FIRMWARE_IMX_DDR_VERSION = $(call qstrip,$(BR2_PACKAGE_FIRMWARE_IMX_DDR_VERSION))

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_LPDDR5_IMX95),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _v$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of lpddr5_{d,i}mem_{qb}_* and generate lpddr5_fw.bin.
	# lpddr5_fw.bin is needed when generating imx9-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_MERGED_DDR_FW,lpddr5,_XXX,_XXX_qb)

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/lpddr5*$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_LPDDR4X_IMX95),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _v$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of lpddr4x_{d,i}mem_{qb}_* and generate lpddr4x_fw.bin.
	# lpddr4x_fw.bin is needed when generating imx9-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_MERGED_DDR_FW,lpddr4x,_XXX,_XXX_qb)

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/lpddr4x*$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_LPDDR4_IMX93),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _v$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of lpddr4_{d,i}mem_{1,2}d_* and generate lpddr4_fw.bin.
	# lpddr4_fw.bin is needed when generating imx9-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_MERGED_DDR_FW,lpddr4,_XXX_1d,_XXX_2d)

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/lpddr4*d$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_LPDDR4_IMX8M),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of lpddr4_pmu_* and generate lpddr4_pmu_train_fw.bin.
	# lpddr4_pmu_train_fw.bin is needed when generating imx8-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_MERGED_DDR_FW,lpddr4_pmu_train,_1d_XXX,_2d_XXX)

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/lpddr4*$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_DDR4),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of ddr4_* and generate ddr4_fw.bin.
	# ddr4_fw.bin is needed when generating imx8-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_MERGED_DDR_FW,ddr4,_XXX_1d,_XXX_2d)

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/ddr4*$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_DDR3),y)
FIRMWARE_IMX_DDRFW_DIR = $(@D)/firmware/ddr/synopsys
FIRMWARE_IMX_DDR_VERSION_SUFFIX = _$(FIRMWARE_IMX_DDR_VERSION)

define FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW
	# Create padded versions of ddr3_* and generate ddr3_fw.bin.
	# ddr3_fw.bin is needed when generating imx8-boot-sd.bin
	# which is done in post-image script.
	$(call FIRMWARE_IMX_PREPARE_DDR_FW, \
		ddr3_imem_1d$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		ddr3_dmem_1d$(FIRMWARE_IMX_DDR_VERSION_SUFFIX),
		ddr3_1d_fw)
	cat $(FIRMWARE_IMX_DDRFW_DIR)/ddr3_1d_fw.bin > \
		$(BINARIES_DIR)/ddr3_fw.bin
	ln -sf ddr3_fw.bin $(BINARIES_DIR)/ddr_fw.bin

	# U-Boot supports creation of the combined flash.bin image. To make
	# sure that U-Boot can access all available files copy them to
	# the binary dir.
	$(INSTALL) -D -m 0644 -t $(BINARIES_DIR) \
		$(FIRMWARE_IMX_DDRFW_DIR)/ddr3*$(FIRMWARE_IMX_DDR_VERSION_SUFFIX).bin
endef
endif

#
# HDMI firmware
#

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_NEEDS_HDMI_FW),y)
define FIRMWARE_IMX_INSTALL_IMAGE_HDMI_FW
	cp $(@D)/firmware/hdmi/cadence/signed_hdmi_imx8m.bin \
		$(BINARIES_DIR)/signed_hdmi_imx8m.bin
endef
endif

#
# EASRC firmware
#

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_NEEDS_EASRC_FW),y)
define FIRMWARE_IMX_INSTALL_TARGET_EASRC_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/imx
	cp -r $(@D)/firmware/easrc $(TARGET_DIR)/lib/firmware/imx
endef
endif

#
# EPDC firmware
#

ifeq ($(BR2_PACKAGE_FIRMWARE_IMX_NEEDS_EPDC_FW),y)
define FIRMWARE_IMX_INSTALL_TARGET_EPDC_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/imx
	cp -r $(@D)/firmware/epdc $(TARGET_DIR)/lib/firmware/imx
	mv $(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw.nonrestricted \
		$(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw
endef
endif

#
# SDMA firmware
#

FIRMWARE_IMX_SDMA_FW_NAME = $(call qstrip,$(BR2_PACKAGE_FIRMWARE_IMX_SDMA_FW_NAME))
ifneq ($(FIRMWARE_IMX_SDMA_FW_NAME),)
define FIRMWARE_IMX_INSTALL_TARGET_SDMA_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/imx/sdma
	cp -r $(@D)/firmware/sdma/sdma-$(FIRMWARE_IMX_SDMA_FW_NAME)*.bin \
	       $(TARGET_DIR)/lib/firmware/imx/sdma/
endef
endif

#
# VPU firmware
#

FIRMWARE_IMX_VPU_FW_NAME = $(call qstrip,$(BR2_PACKAGE_FIRMWARE_IMX_VPU_FW_NAME))
ifneq ($(FIRMWARE_IMX_VPU_FW_NAME),)
define FIRMWARE_IMX_INSTALL_TARGET_VPU_FW
	mkdir -p $(TARGET_DIR)/lib/firmware/vpu
	for i in $$(find $(@D)/firmware/vpu/vpu_fw_$(FIRMWARE_IMX_VPU_FW_NAME)*.bin); do \
		cp $$i $(TARGET_DIR)/lib/firmware/vpu/ ; \
		ln -sf vpu/$$(basename $$i) $(TARGET_DIR)/lib/firmware/$$(basename $$i) ; \
	done
endef
endif

define FIRMWARE_IMX_INSTALL_IMAGES_CMDS
	$(FIRMWARE_IMX_INSTALL_IMAGE_DDR_FW)
	$(FIRMWARE_IMX_INSTALL_IMAGE_HDMI_FW)
endef

define FIRMWARE_IMX_INSTALL_TARGET_CMDS
	$(FIRMWARE_IMX_INSTALL_TARGET_EASRC_FW)
	$(FIRMWARE_IMX_INSTALL_TARGET_EPDC_FW)
	$(FIRMWARE_IMX_INSTALL_TARGET_SDMA_FW)
	$(FIRMWARE_IMX_INSTALL_TARGET_VPU_FW)
endef

$(eval $(generic-package))
