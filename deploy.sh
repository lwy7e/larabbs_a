#!/bin/bash
PROG_NAME=$0
ACTION=$1
ONLINE_OFFLINE_WAIT_TIME=6  # 实例上下线的等待时间
APP_START_TIMEOUT=25   # 等待应用启动的时间
APP_PORT=80      # 应用端口
HEALTH_CHECK_URL=http://127.0.0.1:${APP_PORT}  # 应用健康检查URL
HEALTH_CHECK_FILE_DIR=/var/app/status   # 脚本会在这个目录下生成nginx-status文件
APP_HOME=/var/app/${APP_NAME} # 从package.tgz中解压出来的文件放到这个目录下

# 创建出相关目录
mkdir -p ${HEALTH_CHECK_FILE_DIR}
mkdir -p ${APP_HOME}

usage() {
  echo "Usage: $PROG_NAME {start|stop|online|offline|restart}"
  exit 2
}

online() {
  # 挂回SLB
  touch -m $HEALTH_CHECK_FILE_DIR/nginx-status || exit 1
  echo "wait app online in ${ONLINE_OFFLINE_WAIT_TIME} seconds..."
  sleep ${ONLINE_OFFLINE_WAIT_TIME}
}

offline() {
  # 摘除SLB
  rm -f $HEALTH_CHECK_FILE_DIR/nginx-status || exit 1
  echo "wait app offline in ${ONLINE_OFFLINE_WAIT_TIME} seconds..."
  sleep ${ONLINE_OFFLINE_WAIT_TIME}
}

health_check() {
  exptime=0
  echo "checking ${HEALTH_CHECK_URL}"
  while true
  do
    status_code=`/usr/bin/curl -L -o /dev/null --connect-timeout 5 -s -w %{http_code}  ${HEALTH_CHECK_URL}`
    if [ x$status_code != x200 ];then
      sleep 1
      ((exptime++))
      echo -n -e "\rWait app to pass health check: $exptime..."
    else
      break
    fi
    if [ $exptime -gt ${APP_START_TIMEOUT} ]; then
      echo 'app start failed'
      exit 1
    fi
  done
  echo "check ${HEALTH_CHECK_URL} success"
}

start_application() {
  echo 'Start application'

  NGINX_CONF=/etc/nginx/sites-available/${APP_NAME}
  mv ${NGINX_CONF} ${NGINX_CONF}.bak
  sed "s/@@APP_HOME@@/${APP_HOME//\//\\/}/g" ${APP_HOME}/manifest/conf/nginx > ${NGINX_CONF}
  ln -snf ${NGINX_CONF} /etc/nginx/sites-enabled/default
  cp ${APP_HOME}/manifest/env ${APP_HOME}/.env

  cd ${APP_HOME}

  composer install --no-dev
  php artisan optimize
  php artisan key:generate
  php artisan config:cache
  php artisan up

  chmod -R 775 storage
  chown -R www-data:www-data ${APP_HOME}
  service php7.3-fpm start
  service nginx start
}

stop_application() {
  cd ${APP_HOME}
  php artisan down
  service php7.3-fpm stop
  service nginx stop
}

start() {
  start_application
  health_check
  online
}

stop() {
  offline
  stop_application
}

case "$ACTION" in
  start)
    start
  ;;
  stop)
    stop
  ;;
  online)
    online
  ;;
  offline)
    offline
  ;;
  restart)
    stop
    start
  ;;
  *)
    usage
  ;;
esac
