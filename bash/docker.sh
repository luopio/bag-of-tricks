# removed exited containers except for database stuff
docker ps -a | grep Exited | grep -v -E "postgres|mysql|kafka|zookeeper|postgis|redis" | awk '{print $1}' | xargs -n 1 -I {} docker rm {}

# remove untagged images
docker rmi $( docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)

# remove dangling volumes
docker volume rm `docker volume ls -q -f dangling=true`


# or just run the spotify cleanup:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc

