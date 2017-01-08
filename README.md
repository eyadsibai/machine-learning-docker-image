Data Science Platform
=====================

How to use
----------
```bash
docker-machine create docker-dsp -d google --google-project={project_name} --google-machine-type n1-highmem-8	--google-disk-size "10" --google-disk-type "pd-standard" --google-preemptible --google-machine-image ubuntu-os-cloud/global/images/family/ubuntu-1404-lts --google-scopes "https://www.googleapis.com/auth/cloud-platform"
```
```bash
eval $(docker-machine env docker-dsp)
```
```bash
docker run -d -p 8888:8888 eyadsibai/docker-dsp start-notebook.sh --NotebookApp.token=''
```

- add 8888 port to the firewall
```bash
gcloud compute firewall-rules create allow-8888 --allow tcp:8888
```

- get the ip address of the machine
```bash
docker-machine ip docker-dsp
```
- open the site http://{docker-machine ip docker-dsp}:8888
- stop docker machine
```
docker-machine stop docker-dsp
docker-machine start docker-dsp
```

- delete instance
```
docker-machine delete docker-dsp
```

###Note
when you stop the machine, it would cost you nothing except for the disk that you have it attached. For Google cloud (10GB of disk would cost ~0.4$/month)

TODO
----
- access local files
- install vw and xgboots command line
- install other command lines packages
- configs for matplotlib and others
