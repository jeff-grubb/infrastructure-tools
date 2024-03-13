#!/usr/bin/env python3

import argparse
import boto3
import os
from config import get_sitemap_v3_configs

arg_parser = argparse.ArgumentParser(description='Kill XML files in v3-sitemap folder')
arg_parser.add_argument('--bu', help='fox business unit', required=True)
arg_parser.add_argument('--env', help='environment', default='stage')
args = arg_parser.parse_args()

config = get_sitemap_v3_configs()[args.bu][args.env]
session = boto3.session.Session(profile_name=config['profile'])
s3 = session.resource("s3")

for bucket_name in config['sitemap_v3']['buckets']:
    bucket = s3.Bucket(bucket_name)
    print (bucket_name)

    objects = bucket.objects.filter(Prefix=config['sitemap_v3']['prefix'])
    objects_to_delete = [o for o in objects if o.key.endswith('.xml')]

    basepath = "./data/" + bucket_name + "/" + config['sitemap_v3']['prefix']
    if not os.path.exists(basepath):
        os.makedirs(basepath)

    for obj in objects_to_delete:
        # Make a copy of the object before deleting
        filename = "s3://" + bucket_name + "/" + obj.key
        print ("Downloading " + filename)
        #bucket.download_file(obj.key, "./data/" + bucket_name + "/" + obj.key)

        #print ("Deleting " + filename)
        #obj.delete()
