TAGS="${TAG_LIST:=latest}"
echo "TAGS=$TAGS"
echo "ECR_REPOSITORY=$ECR_REPOSITORY"
MANIFEST=$(aws ecr batch-get-image --repository-name $ECR_REPOSITORY --image-ids imageTag=master --output json | jq --raw-output --join-output '.images[0].imageManifest')

for tag in ${TAGS//,/ }
do
    fixed_tag=$(echo $tag | sed 's/[^a-zA-Z0-9]/-/g')
    command="aws ecr put-image --repository-name $ECR_REPOSITORY --image-tag $fixed_tag --image-manifest $MANIFEST"
    echo "$command"
    $command
done

