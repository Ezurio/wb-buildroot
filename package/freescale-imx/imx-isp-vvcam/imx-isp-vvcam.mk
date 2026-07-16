################################################################################
#
# imx-isp-vvcam
#
################################################################################

IMX_ISP_VVCAM_VERSION = lf-6.18.20-2.0.0
IMX_ISP_VVCAM_SITE = $(call github,nxp-imx,isp-vvcam,$(IMX_ISP_VVCAM_VERSION))
IMX_ISP_VVCAM_LICENSE = GPL-2.0
IMX_ISP_VVCAM_LICENSE_FILES = vvcam/LICENSE


# Each of these is a standalone out-of-tree kbuild module directory
# (vvcam/v4l2/<name>/Makefile defines its own obj-m). "video" needs
# dwe's generated Module.symvers to resolve the dwe symbols it uses,
# hence dwe is built first and KBUILD_EXTRA_SYMBOLS points at it; the
# option is harmless for the other modules that don't need it.
IMX_ISP_VVCAM_MODULE_SUBDIRS = \
	vvcam/v4l2/dwe \
	vvcam/v4l2/isp \
	vvcam/v4l2/video

IMX_ISP_VVCAM_SYMVERS_FILES = \
	$(IMX_ISP_VVCAM_MODULE_SUBDIRS:%=$(IMX_ISP_VVCAM_DIR)/%/Module.symvers)

# modpost aborts the build if a file listed in KBUILD_EXTRA_SYMBOLS does not
# exist, so a placeholder must be present for every subdir before the first
# one is even built; each gets overwritten with real content as its owning
# module is built, in the order given by MODULE_SUBDIRS above.
define IMX_ISP_VVCAM_TOUCH_SYMVERS_PLACEHOLDERS
	touch $(IMX_ISP_VVCAM_SYMVERS_FILES)
endef
IMX_ISP_VVCAM_PRE_BUILD_HOOKS += IMX_ISP_VVCAM_TOUCH_SYMVERS_PLACEHOLDERS

IMX_ISP_VVCAM_MODULE_MAKE_OPTS = \
	KBUILD_EXTRA_SYMBOLS="$(IMX_ISP_VVCAM_SYMVERS_FILES)"

$(eval $(kernel-module))
$(eval $(generic-package))
