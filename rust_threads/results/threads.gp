set title "Threaded factorial computation"

set terminal png font arial 14 size 1024,1024

set xlabel "Nb threads"
set ylabel "Ratio"

set output "threads.png"

set yrange [0:0.4]

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 0.8


plot 'results.dat' index 0 using 2:3 with linespoints linestyle 1 title '', \
     'results.dat' index 1 using 2:3 with linespoints linestyle 1 title ''