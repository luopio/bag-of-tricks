# Docker trickery

Removed exited containers except for database stuff:
```
docker ps -a | grep Exited | grep -v -E "postgres|mysql|kafka|zookeeper|postgis|redis|psql|db" | awk '{print $1}' | xargs -n 1 -I {} docker rm {}
```

Remove untagged images
```
docker rmi $( docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)
```

Remove dangling volumes
```
docker volume rm `docker volume ls -q -f dangling=true`
```

...Or just run the spotify cleanup:
```
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc
```

Or use the `docker system prune` commands.
