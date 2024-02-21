PROJECT = program

CC      = gcc
CFLAGS  = -Wall -Wextra -Wdisabled-optimization -Wdiv-by-zero -Werror \
          -Wfloat-equal -Wint-to-pointer-cast \
          -Wmissing-include-dirs -Wnested-externs \
          -Wno-main -Woverflow -Wparentheses -Wpointer-arith \
          -Wpointer-to-int-cast -Wredundant-decls -Wshadow \
          -Wstrict-prototypes -Wtrigraphs -Wundef -Wunused-parameter \
          -Wvariadic-macros -Wvla -Wwrite-strings \
          -fno-asynchronous-unwind-tables -fno-unwind-tables \
          -fno-stack-protector -fno-builtin -nostdinc -nostdlib \
          -fno-strict-aliasing -Wl,--build-id=none -std=c11 -pedantic \
          -fpie -c -s -Os -m64

ASM     = nasm
AFLAGS  = -f elf64

LD      = ld
LDFLAGS = -s -T linker.ld --nmagic

OBJCOPY = objcopy
OBJCOPY_FLAGS = -O binary

BUILD_DIR = build

SRC_FILES = $(shell find . -name '*.c' -o -name '*.asm')
OBJ_FILES = $(patsubst ./%.o,$(BUILD_DIR)/%.o,$(filter %.o,$(SRC_FILES:.c=.o) $(SRC_FILES:.asm=.o)))

TARGET = $(BUILD_DIR)/$(PROJECT).elf
TARGET_BIN = $(BUILD_DIR)/$(PROJECT).bin

.PHONY: all clean rebuild

all: .build

test:
	@echo $(SRC_FILES)
	@echo $(OBJ_FILES)
	@echo $(TARGET)
	@echo $(TARGET_BIN)

.build: $(BUILD_DIR) $(TARGET_BIN)

rebuild: clean all

clean:
	rm -fv $(BUILD_DIR)/*.o $(TARGET) $(TARGET_BIN)

$(TARGET_BIN): $(TARGET)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(TARGET) $(TARGET_BIN)

$(TARGET): $(OBJ_FILES)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJ_FILES)

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: %.asm
	$(ASM) $(AFLAGS) -o $@ $^

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

