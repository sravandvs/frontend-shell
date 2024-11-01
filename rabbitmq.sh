source common.sh
app_name=rabbitmq

print_heading "Copy RabbitMQ Repo file"
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
status_check $?

print_heading "Install RabbitMQ Server"
dnf install rabbitmq-server -y &>>$log_file
status_check $?

print_heading "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
status_check $?

print_heading "Add Application User"
rabbitmqctl add_user roboshop roboshop123 &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
status_check $?
