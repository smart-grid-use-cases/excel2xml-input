#!/bin/bash
set -o nounset

owner_url=$1
repo_name=$2
latest_url=$(wget https://github.com/${owner_url}/${repo_name}/releases/latest --max-redirect=0 2>&1 | grep Location)
prefix="Location: https://github.com/${owner_url}/${repo_name}/releases/tag/"
suffix=" [following]"
tail=${latest_url#"$prefix"}
release_version=${tail%"$suffix"}
major=`echo $release_version | cut -d. -f1`
minor=`echo $release_version | cut -d. -f2`
revision=`echo $release_version | cut -d. -f3`
found_untagged_version=false
check_version=0.0.0
while ! $found_untagged_version;
do
  revision=`expr $revision + 1`
  check_version=${major}.${minor}.${revision}
  check_url=https://github.com/${owner_url}/${repo_name}/releases/tag/$check_version
  check=$(wget $check_url &> /dev/null)
  if [ $? == 8 ];
  then
    found_untagged_version=true
  fi
done
echo $check_version
