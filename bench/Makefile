CC ?= clang
CFLAGS := -O3 -g -Wall -Wextra -Wpedantic
LDFLAGS := -lpthread
TARGET := bench
THREADS ?= 8

.PHONY : clean bench_glibc bench_snmalloc

$(TARGET) : main.c
	$(CC) $(CFLAGS) -DN_THREADS=$(THREADS) -DTEST=0 $(LDFLAGS) -o $(TARGET) main.c

clean :
	@rm -rf $(TARGET) $(TARGET)_*
