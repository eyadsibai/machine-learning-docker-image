Data Science Platform
=====================

How to use
----------
```
docker-machine create docker-dsp -d google --google-project={project_name} --google-machine-type n1-highmem-8	--google-disk-size "10" --google-disk-type "pd-standard" --google-preemptible --google-machine-image ubuntu-os-cloud/global/images/family/ubuntu-1404-lts --google-scopes "cloud-platform"
```
```
eval $(docker-machine env docker-dsp)
```
```
docker run -d -p 8888:8888 eyadsibai/docker-dsp start-notebook.sh --NotebookApp.token=''
```

- add 8888 port to the firewall
```
gcloud compute firewall-rules create allow-8888 --allow tcp:8888
```
- stop docker machine
```
docker-machine stop docker-dsp
docker-machine start docker-dsp
```

- delete instance
```
docker-machine delete docker-dsp 
```
