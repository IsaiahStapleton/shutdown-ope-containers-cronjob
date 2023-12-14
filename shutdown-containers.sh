#!/bin/bash


set_time="1 minutes"

time_limit=$(($(date -u +"%s") - $(date -d "-$set_time" +%s)))

running_notebooks=$(oc get notebook -o custom-columns=:metadata.name)

for notebook in $running_notebooks; do

	start_time=$(oc get notebook $notebook -o jsonpath='{.status.containerState.running.startedAt}')
		
	running_time=$(($(date -u +"%s") - $(date -u -d "$start_time" +"%s")))
	
	if [ "$running_time" -gt "$time_limit" ]; then
		echo "Shutting down pod $notebook"
		oc delete notebook $notebook
		oc delete pvc $notebook
	fi 
done
