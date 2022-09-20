import http from 'k6/http';
import { check, group, sleep, fail } from 'k6';
export const options = {
  vus: 1000,
  duration: '30s',
};

export default function () {
  http.get('http://localhost:3000/products/1/styles');
  sleep(1);
}