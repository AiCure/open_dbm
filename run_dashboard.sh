#!/bin/bash

cd dashboard
npm start &
P1=$!


cd flask-server
source venv/Scripts/activate


cd ../..
python visualization_interface/flask-server/server.py $1 $2 &
P2=$!

wait $P1 $P2
