DEBUG = 0
GO_EASY_ON_ME := 1

ARCHS = arm64 arm64e
TARGET = iphone:14.4:9.3
THEOS_DEVICE_IP = 127.0.0.1 -p 2222

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = screenshotresize

screenshotresize_FILES = Tweak.xm
screenshotresize_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit QuartzCore VideoToolbox CoreGraphics CoreVideo

include $(THEOS_MAKE_PATH)/tweak.mk
