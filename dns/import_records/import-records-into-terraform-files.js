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
            "id": "50fabd62a45174aa9381a80edda90fb1",
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
            "created_on": "2022-05-01T11:21:19.841495Z",
            "modified_on": "2022-05-01T11:21:19.841495Z"
        },
        {
            "id": "4738881d60cd7d9f7e39d4c31bb8e7cd",
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
            "created_on": "2022-05-01T11:21:16.902733Z",
            "modified_on": "2022-05-01T11:21:16.902733Z"
        },
        {
            "id": "5f8df9659e89b46327aa66864f7cedb8",
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
            "created_on": "2022-05-01T11:21:20.376255Z",
            "modified_on": "2022-05-01T11:21:20.376255Z"
        },
        {
            "id": "12fb64e8089e657415aab281aff62425",
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
            "created_on": "2022-05-01T11:21:24.349374Z",
            "modified_on": "2022-05-01T11:21:24.349374Z"
        },
        {
            "id": "21cf286e8fdc613f0bd4df709d4f7949",
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
            "created_on": "2022-05-01T11:21:25.348113Z",
            "modified_on": "2022-05-01T11:21:25.348113Z"
        },
        {
            "id": "902ce18d8d5fceed612ba77a4fa51c1d",
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
            "created_on": "2022-05-01T11:21:16.620096Z",
            "modified_on": "2022-05-01T11:21:16.620096Z"
        },
        {
            "id": "4964b716ebab55755f3f70ea7146f930",
            "zone_id": "b8991a88e1b412fa8a94e7e2808b0cfa",
            "zone_name": "cesarb.dev",
            "name": "test.cesarb.dev",
            "type": "CNAME",
            "content": "74cba19543fd017e8f7b8df22ffad823.m.pipedream.net",
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
            "created_on": "2022-05-01T15:21:11.351115Z",
            "modified_on": "2022-05-01T15:21:11.351115Z"
        },
        {
            "id": "5b64e68c22d6d0da002a959ca9d3c62e",
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
            "created_on": "2022-05-01T11:21:22.85226Z",
            "modified_on": "2022-05-01T11:21:22.85226Z"
        },
        {
            "id": "d89ded09ea53f6b6a9fd9effcd81d950",
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
            "created_on": "2022-05-01T11:21:24.855512Z",
            "modified_on": "2022-05-01T11:21:24.855512Z"
        },
        {
            "id": "dd12cb1c11aa6d6d960ae36420c8c7bb",
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
            "created_on": "2022-05-01T11:21:21.599875Z",
            "modified_on": "2022-05-01T11:21:21.599875Z"
        },
        {
            "id": "493a7bb13855ecb754ba03d1e7fef6c8",
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
            "created_on": "2022-05-01T11:21:23.861368Z",
            "modified_on": "2022-05-01T11:21:23.861368Z"
        },
        {
            "id": "e76f1fbf6f574c9636a33175f013b30f",
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
            "created_on": "2022-05-01T11:21:16.408355Z",
            "modified_on": "2022-05-01T11:21:16.408355Z"
        },
        {
            "id": "b4ca1c2af778b9908fbde9d3a76e883a",
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
            "created_on": "2022-05-01T11:21:17.11509Z",
            "modified_on": "2022-05-01T11:21:17.11509Z"
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
        '  zone_id    = local.cloudflare_zone_id ' + os.EOL +
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
