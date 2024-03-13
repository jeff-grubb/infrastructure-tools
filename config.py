spark_business_units = ['fs', 'usfl', 'fts', 'fn', 'fb', 'fw']
spark_environments = ['dev', 'stage', 'prod']

sitemap_v3_buckets = {
    'fs': {
        "buckets": [
            'fs-static-bucket'
        ]
    },
    'usfl': {
        "buckets": [
            'usfl-static-bucket'
        ]
    },
    'fts': {
        "buckets": [
            'static-coro-com',
            'static-kcpq-com',
            'static-kdfw-com',
            'static-kmsp-com',
            'static-kriv-com',
            'static-ksaz-com',
            'static-ktbc-com',
            'static-kttv-com',
            'static-ktvu-com',
            'static-lnfx-com',
            'static-waga-com',
            'static-wfld-com',
            'static-witi-com',
            'static-wjbk-com',
            'static-wjzy-com',
            'static-wnyw-com',
            'static-wofl-com',
            'static-wogx-com',
            'static-wttg-com',
            'static-wtvt-com',
            'static-wtxf-com',
            'static-wwor-com'
        ]
    },
    'fn': {
        "buckets": [
            'static-foxnews-com'
        ]
    },
    'fb': {
        "buckets": [
            'static-foxbusiness-com'
        ]
    },
    'fw': {
        "buckets": [
            'static-foxweather-com'
        ]
    }
}

def get_enviroments():
    obj = dict()
    for bu in spark_business_units:
        obj[bu] = dict()
        for env in spark_environments:
            obj[bu][env] = dict()
    return obj

def bu_to_profile(bu, env, postfix=""):
    profile = ""
    match bu:
        case 'fs':
            profile = "foxsports" + postfix
        case 'usfl':
            profile = "foxsports" + postfix
        case 'fts':
            profile = "fts" + postfix
        case 'fn':
            profile = "foxnews" + postfix
        case 'fb':
            profile = "foxnews" + postfix
        case 'fw':
            profile = "foxweather" + postfix
        case 'ok':
            profile = "outkick" + postfix

    if env == 'dev':
        profile = "dev-" + profile

    return profile


def get_profiles():
    environments = get_enviroments()

    for bu in environments:
        for env in environments[bu]:
            environments[bu][env]['profile'] = bu_to_profile(bu, env)

    return environments

def get_control_buckets():
    environments = get_enviroments()

    for bu in environments:
        for env in environments[bu]:
            environments[bu][env]['control_bucket'] = bu_to_profile(bu, env, postfix="-control")

    return environments

def get_sitemap_v3_configs():
    environments = get_profiles()

    for bu in environments:
        for env in environments[bu]:
            environments[bu][env]['sitemap_v3'] = dict()
            environments[bu][env]['sitemap_v3']['buckets'] = []
            environments[bu][env]['sitemap_v3']['prefix'] = 'sitemaps-v3'

            for bucket in sitemap_v3_buckets[bu]['buckets']:

                # Have to do this because inconsistencies in bucket naming
                match bu:
                    case 'fs':
                        environments[bu][env]['sitemap_v3']['buckets'].append(env + "-" + bucket)
                    case _:
                        bucket_name = env + "-" + bucket if env != 'prod' else bucket
                        environments[bu][env]['sitemap_v3']['buckets'].append(bucket_name)

    return environments
