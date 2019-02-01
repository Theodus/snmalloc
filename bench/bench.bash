#!/bin/bash

set -u

max_thread_pow=${1:-4}

min_mem_pow=6
max_mem_pow=29

for p in `seq 0 $max_thread_pow`; do
  for i in `seq $min_mem_pow $max_mem_pow`; do
    t="$((2 ** $p))"
    m="$((2 ** $i))"
    make THREADS="$t" MEMORY="$m" TARGET="bench_$t\_$m" > /dev/null
  done
done

function bench() {
  t=$1
  m=$2
  preload=$3
  (LD_PRELOAD="$preload" time -p ./bench_"$t"_"$m") |& grep real | awk '{ print $2 }'
}

fmt="%-8s\t%-10s\t%-8s\t%-8s\t%-8s\t%-8s\n"

printf "$fmt" "# threads" "alloc size" "glibc" "snmalloc" "jemalloc" "tbbmalloc" | tee data.txt
for p in `seq 0 $max_thread_pow`; do
  for i in `seq $min_mem_pow $max_mem_pow`; do
    t="$((2 ** $p))"
    m="$((2 ** $i))"
    real1="$(bench $t $m '')"
    real2="$(bench $t $m ../build/libsnmallocshim.so)"
    real3="$(bench $t $m libjemalloc.so.2)"
    real4="$(bench $t $m libtbbmalloc_proxy.so.2)"
    printf "$fmt" "$t" "$m" "$real1" "$real2" "$real3" "$real4" | tee -a data.txt
  done
done

gnuplot -e "max_thread_pow=$max_thread_pow" plot.plt \
  && display plot.svg
