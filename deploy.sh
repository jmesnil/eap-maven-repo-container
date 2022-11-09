#!/bin/bash

REPO_ZIP=${1}

OCP_IMAGE_REGISTRY=$(oc registry info)
OCP_NAMESPACE=$(oc project -q)
OCP_IMAGE=${OCP_IMAGE_REGISTRY}/${OCP_NAMESPACE}/eap-maven-repo

echo "Building container image eap-maven-repo "
docker build  --build-arg REPO_ZIP=${REPO_ZIP} -t eap-maven-repo .

echo "Login to ${OCP_IMAGE_REGISTRY}"
oc registry login
docker login  -u openshift -p $(oc whoami -t) ${OCP_IMAGE_REGISTRY}

echo "Pushing ${OCP_IMAGE}"
docker tag eap-maven-repo ${OCP_IMAGE}
docker push ${OCP_IMAGE}

echo "OCP Image stream for the EAP maven repo"
oc get imagestreamtag eap-maven-repo:latest

echo "Deploy the EAP Maven repo"
oc delete deployment eap-maven-repo || true
oc delete service eap-maven-repo || true
oc new-app --name eap-maven-repo --image-stream=eap-maven-repo

echo ""
echo "You can access this EAP Maven repository inside the OpenShift cluster with the URL"
echo ""
echo "http://eap-maven-repo.${OCP_NAMESPACE}.svc.cluster.local:8080"
echo ""