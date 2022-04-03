const fs = require('fs');
const os = require("os");

/**
 Fetch a specific set of dns records using the next cURL request
 curl --location --request GET 'https://api.cloudflare.com/client/v4/zones/<zone id>/dns_records?type=a,aaaa,cname&per_page=500' \
 --header 'X-Auth-Email: <email>' \
 --header 'X-Auth-Key: <auth token>' \
 --header 'Content-Type: application/json'
 */

const dnsRecordsCOM = {
    "result": [
        {
            "id": "8ca9575c51c97bed8b683ecf71d44ba1",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "cesarb.dev",
            "type": "A",
            "content": "84.85.77.49",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2022-03-19T18:24:07.347683Z",
            "modified_on": "2022-03-19T18:25:18.183701Z"
        },
        {
            "id": "1b97ce6faa4d750a597bd5090a1635b4",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "grafana.cesarb.dev",
            "type": "A",
            "content": "84.85.77.49",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2022-03-20T17:30:49.016887Z",
            "modified_on": "2022-03-20T17:51:02.596019Z"
        },
        {
            "id": "20c7d5e159a5680afd44a2fd751aaa80",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "nginx.cesarb.dev",
            "type": "A",
            "content": "84.85.77.49",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2022-03-19T18:54:02.864491Z",
            "modified_on": "2022-03-19T18:54:02.864491Z"
        },
        {
            "id": "dfe473d6987628159f101649563ed5b7",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "traefik.cesarb.dev",
            "type": "A",
            "content": "84.85.77.49",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2022-03-20T09:38:28.600135Z",
            "modified_on": "2022-03-20T09:38:28.600135Z"
        },
        {
            "id": "a888be5f99dc0542c7ba607d5d015c49",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "fm1._domainkey.cesarb.dev",
            "type": "CNAME",
            "content": "fm1.cesarb.dev.dkim.fmhosted.com",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.991146Z",
            "modified_on": "2020-09-20T13:13:40.991146Z"
        },
        {
            "id": "6ed8eff889cc6ddad038ba861a072ca0",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "fm2._domainkey.cesarb.dev",
            "type": "CNAME",
            "content": "fm2.cesarb.dev.dkim.fmhosted.com",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.986648Z",
            "modified_on": "2020-09-20T13:13:40.986648Z"
        },
        {
            "id": "17fcfd866abcfda4d929a232545312db",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "fm3._domainkey.cesarb.dev",
            "type": "CNAME",
            "content": "fm3.cesarb.dev.dkim.fmhosted.com",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.994751Z",
            "modified_on": "2020-09-20T13:13:40.994751Z"
        },
        {
            "id": "c84288aba3b7b75784b2219641019805",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "www.cesarb.dev",
            "type": "CNAME",
            "content": "cesarb.dev",
            "proxiable": true,
            "proxied": true,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2021-04-22T20:15:44.375406Z",
            "modified_on": "2021-04-22T20:15:44.375406Z"
        },
        {
            "id": "07c458dd80ba311f67876ee1d980b6c1",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "*.cesarb.dev",
            "type": "MX",
            "content": "in2-smtp.messagingengine.com",
            "priority": 20,
            "proxiable": false,
            "proxied": false,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.982897Z",
            "modified_on": "2020-09-20T13:13:40.982897Z"
        },
        {
            "id": "269fafeeb2b4f7688364d96f37abab9e",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "*.cesarb.dev",
            "type": "MX",
            "content": "in1-smtp.messagingengine.com",
            "priority": 10,
            "proxiable": false,
            "proxied": false,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.979222Z",
            "modified_on": "2020-09-20T13:13:40.979222Z"
        },
        {
            "id": "7694ee28f6ca33ed627de232f9932683",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "cesarb.dev",
            "type": "MX",
            "content": "in2-smtp.messagingengine.com",
            "priority": 20,
            "proxiable": false,
            "proxied": false,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.966096Z",
            "modified_on": "2020-09-20T13:13:40.966096Z"
        },
        {
            "id": "50f8cbb1eda8d5bba76f6cad1cc77ce4",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "cesarb.dev",
            "type": "MX",
            "content": "in1-smtp.messagingengine.com",
            "priority": 10,
            "proxiable": false,
            "proxied": false,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.96183Z",
            "modified_on": "2020-09-20T13:13:40.96183Z"
        },
        {
            "id": "cfbed49f4751235b1c42d327f93446d4",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "cesarb.dev",
            "type": "TXT",
            "content": "v=spf1 include:spf.messagingengine.com ?all",
            "proxiable": false,
            "proxied": false,
            "ttl": 1,
            "locked": false,
            "meta": {
                "auto_added": false,
                "managed_by_apps": false,
                "managed_by_argo_tunnel": false,
                "source": "primary"
            },
            "created_on": "2020-09-20T13:13:40.975928Z",
            "modified_on": "2020-09-20T13:13:40.975928Z"
        }
    ],
    "success": true,
    "errors": [],
    "messages": [],
    "result_info": {
        "page": 1,
        "per_page": 100,
        "count": 13,
        "total_count": 13,
        "total_pages": 1
    }
}

