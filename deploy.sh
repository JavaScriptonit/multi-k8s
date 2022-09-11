#after_success:
#  - docker build -t javascriptonit/multi-client ./client
#  - docker build -t javascriptonit/multi-nginx ./nginx
#  - docker build -t javascriptonit/multi-server ./server
#  - docker build -t javascriptonit/multi-worker ./worker
#  # Log in to the Docker CLI
#  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
#  # Take those images and push them to Docker hub
#  - docker push javascriptonit/multi-client
#  - docker push javascriptonit/multi-nginx
#  - docker push javascriptonit/multi-server
#  - docker push javascriptonit/multi-worker

docker build -t javascriptonit/multi-client:latest -t javascriptonit/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t javascriptonit/multi-server:latest -t javascriptonit/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t javascriptonit/milti-worker:latest -t javascriptonit/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push javascriptonit/multi-client:latest
docker push javascriptonit/multi-server:latest
docker push javascriptonit/multi-worker:latest

docker push javascriptonit/multi-client:$SHA
docker push javascriptonit/multi-server:$SHA
docker push javascriptonit/multi-worker:$SHA

nubectl apply -f k8s
kubectl set image deployments/client-deployment client=javascriptonit/multi-client:$SHA
kubectl set image deployments/server-deployment server=javascriptonit/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=javascriptonit/multi-worker:$SHA
