#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path>/devkitpro")
endif

export DEVKITARM ?= $(DEVKITPRO)/devkitARM
include $(DEVKITARM)/base_tools

# FIX: Explicitly define the Linker and Assembler so Make doesn't fall back to Ubuntu's x86 tools
export LD := $(CXX)
export AS := arm-none-eabi-as

TARGET		:= simple_3d_game
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

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)
export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
					$(foreach dir,$(DATA),$(CURDIR)/$(dir))

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
PICAFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.v.pica)))

export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export OFILES_SH      := $(PICAFILES:.v.pica=.shbin.o)
export OFILES         := $(OFILES_SH) $(OFILES_SOURCES)

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					-I$(CURDIR)/$(BUILD) \
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

include $(DEVKITARM)/3ds_rules

.PHONY: all
all: $(OUTPUT).3dsx $(OUTPUT).elf

$(OUTPUT).3dsx: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

$(OFILES_SOURCES): $(OFILES_SH)

# Rule to assemble PICA shaders into .shbin.o and auto-generate the _shbin.h header
%.shbin.o %_shbin.h: %.v.pica
	@echo "Compiling shader $<..."
	@picasso -o $*.shbin $<
	@bin2s $*.shbin | $(AS) $(ASFLAGS) -o $*.shbin.o
	@echo "extern const u8 $*_shbin[];" > $*_shbin.h
	@echo "extern const u8 $*_shbin_end[];" >> $*_shbin.h
	@echo "extern const u32 $*_shbin_size;" >> $*_shbin.h

-include $(DEPENDS)

endif
