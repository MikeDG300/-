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

    Создаем директорию по пути /var/tmp/dockerastra

    После выполняем скрипт, который мы написали в директорию sudo ./makeastra /var/tmp/dockerastra
    Выполнится копирование ФС Astra Linux с тем набором программ и модулей, которые мы указали выше
    Если ФС развернулась успешно, в терминале по окончанию процесса будет выведено сообщение - Base system installed successfully
    Переходим в ФС путем команды chroot /var/tmp/dockerastra и можем в ней работать и проверить версию ОС например введя команду cat /etc/astra_version

    rm -rf /var/cache/apt/archives/*.deb
    удаляем скачанные .deb-файлы, чтобы уменьшить образ

    echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    добавляем в список локалей системы русскую и английскую

    locale-gen
    генерируем нужные локали

    update-locale ru_RU.UTF-8
    устанавливаем русскую локаль по умолчанию

    Далее, формируем образ на основе того, что сделали выше. Для этого создаем Dockerfile следующего содержания и помещаем в директорию с нашим проектом:

    FROM astra:175
    COPY ./Python_Hello_World /Python_Hello_World
    EXPOSE 5000
    CMD ["python", "/Python_Hello_World"]

    После этого делаем файл исполняемым sudo chmod +x ./Dockerfile

    Также кладем в директорию проекта наш файл с приложением Python_Hello_World,:

    from flask import Flask

    app = Flask(__name__)

    @app.route('/')
    def hello_world():
    return 'My name is Mikhail Dyakov'

    if __name__ == '__main__':
    app.run(debug=True)
    Импортируем образ, который мы подготовили и настроили в локальный репозиторий Докера. Для этого необходимо подготовить файл со скриптом:

    #!/bin/bash

    tar -C $1 -cpf - . | \
    docker import - $2 \
    --change "ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    --change 'CMD ["/bin/bash"]' \
    --change "ENV LANG=ru_RU.UTF-8"

    Назовем файл dockerimport и положим в ту же директорию, что и остальные файлы.
    chmod +x dockerimport

    sudo ./dockerimport /var/tmp/dockerastra astra:174-orel
    импортируем директорию /var/tmp/dockerastra в виде Docker-образа с именем astra и TAG 175

    Собираем контейнер командой sudo docker build . -t astra:175
    Если контейнер собрался без ошибок, то командой sudo docker image list увидим наш образ на основе ФС системы Astra Linux 1.7.5
    Теперь настал черед запустить и проверить наш контейнер, который запустит нам легкое приложение на Flask
    Запуская контейнер надо помнить о сетевой связанности контейнера и хостовой машины. Поэтому мы конкретно указываем порты при запуске контейнера.
    Я запускал командой sudo docker run -p 5005:5000 astra:175

    ![VirtualBox_Astra-Linux_15_07_2024_15_24_21](https://github.com/user-attachments/assets/92693111-41e1-4b9c-b9b5-2f5dddf3e416)

    Мы видим, что наш контейнер запущен и по ссылке, которую отобразило наше flask-приложение можем перейти на нашу тестовую страницу

    


    ![VirtualBox_Astra-Linux_15_07_2024_15_24_49](https://github.com/user-attachments/assets/efe62057-cec0-44d1-92cf-5a3d00ede0ac)


    Вот так у нас получилось запустить тестовоеприложение на Flask в контейнере на базе Astra Linux 1.7.5

    

