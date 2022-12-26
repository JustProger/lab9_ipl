## Запуск проекта и тестов

Для того чтобы запустить данный проект локально надо выполнить следующие пункты
1. Клонирование проекта 

	Склонировать проект из репозитория с помощью команды:
	```console
	git clone git@github.com:JustProger/lab9_ipl.git
	```

	или (если не настроен ssh-ключ в личном аккаунте на github):

	```console
	git clone https://github.com/JustProger/lab9_ipl.git
	```

2. Запуск приложения 

	После успешного клонирования надо перейти в корневую директорию проекта и установить зависимости проекта:
	```console
	bundle install
	```

	После этого можно запускать проект:
	```console
	rails s
	```

3. Запуск тестов

	Чтобы запустить все тесты сразу:
	```console
	rspec
	```

	Чтобы запускать тесты контроллера/модели/системные отдельно:
	```console
	rspec spec/requests/calculator_spec.rb
	rspec spec/models/calculator_result.rb
	rspec spec/system/calculator_spec.rb
	```
