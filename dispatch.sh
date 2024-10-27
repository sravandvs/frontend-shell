echo -e "\e[33m Copy Dispatch Service File \e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[33m Install GoLang \e[0m"
dnf install golang -y

echo -e "\e[33m Add Application User \e[0m"
useradd roboshop

echo -e "\e[33m Create Application Directory \e[0m"
mkdir /app

echo -e "\e[33m Download Application Directory \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip
cd /app

echo -e "\e[33m Extract Application Content \e[0m"
unzip /tmp/dispatch.zip
cd /app

echo -e "\e[33m Copy Download Application Dependencies \e[0m"
go mod init dispatch
go get
go build

echo -e "\e[33m Start Application Service \e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch