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
            "id": "b4ebba203dea7671b0e1e03ec15ab818",
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
            "created_on": "2022-04-03T10:03:26.386717Z",
            "modified_on": "2022-04-03T10:03:26.386717Z"
        },
        {
            "id": "b2b0b5cb6d40bb8b37d25bd0c6172de4",
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
            "created_on": "2022-04-03T10:03:26.893404Z",
            "modified_on": "2022-04-03T10:03:26.893404Z"
        },
        {
            "id": "3919a61baaa9dffe8175db6cf1b67818",
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
            "created_on": "2022-04-03T10:03:27.09688Z",
            "modified_on": "2022-04-03T10:03:27.09688Z"
        },
        {
            "id": "b70a505c469881c3741665faebf8d880",
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
            "created_on": "2022-04-03T10:03:27.700509Z",
            "modified_on": "2022-04-03T10:03:27.700509Z"
        },
        {
            "id": "686fa25c088a4e1cb54d7d498152878b",
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
            "created_on": "2022-04-03T10:03:30.655107Z",
            "modified_on": "2022-04-03T10:03:30.655107Z"
        },
        {
            "id": "417a20c75300114dd1060d93cc96bfbd",
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
            "created_on": "2022-04-03T10:03:25.786546Z",
            "modified_on": "2022-04-03T10:03:25.786546Z"
        },
        {
            "id": "0d1bedb4c54f935252ee62b768e1b3ff",
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
            "created_on": "2022-04-03T10:03:26.129083Z",
            "modified_on": "2022-04-03T10:03:26.129083Z"
        },
        {
            "id": "788974b545830e8c0a289ef9daf63ed8",
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
            "created_on": "2022-04-03T10:03:28.243754Z",
            "modified_on": "2022-04-03T10:03:28.243754Z"
        },
        {
            "id": "374e1f6f3146c25e1628acc03d645076",
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
            "created_on": "2022-04-03T10:03:25.952091Z",
            "modified_on": "2022-04-03T10:03:25.952091Z"
        },
        {
            "id": "c44387b29508f37ddcc1a6fe34fae2d0",
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
            "created_on": "2022-04-03T10:03:31.137361Z",
            "modified_on": "2022-04-03T10:03:31.137361Z"
        },
        {
            "id": "29479b2ff96e825ea972b144ceda216c",
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
            "created_on": "2022-04-03T10:03:27.445487Z",
            "modified_on": "2022-04-03T10:03:27.445487Z"
        },
        {
            "id": "42e0b3be202cf14634299ecca3723aec",
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
            "created_on": "2022-04-03T10:03:26.723175Z",
            "modified_on": "2022-04-03T10:03:26.723175Z"
        }
    ],
    "success": true,
    "errors": [],
    "messages": [],
    "result_info": {
        "page": 1,
        "per_page": 100,
        "count": 12,
        "total_count": 12,
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
