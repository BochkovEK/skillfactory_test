1) Start on remote host:
ansible-playbook playbook.yml
2) Start build.sh from build_python3_docker_image folder от postgresql host
    - build docker image python3-flask:mytag
    - run docker from python3-flask:mytag

build_python3_docker_image/app - app folder
build_python3_docker_image/build.sh - - build docker image and run docker from python3-flask:mytag
build_python3_docker_image/source.bash - env variables
