#!/bin/bash

SourceFolderFullPath=""
DestFolder=""
S3BucketName=""

display_upload_help() {
    echo "Usage: $0 [option...] {-s|-d|-b}" >&2
    echo
    echo "   -s           A source folder to upload from -> to S3 Bucket"
    echo "   -d           Destination folder - a remote place to host files "
    echo "   -b           Bucket name - upload to"
    echo
    exit 1
}

while getopts ":s:d:b:" opt; do
  case ${opt} in
	s )
	  SourceFolderFullPath=$OPTARG
	  echo $SourceFolderFullPath
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
	   display_upload_help
	  ;;
	: )
	  echo "Invalid option: $OPTARG requires an argument" 1>&2
	  ;;
  esac
done

shift $((OPTIND -1))

if [[ ! -z $SourceFolderFullPath ]] && [[ ! -z $DestFolder ]] && [[ ! -z $S3BucketName ]]; then
	echo "$(date +%Y/%m/%d_%H:%M:%S) - Start - Uploading to S3 bucket: $S3BucketName" >> $(date +%Y-%m-%d)_uploads.log
	echo "Uploading $SourceFolderFullPath to the following S3 bucket: $S3BucketName/$DestFolder"
	echo "Uploading $SourceFolderFullPath to the following S3 bucket: $S3BucketName/$DestFolder" >> $(date +%Y-%m-%d)_uploads.log

	for file in $SourceFolderFullPath/*; do
	    let "Counter=Counter+1"
            aws s3 cp $SourceFolderFullPath/$(basename "$file") s3://$S3BucketName/$DestFolder/ >> $(date +%Y-%m-%d)_uploads.log
	    echo "$SourceFolderFullPath/$(basename "$file") uploaded!"
	done	

	echo "$(date +%Y/%m/%d_%H:%M:%S) - End - $Counter files uploaded to S3 bucket: $S3BucketName" >> $(date +%Y-%m-%d)_uploads.log
	echo "$(date +%Y/%m/%d_%H:%M:%S) - End - $Counter files uploaded to S3 bucket: $S3BucketName"
else
	display_upload_help
	exit 1
fi

