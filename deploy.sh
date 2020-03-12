# Build images
docker build -t theomjones/multi-client:latest -t theomjones/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t theomjones/multi-server:latest -t theomjones/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t theomjones/multi-worker:latest -t theomjones/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#  Push images
docker push theomjones/multi-client:latest
docker push theomjones/multi-server:latest
docker push theomjones/multi-worker:latest
docker push theomjones/multi-client:$SHA
docker push theomjones/multi-server:$SHA
docker push theomjones/multi-worker:$SHA

# Apply k8s configs
# gcloud already in chage of kubectl from travis file

kubectl apply -f k8s

# imperatively set the images in k8s
kubectl set image deployments/server-deployment server=theomjones/multi-server:$SHA
kubectl set image deployments/client-deployment client=theomjones/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=theomjones/multi-worker:$SHA
