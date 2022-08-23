#!/bin/bash
# https://www.shellscript.sh/tips/hms/
# Example of Days, Hours, Minutes, Seconds.
# Look for the "*** To avoid having to wait" comments
#   for a quicker way of playing with this!

# Define dhms() function
dhms()
(
  FIRST_VALUE=$1
  # Convert Seconds to Days, Hours, Minutes, Seconds
  # Optional second argument of "long" makes it display
  # the longer format, otherwise short format.
  set_remain_seconds()
  {
    SECONDS=$1
    let S=${SECONDS}%60
    let MM=${SECONDS}/60 # Total number of minutes
    let M=${MM}%60
    let H=${MM}/60
    [ "$1" == "$FIRST_VALUE" ] && let D=${H}/24
  }

  set_remain_seconds ${1:-0}
  
  if [ "$2" == "long" ]; then
    # Display "[4 day, ]1 hour, 2 minutes and 3 seconds" format
    # Using the x_TAG variables makes this easier to translate; simply appending
    # "s" to the word is not easy to translate into other languages.
    [ "$D" -eq "1" ] && D_TAG="day" || D_TAG="days"
    [ "$D" -gt "0" ] && printf "%d %s " $D "${D_TAG},"
    set_remain_seconds $(( ${SECONDS}%86400 )) # 60*60*24

    [ "$H" -eq "1" ] && H_TAG="hour" || H_TAG="hours"
    [ "$M" -eq "1" ] && M_TAG="minute" || M_TAG="minutes"
    [ "$S" -eq "1" ] && S_TAG="second" || S_TAG="seconds"
    [ "$H" -gt "0" ] && printf "%d %s " $H "${H_TAG},"
    [ "$M" -ge "1" ] && printf "%d %s " $M "${M_TAG} and"
    printf "%d %s\n" $S "${S_TAG}"
  elif [ "$2" == "distinct" ]; then
    # Display "4d01h" format
    [ "$D" -gt "0" ] && printf "%01d%s" $D "d"
    set_remain_seconds $(( ${SECONDS}%86400 )) # 60*60*24

    # Display "01h02m03s" format
    [ "$H" -gt "0" ] && printf "%02d%s" $H "h"
    [ "$M" -gt "0" ] && [ "$D" -lt "1" ] && printf "%02d%s" $M "m"
    [ "$S" -gt "0" ] && [ "$D" -lt "1" ] && printf "%02d%s" $S "s"
    printf "\n"
  else
    # Display "4d01h" format
    [ "$D" -gt "0" ] && printf "%01d%s" $D "d"
    set_remain_seconds $(( ${SECONDS}%86400 )) # 60*60*24

    # Display "01h02m03s" format
    [ "$H" -gt "0" ] && printf "%02d%s" $H "h"
    [ "$M" -gt "0" ] && printf "%02d%s" $M "m"
    printf "%02d%s\n" $S "s"
  fi
)

dhms $*

