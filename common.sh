color="\e[33m"
no_color="\e[0m"
log_file=/tmp/roboshop.log
rm -f $log_file

app_prerequisites() {
print_heading "Add Application User"
id roboshop &>>log_file
if [ $? -ne 0 ]; then
  useradd roboshop &>>$log_file
fi
status_check $?

print_heading "Create Application Directory"
rm -rf /app &>>log_file
mkdir /app &>>log_file
status_check $?

print_heading "Download Application Content"
curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>log_file
status_check $?

cd /app

print_heading "Extract Application Content"
unzip /tmp/$app_name.zip &>>log_file
status_check $?
}

print_heading() {
  echo -e "$color $1 $no_color" &>>Slog_file
  echo -e "$color $1 $no_color"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[32m FAILURE \e[0m"
    exit 1
  fi
}

systemd_setup() {

 print_heading "Copy the Service File"
 cp $scripts_path/$app_name.service /etc/systemd/system/$app_name.service
 status_check $?

 print_heading "Start Application Service File"
  systemctl daemon-reload &>>$log_file
  systemctl enable $app_name &>>$log_file
  systemctl restart $app_name &>>$log_file
  status_check $?
}

nodejs_setup() {
  print_heading "Disable Default NodeJS"
  dnf module disable nodejs -y &>>$log_file
  status_check $?


  print_heading "Enable Default NodeJS 20"
  dnf module enable nodejs:20 -y &>>$log_file
  status_check $?


  print_heading "Install NodeJS"
  dnf install nodejs -y &>>$log_file
  status_check $?


  app_prerequisites

  cd /app

  print_heading "Install NodeJS Dependencies"
  npm install &>>$log_file
  status_check $?

  systemd_setup

}

python_setup() {

  print_heading "Install Python"
  dnf install python3 gcc python3-devel -y
  status_check $?

  app_prerequisites

  print_heading "Download Application Dependencies"
  pip3 install -r requirements.txt
  status_check $?

systemd_setup
}

maven_setup() {

  print_heading "Install Maven"
  dnf install maven -y &>>$log_file
  status_check $?

  app_prerequisites

  print_heading "Download Application Dependencies"
  mvn clean package &>>$log_file
  mv target/$app_name-1.0.jar $app_name.jar &>>$log_file
  status_check $?

  print_heading "Install MySQL Client"
  dnf install mysql -y &>>$log_file
  status_check $?

  for sql_file in schema app-user master-data; do
   print_heading "Load SQL File - $sql_file"
   mysql -h mysql.devopsdvs.online -uroot &>>$log_file
   status_check $?
  done

  systemd_setup
}