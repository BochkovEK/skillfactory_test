В рамках данного задания на ВМ машине были подняты gitlab и gitlab-runner в docker контейнерах.
Был создан докер образ для исполнения ansible playbooks. Из данного образа gitlab-runner поднимает ansible-docker-runner.
В gitlab создан проект в котром собраны ci, ansible playbook и скрипты проверки.