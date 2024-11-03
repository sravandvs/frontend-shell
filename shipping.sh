source common.sh
app_name=shipping

if [ -z "$1" ]; then
  echo Input Rabbitmq Password is missing
  exit 1
fi

MYSQL_ROOT_PASSWORD=$1

maven_setup

print_heading "Install MySQL Client"
dnf install mysql -y &>>$log_file
status_check $?

for sql_file in schema app-user master-data; do
  print_heading "Load SQL File - $sql_file"
  mysql -h mysql.devopsdvs.online -uroot -p$MYSQL_ROOT_PASSWORD </app/db/$sql_file.sql &>>$log_file
  status_check $?
done

print_heading "Restart Shipping Service"
systemctl restart shipping &>>$log_file
status_check $?