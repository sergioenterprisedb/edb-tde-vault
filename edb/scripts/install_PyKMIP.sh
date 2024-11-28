#!/bin/bash

cd /tmp/
wget https://files.pythonhosted.org/packages/f8/3e/e343bb9c2feb2a793affd052cb0da62326a021457a07d59251f771b523e7/PyKMIP-0.10.0.tar.gz
tar -xvf PyKMIP-0.10.0.tar.gz
cd /tmp/PyKMIP-0.10.0/
python3 setup.py install
