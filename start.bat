@echo off
cd ygopro-server/redis
start redis-server.exe
cd ..
node.exe ygopro-server.js
