from bryandollery/terraform-packer-aws-alpine
copy packer.json /src/
copy provision.sh /src/
copy creds/config /src/config/
entrypoint ["/bin/bash", "-c"]
