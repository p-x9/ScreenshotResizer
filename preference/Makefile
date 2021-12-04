DEBUG = 0
GO_EASY_ON_ME := 1

ARCHS = arm64 arm64e
TARGET = iphone:14.4:9.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = preference

preference_FILES = SSRRootListController.m SSRHeaderView.m
preference_FRAMEWORKS = UIKit CoreGraphics
preference_PRIVATE_FRAMEWORKS = Preferences
preference_INSTALL_PATH = /Library/PreferenceBundles
preference_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
