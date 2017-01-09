#!/usr/bin/env bash
git clone https://github.com/googledatalab/pydatalab.git
cd pydatalab
pip install futures>=3.0.5
pip install google-cloud
pip install . --no-deps
cd ..
rm -rf pydatalab