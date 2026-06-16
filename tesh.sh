import http from 'k6/http';
import { check } from 'k6';

export let options = {
  scenarios: {
    steady: {
      executor: 'constant-arrival-rate',
      rate: 50000,            // target RPS for THIS process
      timeUnit: '1s',
      duration: '10m',
      preAllocatedVUs: 2000,
      maxVUs: 8000,
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.02'],
  },
};

export default function () {
  const url = __ENV.TARGET_URL || 'https://d3vo.ru/';
  const payload = 'x'.repeat(500); // 500 bytes
  const params = {
    headers: { 'Content-Type': 'application/octet-stream' },
  };
  const res = http.post(url, payload, params);
  check(res, { 'status 200': (r) => r.status === 200 });
}
