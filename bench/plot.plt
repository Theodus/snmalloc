set terminal svg
set output 'plot.svg'

set ylabel 'seconds'
set xlabel 'memory'
set logscale x 2
set format x '2^{%L}'

unset key

set yrange [0.0:1.5]

set multiplot layout 1,max_thread_pow+1 \
  margins 0.08,0.95,0.14,0.90 \
  spacing 0.04,0

set title "1 Thread"

plot 'data.txt' using 2:($1==1 ? $3 : 1/0) \
    title 'glibc' w linespoints,\
  'data.txt' using 2:($1==1 ? $4 : 1/0) \
    title 'snmalloc' w linespoints

unset ylabel
set format y ''

do for [p=1:max_thread_pow] {
  t=(2**p)
  if (p==max_thread_pow) { set key }

  set title sprintf("%d Threads", t)

  plot \
    'data.txt' using 2:($1==t ? $3 : 1/0) \
      title 'glibc' w linespoints,\
    'data.txt' using 2:($1==t ? $4 : 1/0) \
      title 'snmalloc' w linespoints
}

unset multiplot
