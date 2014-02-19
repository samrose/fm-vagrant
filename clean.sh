#!/bin/bash
if [ -e .vagrantfile ]
  then
    echo ".vagrantfile still exists. "
    echo "First run vagrant destroy if you want to create a new environment."
    exit
fi
rm Vagrantfile
rm manifests/nodes.pp
rm fabfile.py
rm fabfile.pyc
