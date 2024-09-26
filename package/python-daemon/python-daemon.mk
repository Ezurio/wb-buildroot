################################################################################
#
# python-daemon
#
################################################################################

PYTHON_DAEMON_VERSION = 3.0.2
PYTHON_DAEMON_SOURCE = python_daemon-$(PYTHON_DAEMON_VERSION).tar.gz
PYTHON_DAEMON_SITE = https://files.pythonhosted.org/packages/4a/4a/746aebd8a8f841c53720ef40bbec8f2075d07041db29d01a2a50cd1899e7
PYTHON_DAEMON_LICENSE = Apache-2.0 (library), GPL-3.0+ (test, build)
PYTHON_DAEMON_LICENSE_FILES = LICENSE.ASF-2 LICENSE.GPL-3
PYTHON_DAEMON_SETUP_TYPE = setuptools
PYTHON_DAEMON_DEPENDENCIES = host-python-docutils

$(eval $(python-package))
