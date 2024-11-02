source common.sh
app_name=shipping

if [ -z "$1" ]; then
  echo Input Rabbitmq Password is missing
  exit 1
fi

MYSQL_ROOT_PASSWORD=$1
maven_setup