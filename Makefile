export TARGET = iphone:clang::7.0
export ARCHS = armv7 arm64
export GO_EASY_ON_ME = 1

include /opt/theos/makefiles/common.mk

TWEAK_NAME = AssetsUnpacker
AssetsUnpacker_FILES = Tweak.xm
AssetsUnpacker_FRAMEWORKS = UIKit
AssetsUnpacker_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
