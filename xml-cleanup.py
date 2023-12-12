#!/usr/bin/env python3

import argparse
import boto3
import os

arg_parser = argparse.ArgumentParser(description='Kill XML files in v3-sitemap folder')
arg_parser.add_argument('--bu', help='fox business unit', required=True)
arg_parser.add_argument('--env', help='environment', default='stage')
args = arg_parser.parse_args()

sitemap_v3_configs = {
    'fs': {
        'environments': {
            'stage': {
                'profile': "foxsports",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-fs-static-bucket'
                ]
            }
        }
    },
    'usfl': {
        'environments': {
            'stage': {
                'profile': "foxsports",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-usfl-static-bucket'
                ]
            }
        }
    },
    'fts': {
        'environments': {
            'stage': {
                'profile': "fts",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-static-coro-com',
                    'stage-static-kcpq-com',
                    'stage-static-kdfw-com',
                    'stage-static-kmsp-com',
                    'stage-static-kriv-com',
                    'stage-static-ksaz-com',
                    'stage-static-ktbc-com',
                    'stage-static-kttv-com',
                    'stage-static-ktvu-com',
                    'stage-static-lnfx-com',
                    'stage-static-waga-com',
                    'stage-static-wfld-com',
                    'stage-static-witi-com',
                    'stage-static-wjbk-com',
                    'stage-static-wjzy-com',
                    'stage-static-wnyw-com',
                    'stage-static-wofl-com',
                    'stage-static-wogx-com',
                    'stage-static-wttg-com',
                    'stage-static-wtvt-com',
                    'stage-static-wtxf-com',
                    'stage-static-wwor-com'
                ]
            }
        }
    },
    'fn': {
        'environments': {
            'stage': {
                'profile': "foxnews",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-static-foxnews-com'
                ]
            }
        }
    },
    'fb': {
        'environments': {
            'stage': {
                'profile': "foxnews",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-static-foxbusiness-com'
                ]
            }
        }
    },
    'fw': {
        'environments': {
            'stage': {
                'profile': "foxweather",
                'prefix': 'sitemaps-v3',
                "buckets": [
                    'stage-static-foxweather-com'
                ]
            }
        }
    }
}

config = sitemap_v3_configs[args.bu]['environments'][args.env]
session = boto3.session.Session(profile_name=config['profile'])
s3 = session.resource("s3")

for bucket_name in config['buckets']:
    bucket = s3.Bucket(bucket_name)

    objects = bucket.objects.filter(Prefix=config['prefix'])
    objects_to_delete = [o for o in objects if o.key.endswith('.xml')]

    basepath = "./data/" + bucket_name + "/" + config['prefix']
    if not os.path.exists(basepath):
        os.makedirs(basepath)

    for obj in objects_to_delete:
        # Make a copy of the object before deleting
        filename = "s3://" + bucket_name + "/" + obj.key
        print ("Downloading " + filename)
        bucket.download_file(obj.key, "./data/" + bucket_name + "/" + obj.key)

        print ("Deleting " + filename)
        bucket.delete_key(obj.key)