const createFile = async (dnsRecords, zoneName) => {
    const tfRecords = []
    const commands = []
    const template =
        'resource \"cloudflare_record\" \"RECORD_LOCAL_NAME\" {' + os.EOL +
        '  zone_id    = local.zone_id.RECORD_ZONE_ID ' + os.EOL +
        '  name   = \"RECORD_NAME\"' + os.EOL +
        '  type    = \"RECORD_TYPE\"' + os.EOL +
        '  value = \"RECORD_VALUE\"' + os.EOL +
        '  proxied = RECORD_PROXIED ' + os.EOL +
        '  ttl = RECORD_TTL' + os.EOL +
        '  priority = \"RECORD_PRIORITY\"' + os.EOL +
        '}' + os.EOL

    for (let i = 0; dnsRecords.result.length > i; i++) {
        const slugName = dnsRecords.result[i].name.replace(`.${dnsRecords.result[i].zone_name}`, '')
        // converts all dots in underscore, dots can not be used as local terraform resource name
        const recordLocalName = `${zoneName}_${dnsRecords.result[i].type}_${slugName}`.split(".").join("_")
        // use local var when ttl is set to 1, which means automatic ttl
        const recordTTL = dnsRecords.result[i].ttl === 1 ? 'local.default_ttl' : dnsRecords.result[i].ttl

        const parsedTemplate = template
            .replace('RECORD_ID', dnsRecords.result[i].id)
            .replace('RECORD_LOCAL_NAME', recordLocalName)
            .replace('RECORD_ZONE_ID', zoneName)
            .replace('RECORD_NAME', slugName)
            .replace('RECORD_TYPE', dnsRecords.result[i].type)
            .replace('RECORD_VALUE', dnsRecords.result[i].content)
            .replace('RECORD_PROXIED', dnsRecords.result[i].proxied)
            .replace('RECORD_TTL', recordTTL)
            .replace('RECORD_PRIORITY', dnsRecords.result[i].priority)

        tfRecords[i] = {
            name: `cloudflare_record.${slugName}`,
            custom_name: `${dnsRecords.result[i].zone_name}/${dnsRecords.result[i].id}`,
            parsedTemplate
        }
        commands.push(`terraform import module.dns.cloudflare_record.${recordLocalName} ${dnsRecords.result[i].zone_id}/${dnsRecords.result[i].id}` + os.EOL)
    }
    fs.writeFile(__dirname + `/records-${zoneName}.tf`, tfRecords.map(record => JSON.stringify(record.parsedTemplate) + os.EOL), 'utf8', (err) => {
        if (err) {
            throw err;
        }
    });
    fs.writeFile(__dirname + `/import-records-${zoneName}.sh`, commands.map(command => command), 'utf8', (err) => {
        if (err) {
            throw err;
        }
    });
}

createFile(dnsRecordsCOM, 'cesarb_dev')
    .then(() => {
    })
    .catch((ex) => console.error(ex))
