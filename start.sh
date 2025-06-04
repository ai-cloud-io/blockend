#!/bin/bash
npx hardhat node &
echo "Waiting for Hardhat node to be ready..."
while ! nc -z localhost 8545; do
  sleep 1
done
npx hardhat run scripts/deploy.ts --network localhost

tail -f /dev/null