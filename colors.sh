#!/bin/bash
# Based on: https://gist.github.com/XVilka/8346728

color_string() {
  input=$1
  i=0 ; sum=0
  while (( i++ < ${#input} ))
  do
    char=$(expr substr "$input" $i 1)
    sum=$(($sum + $(printf "%d" "'$char")))
  done

  awk -v sum="$sum" -v input="$input" \
  'BEGIN{
    r = int(("0."substr(sprintf("%.16g", sin(sum+1)),7))*256);
    g = int(("0."substr(sprintf("%.16g", sin(sum+2)),7))*256);
    b = int(("0."substr(sprintf("%.16g", sin(sum+3)),7))*256);
    printf "\033[48;2;%d;%d;%dm", r,g,b;
    printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
    printf "\033[0m", input "\e[0m";
  }'
}
