#!/bin/bash

# pip install yq (jq wrapper for YAML, XML, TOML documents)
# curl "https://www.youtube.com/feeds/videos.jxml?channel_id=UC2eYFnH61tmytImy1mTYvhA" > luke.xml
# cat luke.xml | xq . > luke.json

cat luke.json | jq '.feed.title as $feed_title | .feed.entry[] | {feed_title: $feed_title, entry_title: .title, published: .published}'
