# Copy the target directory here which contains the app
cp -R ../target .
#Start postgres
docker run -d --rm --name postgres --net=host restcrud-db
# Build container
docker build --no-cache --progress=plain --build-arg POPULATE_SCC=false -f Dockerfile_restcrud_openj9 -t openj9_restcrud:J17 .
#docker build --build-arg POPULATE_SCC=false -f Dockerfile_restcrud_openj9 -t openj9_restcrud_nopopulatescc:J17-20251020 .


docker stop postgres
