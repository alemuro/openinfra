build:
	terraform apply -auto-approve

build-force:
	terraform taint spotinst_elastigroup_aws.instance
	terraform apply -auto-approve

clean: 
	rm -rf .terraform