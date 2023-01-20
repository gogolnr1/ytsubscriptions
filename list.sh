#!/bin/bash

source "./dhms.sh"
source "./colors.sh"

# pip install yq (jq wrapper for YAML, XML, TOML documents)
# curl "https://www.youtube.com/feeds/videos.jxml?channel_id=UC2eYFnH61tmytImy1mTYvhA" > luke.xml
# cat luke.xml | xq . > luke.json

feeds()
{
  for row in $(jq -c '.channels | map(.) | .[] | @base64' subscriptions.json); do
  #for row in $(cat subscriptions.json | jq -r '.[]'); do
    #echo "$row"
    _jq() {
     echo "${row}" | base64 --decode --ignore-garbage| jq -r "${1}"
    }
    
    # OPTIONAL
    # Set each property of the row to a variable
    name=$(_jq '.name')
    c_id=$(_jq '.c_id')
    long_json=$long_json$(curl "https://www.youtube.com/feeds/videos.xml?channel_id=$c_id" | xq .)

    # Utilize your variables
    #echo "$name = $c_id"
  done
  #echo $long_json | jq .
  #exit 0

  echo $long_json | jq --slurp '.[]
    | .feed.title as $feed_title
    | .feed.entry[] 
    | {
        feed_title: $feed_title, 
        title: .title,
        published: .published
      }' \
  | jq --slurp '. |=sort_by(.published) | reverse'
}

feed()
{
  published=$(echo $subs_list | jq -r ".[$1-1] $2" | date -f - +%s)
  published=$(($(date +%s)-$published))
  feed_title=$(echo $subs_list | jq -r ".[$1-1] $3")
  title=$(echo $subs_list | jq -r ".[$1-1] $4")
  title_colored=$(color_string "$feed_title")
  time_since=$(dhms $published distinct)
  #printf "$title_colored¤$time_since¤$title\n"
  echo "$title_colored¤$time_since¤$title" | awk -F '¤' -v OFS='¤' '{printf "%20s %8s %s", $1, $2, $3}' | column -s '¤' -t
}
#feeds
#exit 0

subs_list=$(feeds)
#echo $subs_list | jq --slurp -r .
#exit 0

LENGTH=$(echo $subs_list | jq -r '. | length')
for i in $(seq 1 $LENGTH); do
  feed $i ".published" ".feed_title" ".title"
done
exit 0

echo $LENGTH

echo $subs_list | jq --slurp -r '.[0]'
echo $title
