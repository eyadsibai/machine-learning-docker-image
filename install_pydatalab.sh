#!/usr/bin/env bash
git clone https://github.com/googledatalab/pydatalab.git
cd pydatalab
./install-virtualenv.sh  # For use in Python virtual environments
# TODO should install with pip and not install its dependencies