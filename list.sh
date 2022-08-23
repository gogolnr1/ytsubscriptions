#!/bin/bash

# pip install yq (jq wrapper for YAML, XML, TOML documents)
# curl "https://www.youtube.com/feeds/videos.jxml?channel_id=UC2eYFnH61tmytImy1mTYvhA" > luke.xml
# cat luke.xml | xq . > luke.json

feeds()
{
  cat luke.json | jq '
    .feed.title as $feed_title
    | .feed.entry[] 
    | {
        feed_title: $feed_title, 
        title: .title,
        published: .published
      }'
}

feed()
{
  echo $subs_list | jq --slurp -r ".[$1] .$published"
}

subs_list=$(feeds)

LENGTH=$(echo $subs_list | jq --slurp -r '.[] | length')
echo $length
for i in "{1..$LENGTH}"; do
  feed $i "pusblished"
done
exit 0

echo $LENGTH

echo $subs_list | jq --slurp -r '.[0]'
echo $title
