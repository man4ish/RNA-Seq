# RNASeq
## Build and push docker image
sh docker_build.sh 

## Validating wdl file
java -jar bin/womtool-59.jar validate RnaSeq.wdl

## Generating input.json for workflow
java -jar bin/womtool-59.jar inputs RnaSeq.wdl > input.json

## Running wdl locally on cromwell engine
java -jar bin/cromwell-58.jar run RnaSeq.wdl --inputs input.json

## RUN rnaseq app on dnanexus platform
sh run_rnaseq.sh <folder name> 

# Related Links 
### Reference for WDL docs: 
### https://github.com/openwdl/wdl/blob/main/versions/1.0/SPEC.md
### https://dockstore.org/
### https://docs.docker.com/docker-hub/
### https://github.com/gatk-workflows/
### https://github.com/openwdl/learn-wdl

