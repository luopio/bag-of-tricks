# removed exited containers
docker ps -a | grep Exited | awk '{print $1}' | xargs -n 1 -I {} docker rm {}

# remove untagged images
docker rmi $( docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)

# or just run the spotify cleanup:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc

