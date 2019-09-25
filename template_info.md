# 源码自动生成模板 Laravel 5.8

### 概述

* 模板: Laravel 5.8
* 模板使用时间: 2019-09-25 10:58:12

### Docker
* Image: registry.cn-beijing.aliyuncs.com/code-template/laravel
* Tag: 5.8
* SHA256: 379a6c798af2114f295a9b86819919b6ee821ec7c84862833e86b87b4af6095c

### 用户输入参数
* repoUrl: "git@code.aliyun.com:106036-xinglian/xinglian.git" 
* needDockerfile: "N" 
* appName: "application" 
* from: "newPipeline" 
* codeRepo: "code.aliyun.com/106036-xinglian/xinglian" 
* operator: "aliyun_1154518" 

### 上下文参数
* appName: application
* operator: aliyun_1154518
* gitUrl: git@code.aliyun.com:106036-xinglian/xinglian.git
* branch: master


### 命令行
	sudo docker run --rm -v `pwd`:/workspace -e repoUrl="git@code.aliyun.com:106036-xinglian/xinglian.git" -e needDockerfile="N" -e appName="application" -e from="newPipeline" -e codeRepo="code.aliyun.com/106036-xinglian/xinglian" -e operator="aliyun_1154518"  registry.cn-beijing.aliyuncs.com/code-template/laravel:5.8

