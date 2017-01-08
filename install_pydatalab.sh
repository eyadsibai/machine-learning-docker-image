#!/usr/bin/env bash
git clone https://github.com/googledatalab/pydatalab.git
cd pydatalab
tsc --module amd --noImplicitAny --outdir datalab/notebook/static datalab/notebook/static/*.ts
pip install . --no-deps
jupyter nbextension install --py datalab.notebook --sys-prefix
rm datalab/notebook/static/*.js
cd ..
rm -rf pydatalab
# TODO should install with pip and not install its dependencies
