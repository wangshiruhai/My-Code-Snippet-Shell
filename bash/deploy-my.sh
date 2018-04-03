#author 张国伟
#last update 2017-10-23

#!/bin/sh
export LANG=zh_CN.UTF-8

Version="1.0" #发布版本号
UserName="admin" #系统运行用户
TempDir="/home/"$UserName"/deploy/Temp/" #临时目录

source_code_base_home="/home/"$UserName"/deploy/JavaCode/" #源代码根目录

basic_service_home=$source_code_base_home/zm_business_video_basic_core  #basic service 源代码目录 管理系统后台模块
web_service_home=$source_code_base_home/zm_business_video_web_core  #web service 源代码目录  web站点模块
cache_service_home=$source_code_base_home/zm_business_cache_core  #cache service 源代码根目录   缓存模块
work_service_home=$source_code_base_home/zm_business_video_work_core  #video workcd  service 源代码根目录 视频加工模块

tomcat_service_apps_home="/home/"$UserName"/tomcat/instance/service/webapps" #basic_service部署目录

echo -e "\033[33m ======================开始更新代码========================== \033[0m"
cd $source_code_base_home
svn update
echo -e "\033[33m ======================更新源代码完成======================== \033[0m"
echo -e '\n\n\n'
echo -e "\033[33m ======================正在执行打包========================== \033[0m"


cd $basic_service_home
mvn clean install |sed -n '/BUILD SUCCESS/,+1p'
echo -e "\033[33m =================basic打包成功======================== \033[0m"

cp $basic_service_home/zm_business_video_basic_service/target/zm_business_video_basic_service.war  $TempDir/zm_business_video_basic_service.war
echo -e "\033[33m ===============basic_service包文件收集完成==================== \033[0m"
echo -e '\n\n\n'



echo -e "\033[33m ===============接口代码切换至employee数据源================== \033[0m"
cp $web_service_home/zm_business_video_web_service/src/main/resources/dataSource/application_root_employee.xml $web_service_home/zm_business_video_web_service/src/main/resources/application-root.xml

cd $web_service_home
mvn clean install |sed -n '/BUILD SUCCESS/,+1p'
echo -e "\033[33m =================employee service打包成功======================== \033[0m"

cp $web_service_home/zm_business_video_web_service/target/zm_business_video_web_service.war  $TempDir/zm_business_video_web_service_employee.war
echo -e "\033[33m ===============employee接口包文件收集完成==================== \033[0m"
echo -e '\n\n\n'



echo -e "\033[33m ===============接口代码切换至member数据源==================== \033[0m"
cp $web_service_home/zm_business_video_web_service/src/main/resources/dataSource/application_root_member.xml $web_service_home/zm_business_video_web_service/src/main/resources/application-root.xml

mvn clean install |sed -n '/BUILD SUCCESS/,+1p'
echo -e "\033[33m =================member接口打包成功========================== \033[0m"

cp $web_service_home/zm_business_video_web_service/target/zm_business_video_web_service.war $TempDir/zm_business_video_web_service_member.war
echo -e "\033[33m =================member接口包文件收集完成==================== \033[0m"
echo -e '\n\n\n'

cd $cache_service_home
mvn clean install |sed -n '/BUILD SUCCESS/,+1p'
echo -e "\033[33m =================cache service打包成功======================== \033[0m"
cp $cache_service_home/zm_business_cache_service/target/zm_business_cache_service.war $TempDir/zm_business_cache_service.war
echo -e "\033[33m =================cache接口包文件收集完成==================== \033[0m"

cd $work_service_home
mvn clean install |sed -n '/BUILD SUCCESS/,+1p'
echo -e "\033[33m =================video work service打包成功======================== \033[0m"
cp $work_service_home/zm_business_video_work_service/target/zm_business_video_work_service.war $TempDir/zm_business_video_work_service.war
echo -e "\033[33m =================video work接口包文件收集完成==================== \033[0m"

echo -e "\033[33m =============开始部署Tomcat================ \033[0m"
cp $TempDir/zm_business_video_basic_service.war $tomcat_service_apps_home/zm_business_video_basic_service-$Version.war
echo -e "\033[33m =============部署basic_service接口包到tomcat成功！================ \033[0m"

cp $TempDir/zm_business_video_web_service_employee.war $tomcat_service_apps_home/zm_business_video_web_service_employee-$Version.war
echo -e "\033[33m =============部署employee接口包到tomcat成功！================ \033[0m"

cp $TempDir/zm_business_video_web_service_member.war $tomcat_service_apps_home/zm_business_video_web_service_member-$Version.war
echo -e "\033[33m =============部署member接口包到tomcat成功！================== \033[0m"

cp $TempDir/zm_business_cache_service.war $tomcat_service_apps_home/zm_business_cache_service-$Version.war
echo -e "\033[33m =============部署cache接口包到tomcat成功！================== \033[0m"

cp $TempDir/zm_business_video_work_service.war $tomcat_service_apps_home/zm_business_video_work_service-$Version.war
echo -e "\033[33m =============部署videowork接口包到tomcat成功！================ \033[0m"

echo -e '\n\n\n'
echo -e "\033[33m "=============================================================" \033[0m"
echo -e "\033[33m "================视频服务模块发布完成！=======================" \033[0m"
echo -e "\033[33m "=============================================================" \033[0m"
