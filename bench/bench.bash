#!/bin/bash

set -u

max_threads=${1:-4}

for i in `seq 1 $max_threads`; do
  make THREADS="$i" TARGET="bench_$i" > /dev/null
done

echo -e "# threads\t glibc\t snmalloc" | tee data.txt
for i in `seq 1 $max_threads`; do
  row="\t$i"
  row+="\t $((time -p ./bench_$i) |& grep real | awk '{ print $2 }')"
  row+="\t $((LD_PRELOAD=../build/libsnmallocshim.so time -p ./bench_$i) |& grep real | awk '{ print $2 }')"
  echo -e $row | tee -a data.txt
done

gnuplot -e "\
  set terminal svg;\
  set output 'plot.svg';\
  set xlabel 'threads';\
  set ylabel 'seconds';\
  plot 'data.txt' using 1:2 title 'glibc' w linespoints, \
    'data.txt' using 1:3 title 'snmalloc' w linespoints"

display plot.svg
