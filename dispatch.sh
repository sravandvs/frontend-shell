source common.sh
app_name=dispatch

echo -e "$color Copy Dispatch Service File $no_color"
cp dispatch.service /etc/systemd/system/dispatch.service &>>log_file
echo $?

echo -e "$color Install GoLang $no_color"
dnf install golang -y &>>log_file
echo $?

app_prerequisites

echo -e "$color Copy Download Application Dependencies $no_color"
go mod init dispatch &>>log_file
go get &>>log_file
go build &>>log_file
echo $?

echo -e "$color Start Application Service $no_color"
systemctl daemon-reload &>>log_file
systemctl enable dispatch &>>log_file
systemctl restart dispatch &>>log_file
echo $