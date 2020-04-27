######################################
# target
######################################
TARGET = test

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og

#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
# C_SOURCES = $(shell find ./ -name '*.c')
C_SOURCES =  \
CORE/core_cm3.c \
FWLIB/src/misc.c \
FWLIB/src/stm32f10x_adc.c \
FWLIB/src/stm32f10x_bkp.c \
FWLIB/src/stm32f10x_can.c \
FWLIB/src/stm32f10x_cec.c \
FWLIB/src/stm32f10x_crc.c \
FWLIB/src/stm32f10x_dac.c \
FWLIB/src/stm32f10x_dbgmcu.c \
FWLIB/src/stm32f10x_dma.c \
FWLIB/src/stm32f10x_exti.c \
FWLIB/src/stm32f10x_flash.c \
FWLIB/src/stm32f10x_fsmc.c \
FWLIB/src/stm32f10x_gpio.c \
FWLIB/src/stm32f10x_i2c.c \
FWLIB/src/stm32f10x_iwdg.c \
FWLIB/src/stm32f10x_pwr.c \
FWLIB/src/stm32f10x_rcc.c \
FWLIB/src/stm32f10x_rtc.c \
FWLIB/src/stm32f10x_sdio.c \
FWLIB/src/stm32f10x_spi.c \
FWLIB/src/stm32f10x_tim.c \
FWLIB/src/stm32f10x_usart.c \
FWLIB/src/stm32f10x_wwdg.c \
HARDWARE/led.c \
SYSTEM/delay.c \
SYSTEM/usart.c \
USER/main.c \
USER/stm32f10x_it.c \
USER/system_stm32f10x.c \


# show:
# 	$(C_SOURCES)

# ASM sources
ASM_SOURCES =  \
startup_stm32f103xb.s

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m3

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS =

# C defines
C_DEFS =  \
-DSTM32F103X_MD \
-DUSE_STDPERIPH_DRIVER\

# AS includes
AS_INCLUDES =

# C includes
C_INCLUDES = \
-I CORE \
-I FWLIB/inc \
-I HARDWARE \
-I SYSTEM  \
-I USER	\

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F103R8Tx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys
LIBDIR =
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

$(BUILD_DIR):
	mkdir $@

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***