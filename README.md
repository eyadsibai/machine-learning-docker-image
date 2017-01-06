Data Science Platform
=====================

How to use
----------

docker-machine create docker -d google --google-project=kaggle-1337 --google-machine-type n1-highmem-8	--google-disk-size "10" --google-disk-type "pd-standard" --preemptible
eval $(docker-machine env docker)
docker run -d -p 8888:8888 xyz start-notebook.sh
# docker ssh then may be git clone or store files over google cloud storage
#

# to copy files to the docker machine
# 1. docker-machine ssh docker
# 2. sudo mkdir -p /myfiles
# docker-machine scp somefile docker:/myfiles

# add 8888 port to the firewall
gcloud compute firewall-rules create allow-8888 --allow tcp:8888

# stop docker machine
docker-machine stop docker
docker-machine start docker

# stop instance
gcloud compute instances stop docker
# reminder ... you still paying for the persistant disk (10 Gb -> 0.4 per month)
# if u want u can delete the docker macihne first then delete the instance then the persistant disk

# gcloud compute firewall-rules delete allow-8888 --quiet


