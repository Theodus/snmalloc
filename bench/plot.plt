set terminal svg size 2000,800
set output 'plot.svg'

set ylabel 'seconds'
set xlabel 'allcoation size'
set logscale x 2
set format x '2^{%L}'

unset key

set yrange [0.0:1.4]

set multiplot layout 1,max_thread_pow+1 \
  margins 0.05,0.95,0.10,0.90 \
  spacing 0.01,0

set title "1 Thread"

set style line 1 linecolor rgb "black"
set style line 2 linecolor rgb "blue"
set style line 3 linecolor rgb "#27ad81"
set style line 4 linecolor rgb "red"

plot 'data.txt' using 2:($1==1 ? $3 : 1/0) \
    title 'glibc' w linespoints ls 1,\
  'data.txt' using 2:($1==1 ? $4 : 1/0) \
    title 'snmalloc' w linespoints ls 2,\
  'data.txt' using 2:($1==1 ? $5 : 1/0) \
    title 'jemalloc' w linespoints ls 3,\
  'data.txt' using 2:($1==1 ? $6 : 1/0) \
    title 'tbbmalloc' w linespoints ls 4

unset ylabel
set format y ''

do for [p=1:max_thread_pow] {
  t=(2**p)
  if (p==max_thread_pow) { set key }

  set title sprintf("%d Threads", t)

  plot \
    'data.txt' using 2:($1==t ? $3 : 1/0) \
      title 'glibc' w linespoints ls 1,\
    'data.txt' using 2:($1==t ? $4 : 1/0) \
      title 'snmalloc' w linespoints ls 2,\
    'data.txt' using 2:($1==t ? $5 : 1/0) \
      title 'jemalloc' w linespoints ls 3,\
    'data.txt' using 2:($1==t ? $6 : 1/0) \
      title 'tbbmalloc' w linespoints ls 4
}

unset multiplot
