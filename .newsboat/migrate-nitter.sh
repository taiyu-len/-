#!/bin/bash
# as we need to change nitter hosts, we must migrate entries to new ones.
# we need to update the cache.db, and the urls file
if [ $# -ne 2 ]; then
	echo "usage: $(basename $0)" old.nitter.url new.nitter.url
	exit 1
fi

# Rename nitter.whatever to nitter.newwhatever in all relavent items, these are 
# guid, url, feedurl, content
#
# 2nd, we need to remove duplicates, this is done by finding the minimum id of
# entires with the same guid (or are unique), and removing those not in it.
# for example, id 1 and 2 with guid foo, the subquery return 1, the delete
# deletes 2 as its not in that
sqlite3 cache.db <<EOF
update rss_feed
set
  rssurl = REPLACE(rssurl, "$1", "$2"),
  url    = REPLACE(url,    "$1", "$2");
update rss_item
set
  guid    = REPLACE(guid,    "$1", "$2"),
  url     = REPLACE(url,     "$1", "$2"),
  feedurl = REPLACE(feedurl, "$1", "$2"),
  content = REPLACE(content, "$1", "$2");
delete from rss_item
where id not in (
  select min(id) as id
  from rss_item
  group by guid
);
EOF

# 3rd, update the url file
sed -i "s|$1|$2|" urls

