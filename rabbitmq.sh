#cp rabbitmq.service /etc/systemd/system/rabbitmq.service
cp rabbitmq.service /etc/yum.repos.d/rabbitmq.service

dnf install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"