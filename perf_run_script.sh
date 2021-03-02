#!/bin/bash
set -e

scripts_directory=/Users/mjain36/repo/prj/webflux-basic-api/testing/taurus_script/input_dir/
artifacts_directory=/Users/mjain36/repo/prj/webflux-basic-api/testing/taurus_script/output_dir/
filename=test.yaml

docker run \
  --rm \
  -v ${scripts_directory}:/bzt-configs \
  -v ${artifacts_directory}:/tmp/artifacts \
  blazemeter/taurus $filename