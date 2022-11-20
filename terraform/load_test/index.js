import http from 'k6/http';
import {expect} from 'https://jslib.k6.io/k6chaijs/4.3.4.1/index.js';
import {group} from 'k6';

export const options = {
    thresholds: {
        http_req_duration: ['p(99)<1500'], // 99% of requests must complete below 1.5s
    },
};

const URL = '${target_url}';

export default () => {
    const auth_request_options = {
        headers: {
            "content-type": "application/json"
        },
    }

    group('MyVanMoof', () => {
        const responses = http.batch([
            ['GET', URL, null, null],
        ]);
        responses.forEach(response => {
            expect(response.status, "response status").to.equal(200);
        });
    });
};
