source common.sh
app_name=mongodb

print_heading "Copy MongoDB repo"
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file
status_check $?

print_heading "Install MongoDB Server"
dnf install mongodb-org -y &>>$log_file
status_check $?

print_heading "Update MongoDB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$log_file
status_check $?

print_heading "Start MongoDB service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
status_check $?