
set -e
set -u

make clean
make THREADS=4 MEMORY=1024 N_TOTAL=100000
sudo LD_PRELOAD=../build/libsnmallocshim.so perf record -g ./bench
sudo perf script > out.perf
~/src/FlameGraph/stackcollapse-perf.pl out.perf > out.folded
~/src/FlameGraph/flamegraph.pl \
  --width 2400 \
  out.folded > out.svg
