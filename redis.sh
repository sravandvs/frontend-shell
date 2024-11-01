source common.sh
app_name=redis

print_heading "Disable Default Redis"
dnf module disable redis -y &>>$log_file
status_check $?

print_heading "Enable Redis 7 Version"
dnf module enable redis:7 -y &>>$log_file
status_check $?

print_heading "Install Redis"
dnf install redis -y &>>$log_file
status_check $?

print_heading "Update Redis Listen address and Disable Protection"
sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$log_file
status_check $?

print_heading "Start Redis Service"
systemctl enable redis &>>$log_file
systemctl start redis &>>$log_file
status_check $?