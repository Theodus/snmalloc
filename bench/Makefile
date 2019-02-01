CC ?= clang
C_FLAGS := -O3 -g -Wall -Wextra -Wpedantic
LD_FLAGS := -lpthread
TARGET := bench
THREADS ?= 8
MEMORY ?= $(shell echo "$$((1 << 26))")
C_DEFINES := -DTEST=0 -DN_THREADS=$(THREADS) -DMEMORY=$(MEMORY)

.PHONY : clean

$(TARGET) : t-test1.c
	$(CC) $(C_FLAGS) $(C_DEFINES) $(LD_FLAGS) -o $(TARGET) t-test1.c

clean :
	@rm -rf $(TARGET) $(TARGET)_*
