SHELL	 = /bin/bash

cnf ?= .env
ifneq ($(shell test -e $(cnf) && echo -n yes),yes)
	ERROR := $(error $(cnf) file not defined in current directory)
endif

include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

ifneq ($(shell test -e $(INCLUDE_MAKEFILE) && echo -n yes),yes)
	ifdef REMOTE_MAKEFILE
		REMOTE_MAKEFILE_RESULT := $(shell curl ${REMOTE_MAKEFILE} -o ${INCLUDE_MAKEFILE})
	else
		ERROR := $(error REMOTE_MAKEFILE not provided, look for your .env file)
	endif
endif

ifdef INCLUDE_MAKEFILE
	include ${INCLUDE_MAKEFILE}
endif

build: plan
deploy: apply

auth-create-sa: ## 1: create sa
	gcloud iam service-accounts create ${GCP_TERRAFORM_SA} \
		--project ${GCP_PROJECT} \
		--description="Terraform Service Account" \
		--display-name="Terraform Service Account"

auth-create-iam-policy: ## 2: create policy
	gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
    --member=serviceAccount:${GCP_TERRAFORM_SA}@${GCP_PROJECT}.iam.gserviceaccount.com \
    --role=roles/compute.instanceAdmin.v1
	gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
    --member=serviceAccount:${GCP_TERRAFORM_SA}@${GCP_PROJECT}.iam.gserviceaccount.com \
    --role=roles/compute.securityAdmin
	gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
    --member=serviceAccount:${GCP_TERRAFORM_SA}@${GCP_PROJECT}.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

auth-create-iam-policy-delete: ## 2: create policy
	gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
    --member=serviceAccount:${GCP_TERRAFORM_SA}@${GCP_PROJECT}.iam.gserviceaccount.com \
    --role=roles/compute.networkAdmin


auth-create-creds-file: ## 3: generate creds file
	gcloud iam service-accounts \
		keys create key.json \
		--iam-account=${GCP_TERRAFORM_SA}@${GCP_PROJECT}.iam.gserviceaccount.com
