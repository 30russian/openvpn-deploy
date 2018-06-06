# На сервере
1. Устанавливаем необходимые пакеты

		apt install openvpn easy-rsa iptables

15. Создаём необходимые директории и символические ссылки:

		mkdir -p /root/keys/ && ln -s /root/keys/ /usr/share/easy-rsa/

20. Создаём CA и генерируем ключи

		cd /usr/share/easy-rsa/
		./vars
		./clean-all
		./build-ca
		./build-key-pass 30russian
		./build-key-server server
		./build-dh

30. Создаём ключ для HMAC-аутентификации

		openvpn --genkey --secret ta.key

40. Копируем необходимые ключи в /etc/openvpn:

		cp ca.crt /etc/openvpn/
		cp dh2048.pem /etc/openvpn/
		cp server.crt /etc/openvpn/
		cp server.key /etc/openvpn/
		cp ta.key /etc/openvpn/

45. Клонируем репозиторий

		git clone https://github.com/30russian/openvpn-deploy.git

48. Копируем конфиги:

		cp openvpn-deploy/cur_configs/server.conf /etc/openvpn/

50. Включаем форвардинг пакетов

		echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf && sysctl -p

60. Включаем динамический snat:

		iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE

70. Запускаем OpenVPN-сервер:

		sudo systemctl start openvpn@server
		sudo systemctl status openvpn@server

---

# На клиенте (с нуля)

1. Устанавливаем необходимые пакеты

		apt install openvpn

20. Делаем конфиг:

	* С нуля

		10. Копируем пример конфига

				cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/

		20. Вносим необходимые изменения:

				echo "dh dh2048.pem" >> /etc/openvpn/client.conf
				echo "cipher AES-128-CBC" >> /etc/openvpn/client.conf

	* Из репозитория:
		10. Клонируем репозиторий

				git clone https://github.com/30russian/openvpn-deploy.git

		20. Копируем конфиги:

				cp openvpn-deploy/cur_configs/clientlinux.conf /etc/openvpn/client.conf

40. Копируем необходимые ключи (необходимо предварительно скопировать их с сервера) в /etc/openvpn:

		cp ca.crt /etc/openvpn/
		cp dh2048.pem /etc/openvpn/
		cp server.crt /etc/openvpn/
		cp ta.key /etc/openvpn/
		cp 30russian.crt /etc/openvpn/
		cp 30russian.key /etc/openvpn/

50. Запускаем:

		cd /etc/openvpn
		sudo openvpn --config client.conf

---

# Использование ovpn

1. На сервере клонируем репозиторий

		git clone https://github.com/30russian/openvpn-deploy.git

20. Копируем скрипты:

		cp -r openvpn-deploy/client-configs /root/keys/

30. Генерируем ovpn-файл:

		cd /root/keys/client-configs/

	* Для UNIX-клиентов:

			./mkovpn.sh 30russian linux

	* Для Windows-клиентов:

			./mkovpn.sh 30russian

---

# Доп. источники

* <https://www.digitalocean.com/community/tutorials/openvpn-ubuntu-16-04-ru>
* <https://toster.ru/q/34551>
* <https://www.hostinger.ru/rukovodstva/iptables-zaschita-vps-na-ubuntu-mezhsetevim-ekranom-linux/>

# TBD:
* Сделать постоянные правила iptables
* Сделать Ansible deploy
