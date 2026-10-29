#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------ifeq ($(strip $(DEVKITPRO)),)$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=/devkitpro")
endifexport DEVKITARM ?= $(DEVKITPRO)/devkitARMinclude $(DEVKITARM)/base_toolsexport LD := $(CXX)TARGET		:= hello_world_3ds
BUILD		:= build
SOURCES		:= source
DATA		:= data
INCLUDES	:= includeCFLAGS		:= -g -Wall -O2 -mword-relocations -ffunction-sections -march=armv6k -mtune=mpcore -mfloat-abi=hard -ftree-vectorize $(INCLUDE)CXXFLAGS	:= $(CFLAGS) -std=gnu++17 -fno-rtti -fno-exceptions
ASFLAGS		:= -g -march=armv6k -mtune=mpcore -mfloat-abi=hardLDFLAGS		:= -specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mfloat-abi=hardLIBS		:= -lcitro3d -lctru -lm#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir$(CURDIR)))
#---------------------------------------------------------------------------------export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard$(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard$(dir)/.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard$(dir)/.s)))
PICAFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard$(dir)/*.v.pica)))export OFILES	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o)$(SFILES:.s=.o)
export SHHEADERS:=	$(PICAFILES:.v.pica=_shbin.h)export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
-I$(CURDIR)/$(BUILD) \
-I$(DEVKITPRO)/libctru/includeexport LIBPATHS :=	-L$(DEVKITPRO)/libctru/lib.PHONY: all cleanall: $(BUILD)
@$(MAKE) --no-print-directory -C $(BUILD) -f$(CURDIR)/Makefile$(BUILD):
@mkdir -p $@clean:
@rm -fr $(BUILD)$(TARGET).3dsx $(TARGET).smdh $(TARGET).elf#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------DEPENDS	:=	$(OFILES:.o=.d)include $(DEVKITARM)/3ds_rules.PHONY: all
all: $(OUTPUT).3dsx$(OUTPUT).elf$(OFILES):$(SHHEADERS)$(OUTPUT).3dsx:$(OUTPUT).elf
$(OUTPUT).elf:$(OFILES)-include $(DEPENDS)#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
