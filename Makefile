# Copyright 2019 SiFive, Inc #
# SPDX-License-Identifier: Apache-2.0 #

PROGRAM ?= mem-latency
# By default, it tests the latency of accessing the heap mem with 4096B.
# To test the latency of accessing the max allocable heap mem, set TEST_SIZE to 0.
# To test memory outside of the heap range, set both TEST_ADDR and TEST_SIZE.
MEM_TEST_FLAGS ?= -DTEST_SIZE=4096

$(PROGRAM): clean $(wildcard *.c) $(wildcard *.h) $(wildcard *.S)
	$(CC) $(CFLAGS) $(LDFLAGS) -Xlinker --defsym=__heap_max=0x1 $(filter %.c %.S,$^) $(LOADLIBES) $(LDLIBS) $(MEM_TEST_FLAGS) -o $@
	riscv64-unknown-elf-objdump -d $@ > $@.dump

clean:
	rm -f $(PROGRAM) $(PROGRAM).dump $(PROGRAM).hex
