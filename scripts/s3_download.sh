#!/bin/bash

ContentFileFullPath=""
DestFolder=""
S3BucketName=""

display_download_help() {
    echo "Usage: $0 [option...] {-f|-d|-b}" >&2
    echo
    echo "   -f           A file which contains S3 bucket file to download"
    echo "   -d           Destination folder - a local place to host files "
    echo "   -b           Bucket name - download from"
    echo
    exit 1
}

while getopts ":f:d:b:" opt; do
  case ${opt} in
		f )
		  ContentFileFullPath=$OPTARG
		  echo $ContentFileFullPath
		  ;;
		d )
		  DestFolder=$OPTARG
		  echo $DestFolder
		  ;;
		b )
		  S3BucketName=$OPTARG
		  echo $S3BucketName
		  ;;
   \? )
		   display_download_help
		  ;;
		: )
		  echo "Invalid option: $OPTARG requires an argument" 1>&2
		  ;;
  esac
done

shift $((OPTIND -1))


if [[ ! -z $ContentFileFullPath ]] && [[ ! -z $DestFolder ]] && [[ ! -z $S3BucketName ]]; then
		echo "$(date +%Y/%m/%d_%H:%M:%S) - Start - Downloading from S3 bucket: $S3BucketName" >> $(date +%Y-%m-%d)_downloads.log
	        echo "Downloading files from the following S3 bucket: $S3BucketName to $DestFolder local folder"
	        echo "Downloading files from the following S3 bucket: $S3BucketName to $DestFolder local folder" >> $(date +%Y-%m-%d)_downloads.log

		for filename in $(cat $ContentFileFullPath)
		do
			let "Counter=Counter+1"
			echo $Counter "$filename"
			aws s3 cp s3://$S3BucketName/$filename $DestFolder/$filename >> $(date +%Y-%m-%d)_downloads.log
		done
		echo "$(date +%Y/%m/%d_%H:%M:%S) - End - $Counter files downloaded from S3 bucket: $S3BucketName" >> $(date +%Y-%m-%d)_downloads.log
		echo "$(date +%Y/%m/%d_%H:%M:%S) - End - $Counter files downloaded from S3 bucket: $S3BucketName"
else
		display_download_help
		exit 1
fi

