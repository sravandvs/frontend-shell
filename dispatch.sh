source common.sh
app_name=dispatch

echo -e "$color Copy Dispatch Service File $no_color"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "$color Install GoLang $no_color"
dnf install golang -y

app_prerequisites

echo -e "$color Copy Download Application Dependencies $no_color"
go mod init dispatch
go get
go build

echo -e "$color Start Application Service $no_color"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch