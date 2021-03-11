docker-clean-images()
{
    # If there are dangling docker images, remove them
	if [[ $(docker images -a --filter=dangling=true -q) ]];
    then
		tput setaf 3; docker rmi $(docker images -a --filter=dangling=true -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no dangling images.\n"
    fi
}

docker-clean-ps()
{
    # If there are stopped containers, remove them
	if [[ $(docker ps --filter=status=exited --filter=status=created -q) ]];
    then
		tput setaf 3; docker rm $(docker ps --filter=status=exited --filter=status=created -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no stopped containers.\n"
    fi
}

