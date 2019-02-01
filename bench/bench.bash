#!/bin/bash

set -u

max_thread_pow=${1:-3}

for p in `seq 0 $max_thread_pow`; do
  for i in `seq 6 20`; do
    t="$((2 ** $p))"
    m="$((1 << $i))"
    make THREADS="$t" MEMORY="$m" TARGET="bench_$t\_$m" > /dev/null
  done
done

fmt="%-8s\t%-10s\t%-5s\t%-5s\n"

printf "$fmt" "# threads" "alloc size" "glibc" "snmalloc" | tee data.txt
for p in `seq 0 $max_thread_pow`; do
  for i in `seq 6 20`; do
    t="$((2 ** $p))"
    m="$((1 << $i))"
    real1="$((time -p ./bench_$t\_$m) |& grep real | awk '{ print $2 }')"
    real2="$((LD_PRELOAD=../build/libsnmallocshim.so time -p ./bench_$t\_$m) |& grep real | awk '{ print $2 }')"
    printf "$fmt" "$t" "$m" "$real1" "$real2" | tee -a data.txt
  done
done

gnuplot -e "max_thread_pow=$max_thread_pow" plot.plt \
  && display plot.svg
