#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path>/devkitpro")
endif

export DEVKITARM ?= $(DEVKITPRO)/devkitARM

# 1. TOP: Include the base tools to define CC, CXX, etc.
include $(DEVKITARM)/base_tools

# 2. Force the linker to use the C++ compiler to avoid x86_64 ld fallbacks
export LD := $(CXX)

TARGET		:= hello_world_3ds
BUILD		:= build
SOURCES		:= source
DATA		:= data
INCLUDES	:= include

CFLAGS		:= -g -Wall -O2 -mword-relocations -ffunction-sections \
			   -march=armv6k -mtune=mpcore -mfloat-abi=hard -ftree-vectorize \
			   $(INCLUDE)

CXXFLAGS	:= $(CFLAGS) -std=gnu++17 -fno-rtti -fno-exceptions
ASFLAGS		:= -g -march=armv6k -mtune=mpcore -mfloat-abi=hard

LDFLAGS		:= -specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mfloat-abi=hard

LIBS		:= -lcitro3d -lctru -lm

# ---------------------------------------------------------------------------
# Build Rules
# ---------------------------------------------------------------------------

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

export OFILES	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					-I$(DEVKITPRO)/libctru/include

export LIBPATHS :=  -L$(DEVKITPRO)/libctru/lib

.PHONY: all clean

all: $(BUILD)
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

$(BUILD):
	@mkdir -p $@

clean:
	@rm -fr $(BUILD) $(TARGET).3dsx $(TARGET).smdh $(TARGET).elf

else

DEPENDS	:=	$(OFILES:.o=.d)

# 1. Include the recipes for 3DS files
include $(DEVKITARM)/3ds_rules

# 2. Tell Make EXACTLY what targets to build
.PHONY: all
all: $(OUTPUT).3dsx $(OUTPUT).elf

# 3. Link the targets to your source objects
$(OUTPUT).3dsx: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

-include $(DEPENDS)

endif
