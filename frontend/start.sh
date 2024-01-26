#!/bin/bash

# new_velo  = 6
# sed -i "s/const ballVelocity = [0-9]*;/const ballVelocity = $new_velo;/" ./server/app.js

cd ./server
npm run start &

cd ../client
npm run serve &
