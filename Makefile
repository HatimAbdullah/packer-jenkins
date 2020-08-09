all: stop start exec

start:
	docker run -it -d \
		--env TF_NAMESPACE=$$TF_NAMESPACE \
		--env AWS_PROFILE="kh-labs" \
		--env AWS_ACCESS_KEY_ID="$$(sed -n 2p creds/credentials | sed 's/.*=//')" \
		--env AWS_SECRET_ACCESS_KEY="$$(sed -n 3p creds/credentials | sed 's/.*=//')" \
		--env OWNER="hatim" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $$PWD:/$$(basename $$PWD) \
		-v jenkins_password:/output \
		-w /$$(basename $$PWD) \
		--name $$(basename $$PWD) \
		--hostname $$(basename $$PWD) \
		bryandollery/terraform-packer-aws-alpine

stop:
	docker rm -f $$(basename $$PWD) 2> /dev/null || true

exec:
	docker exec -it $$(basename $$PWD) bash || true

build:
	time packer build packer.json
	cat /output/jenkins-password.txt

init:
	rm -rf .terraform ssh
	mkdir ssh
	time terraform init
	ssh-keygen -t rsa -f ./ssh/id_rsa -q -N ""

plan:
	time terraform plan -out plan.out

apply:
	time terraform apply plan.out

cnct:
	ssh -i ssh/id_rsa ubuntu@$$(terraform output -json | jq '.lordfish-gateway.value' | xargs) rm -f /home/ubuntu/id_rsa
	scp -i ssh/id_rsa ssh/id_rsa ubuntu@$$(terraform output -json | jq '.lordfish-gateway.value' | xargs):~
	ssh -i ssh/id_rsa ubuntu@$$(terraform output -json | jq '.lordfish-gateway.value' | xargs) chmod 400 /home/ubuntu/id_rsa
	ssh -i ssh/id_rsa ubuntu@$$(terraform output -json | jq '.lordfish-gateway.value' | xargs)

