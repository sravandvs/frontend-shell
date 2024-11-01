source common.sh
app_name=dispatch

print_heading "Copy Dispatch Service File"
cp dispatch.service /etc/systemd/system/dispatch.service &>>log_file
status_check $?

print_heading "Install GoLang"
dnf install golang -y &>>log_file
status_check $?

app_prerequisites

print_heading "Copy Download Application Dependencies"
go mod init dispatch &>>log_file
go get &>>log_file
go build &>>log_file
status_check $?

print_heading "Start Application Service"
systemctl daemon-reload &>>log_file
systemctl enable dispatch &>>log_file
systemctl restart dispatch &>>log_file
status_check $?