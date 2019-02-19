Add the emails to the terraform.auto.tfvars file.
```
emails = [
  "me@example.org",
  "you@example.org"
]
```

Create the environment.
```
terraform init
terraform apply -auto-approve
```

Users can then log in to their GCP account and they should see a project called `workshop-<id>`.

When opening the Cloud Shell they should then configure gcloud to point at their GKE cluster.
```
gcloud config set compute/zone europe-west1-b
gcloud container clusters get-credentials cluster
```