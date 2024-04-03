#!/usr/bin/env node

const crypto = require('crypto');
const fs = require('fs');
const url = require('url');

const outfile = process.argv[2];
const packageinfo = JSON.parse(fs.readFileSync('package.json'));
const appinfo = JSON.parse(fs.readFileSync('appinfo.json'));
const ipkfile = `${appinfo.id}_${appinfo.version}_all.ipk`;
const ipkhash = crypto.createHash('sha256').update(fs.readFileSync(ipkfile)).digest('hex');

fs.writeFileSync(
  outfile,
  JSON.stringify({
    id: appinfo.id,
    version: appinfo.version,
    type: appinfo.type,
    title: appinfo.title,
    appDescription: appinfo.appDescription,
    iconUri: `https://raw.githubusercontent.com/${url.parse(packageinfo.repository.url).path.substring(1)}/main/assets/icon130.png`,
    sourceUrl: packageinfo.repository.url,
    rootRequired: true,
    ipkUrl: ipkfile,
    ipkHash: {
      sha256: ipkhash,
    },
  }),
);
