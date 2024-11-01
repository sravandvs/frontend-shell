cp shipping.service /etc/systemd/system/shipping.service
dnf install maven -y

useradd roboshop

mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
cd /app
unzip /tmp/shipping.zip

cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

dnf install mysql -y

for sql_file in schema app-user master-data; do
  mysql -h mysql.devopsdvs.online -uroot -pRoboShop@1 < /app/db/$sql_file.sql
done

systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping