DEBUG = 0
GO_EASY_ON_ME := 1

ARCHS = arm64 arm64e
TARGET = iphone:14.4:9.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = preference

$(BUNDLE_NAME)_FILES = $(wildcard ./*.m)
$(BUNDLE_NAME)_FRAMEWORKS = UIKit CoreGraphics
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
