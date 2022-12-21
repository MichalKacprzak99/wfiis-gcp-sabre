# wfiis-gcp-sabre

## Table of Contents
 * [Description](#description)
 * [GCP Architecture](#gcp-architecture)
 * [Possible updates for future](#possible-updates-for-future)

## Description

The goal of the project is to create a service that monitors the appearance of new episodes of selected anime on a specific website.

## GCP Architecture

![GCP Architecture](docs/architecture_project_v2.png)

## How to deploy on GCP using Terraform
+ Fork this repository
+ Create GCP Project
+ Setup Cloud SQL Auth proxy - https://cloud.google.com/sql/docs/mysql/sql-proxy
+ Set correct project in gcloud - `gcloud config set project {PROJECT_ID}`
+ Enable Google APIs(through GCP Console or gcloud) - gcloud command ```gcloud services enable sqladmin.googleapis.com run.googleapis.com cloudbuild.googleapis.com containerregistry.googleapis.com storage.googleapis.com cloudscheduler.googleapis.com logging iam.googleapis.com```:
  * Cloud SQL - sqladmin.googleapis.com
  * Cloud Storage - storage.googleapis.com
  * Cloud Run - run.googleapis.com
  * Cloud Build - cloudbuild.googleapis.com
  * Container Registry - containerregistry.googleapis.com
  * Cloud Scheduler cloudscheduler.googleapis.com
  * Identity and Access Management (IAM) API - iam.googleapis.com
  * Cloud Logging - logging
+ Dockerize app and push image to Container Registry:
  + `gcloud auth configure-docker {CONTAINER_REGISTER_HOSTNAME}`
  + `cd src/api/`
  + `docker build -t {CONTAINER_REGISTER_HOSTNAME}/{PROJECT_ID}/{CLOUD_RUN_NAME} .`
  + `docker push {CONTAINER_REGISTER_HOSTNAME}/{PROJECT_ID}/{CLOUD_RUN_NAME}`
+ connect GitHub repository to enable creating GCP Build triggers. Go to https://console.cloud.google.com/cloud-build/triggers/connect?project={PROJECT_ID} and click on "Connect Repository" button and follow instructions.
+ Create GCP infrastructure using Terraform, variables provided for terraform must match all previously used variables({VARIABLE_NAME}):
  + `cd terraform/`
  + `terraform init`
  + `terraform validate`
  + `terraform plan`
  + `terraform apply`
+ Create required tables in created SQL Database:
  + Create new env variable: ```export SQLALCHEMY_DATABASE_URL=mysql+pymysql://{DB_USER_NAME}:{DB_USER_PASSWORD}@127.0.0.1:5432/{DB_NAME}```
  + Connect to Cloud SQL through proxy - ```gcloud proxy cloud_sql_proxy -instances="{PROJECT_ID}:{PROJECT_REGION}:{DB_INSTANCE_NAME}"=tcp:5432```
  + Keep terminal with proxy open and open another in repo root folder and execute following commands:
    + `cd src/api/`
    + `pip install -r requirements.txt`
    + `alembic revision --autogenerate`
    + `alembic upgrade head`
+ Cloud Run service url should be displayed as output value if no go to GCP Console to Cloud Run to get service url
+ Add new anime(example data below) to monitor through swagger docs:

```json
{
  "name": "Blue Lock",
  "website_url": "https://bluelock.wbijam.pl/"
}
```

### Notes 
  * After `terraform destroy` step "Create required tables in created SQL Database" must be repeated

## Possible updates for future
 * automatize app dockerize
 * migrate from container registry to artifact registry
 * optimize docker