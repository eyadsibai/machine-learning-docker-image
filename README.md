Machine Learning/Data Science Platform (Docker Image)
=====================

Requirements
------------

- docker
- docker-machine (to deploy to google cloud)

How to use (in Google Cloud)
----------------------------

```bash
docker-machine create docker-dsp -d google --google-project={project_id} --google-machine-type n1-highmem-8	--google-disk-size "10" --google-disk-type "pd-standard" --google-preemptible --google-machine-image ubuntu-os-cloud/global/images/family/ubuntu-1404-lts --google-scopes "https://www.googleapis.com/auth/cloud-platform"
```

```bash
eval $(docker-machine env docker-dsp)
```

```bash
docker run -d -p 8888:8080 -e "PROJECT_ID={project_id}" eyadsibai/docker-dsp start.sh jupyter lab --NotebookApp.token=''
```

- get the ip address of the machine

```bash
docker-machine ip docker-dsp
```

- open the site http://{docker-machine ip docker-dsp}:8080
- to stop the machine

```bash
docker-machine stop docker-dsp
docker-machine start docker-dsp
```

- to delete the instance

```bash
docker-machine rm docker-dsp
```

### Note
when you stop the machine, it would cost you nothing except for the disk that you have it attached. For Google cloud (10GB of disk would cost ~0.4$/month)


How to use (Locally)
--------------------

```bash
docker run -d -p 8888:8888 -v <local path>:/home/jovyan/work eyadsibai/docker-dsp start.sh jupyter lab --NotebookApp.token=''
```

TODO
----

- write a better readme (Why? and How?)
- access local files (whether running locally or on google machine)
- install caffe
- install vw and xgboots command line
- install other command lines packages
- configs for matplotlib and others
