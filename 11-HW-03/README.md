В рамках данного задания на ВМ машине были подняты gitlab и gitlab-runner в docker контейнерах.
Был создан докер образ для исполнения ansible playbooks. Из данного образа gitlab-runner поднимает ansible-docker-runner.
В gitlab создан проект в котром собраны ci, ansible playbook и скрипты проверки.
В результате пайплайн представлен 4 джобами: создание nginx контейнера с кастомной index.html, проверка кода отклика, проверка мд суммы страницы, удаление контейнера.
По итогам пайплайна отправляется пуш уведомление в телеграм. Так же при неудачных проверках кода отклика и контрольной суммы отрпавляются пуш уведомления в телеграм.
