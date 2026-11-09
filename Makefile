ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = FilterKit
FilterKit_FILES = main.m FKAppDelegate.m FKMainViewController.m FKEnvironment.m FKPluginScanner.m
FilterKit_FRAMEWORKS = UIKit Foundation
FilterKit_CFLAGS = -fobjc-arc -Wall -Wextra
FilterKit_LDFLAGS =
FilterKit_BUNDLEID = com.filterkit.manager

include $(THEOS_MAKE_PATH)/application.mk

before-package::
	@mkdir -p $(THEOS_STAGING_DIR)/Applications

