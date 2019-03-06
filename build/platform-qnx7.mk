ARCH = arm
include $(SRC_PATH)build/arch.mk
SHAREDLIBSUFFIX = so
SHAREDLIBSUFFIXFULLVER=$(SHAREDLIBSUFFIX).$(FULL_VERSION)
SHAREDLIBSUFFIXMAJORVER=$(SHAREDLIBSUFFIX).$(SHAREDLIB_MAJORVERSION)

ifndef QNX_HOST
$(error QNX_HOST is not set)
endif
ifndef QNX_TARGET
$(error QNX_TARGET is not set)
endif

ifneq ($(filter arm, $(ARCH)),)
    TARGET_NAME = armv7
    CFLAGS += -march=armv7-a
    CFLAGS += -mfpu=vfpv3-d16
    LDFLAGS += -march=armv7-a -Wl,--fix-cortex-a8
    SYSROOT = $(QNX_TARGET)/armle-v7
else ifneq ($(filter arm64 aarch64, $(ARCH)),)
    TARGET_NAME = aarch64
    SYSROOT = $(QNX_TARGET)/aarch64le
endif

TOOLCHAINPREFIX = $(QNX_HOST)/usr/bin/
CXX = $(TOOLCHAINPREFIX)/nto$(TARGET_NAME)-g++
CC = $(TOOLCHAINPREFIX)/nto$(TARGET_NAME)-gcc
AR = $(TOOLCHAINPREFIX)/nto$(TARGET_NAME)-ar
CFLAGS += -fpic
CXXFLAGS += -fno-rtti -fno-exceptions
LDFLAGS += -lm -lsocket --sysroot=$(SYSROOT)
SHLDFLAGS = -Wl,--no-undefined -Wl,-z,relro -Wl,-z,now -Wl,-soname,lib$(PROJECT_NAME).so
