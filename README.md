# -
Материалы для воспроизведения тестовой страницы python используя контейнер из образа Astra 1.7.5.9
Для работы понадобится скачать следующие пакеты: git, debootstrap, python, docker.io в случае с контейнером на базе Astra Linux необходимо установить пакеты python-flask, python-pip.

1. Создаем будущий образ посредством копирования ФС системы Astra Linux через bootstrap:

sudo apt install debootstrap - скачиваем пакет
далее, правим файл /etc/apt/sourses.list, раскомментируем репозитории:
#deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64  main contrib non-free
#deb  https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free

Далее, создаем скрипт в домашней директории ./makeastra:

#!/bin/bash

debootstrap \
    --include ncurses-term,python-flask,python-pip,locales,nano,gawk,lsb-release,acl,perl-modules-5.28 \
    --components=main,contrib,non-free 1.7_x86-64 \
    $1 \
    http://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base

    Делаем скрипт исполняемым посредством команды - sudo chmod +x ./makeastra

    Создаем директорию по пути /var/tmp/makeastra

    После выполняем скрипт, который мы написали в директорию sudo ./makeastra /var/tmp/makeastra
    Выполнится копирование ФС Astra Linux с тем набором программ и модулей, которые мы указали выше
    Если ФС развернулась успешно, в терминале по окончанию процесса будет выведено сообщение - Base system installed successfully
    Переходим в ФС путем команды chroot /var/tmp/makeastra и можем в ней работать и проверить версию ОС например введя команду cat /etc/astra_version

    rm -rf /var/cache/apt/archives/*.deb
    удаляем скачанные .deb-файлы, чтобы уменьшить образ

    echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    добавляем в список локалей системы русскую и английскую

    locale-gen
    генерируем нужные локали

    update-locale ru_RU.UTF-8
    устанавливаем русскую локаль по умолчанию

    

    

