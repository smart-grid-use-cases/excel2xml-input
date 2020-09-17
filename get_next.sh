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
revision=`expr $revision + 1`
echo ${major}.${minor}.${revision}
