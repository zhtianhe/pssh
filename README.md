
# <p align="center"> <kbd> pshg </kbd> </p>

## 1、安装脚本：

vi ~/.bash_profile
```sh
export PSHOME=$HOME/sbin/pssh
source $PSHOME/scfg/pssh.env
```
加载：` source ~/.bash_profile `

## 2、配置文件：$PSHOME/scfg
- $PSHOME/scfg/.pssh-hosts.conf
```ini
#column-t-s''
#1、IP|hostname
#2、运行中心
#3、中文名称
#4、用户口令
#IP,hostname|组id|简要说明|用户1/key1,u2/k2,
#MBFE 环境
#IP            ,hostname,节点名,|xxx组,|机器用途,其他说明   |User1/password,User2/password,......,
#===============================================================================================================
#NCD组
xxx.xxx.xxx.xxx,NCD01, node1 ,  |NCD ,| 应用01    ,01 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD02, node2 ,  |NCD ,| 应用02    ,02 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD03, node3 ,  |NCD ,| 应用03    ,03 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD04, node4 ,  |NCD ,| 应用04    ,04 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD05, node5 ,  |NCD ,| 应用05    ,05 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,


#NCY组
xxx.xxx.xxx.xxx,NCY01, node1 ,  |NCY ,| 应用01    ,01 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY02, node2 ,  |NCY ,| 应用02    ,02 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY03, node3 ,  |NCY ,| 应用03    ,03 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY04, node4 ,  |NCY ,| 应用04    ,04 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY05, node5 ,  |NCY ,| 应用05    ,05 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,

```
- 组配置

```ini
#ini
[CONF]
base64_key=shid
[CONF_END]
[all]
#egrep  "\<$(sed -n '/HostList/p' psh-UserGroup |cut -d'=' -f2)\>" hosts-YQ.conf
#------云迁移定版环境---------

#ncd组
[ncd]
UserName=
HostList0=NCD[0-9].*
[END]

#ncy
[ncy]
UserName=
HostList0=NCY[0-9].*
[END]

#User-app
[User-app]
UserName=UserName
HostList0=NC[DY][0-9].*
HostList0=S[DY][0-9].*
HostList0=YQ[DY][0-9].*
HostList0=DB[0-9].*
HostList0=YY[0-9].*
[END]

```

简要命令：

```sh

# 批量重启服务
pssh -W -g ncd -U User1  -c 'kall;startall'  #重启ncd组 xxx 用户下的 应用及服务          ;若已经启动则检查启动状态
pssh -W -g ncd -U USER1  -c 'startall'       #启动ncd组 USER1  用户下的应用;若已经启动则检查启动状态
pssh -W -g User-app      -c 'startall'    #启动ncd组 USER1 用户下的 UserName;若已经启动则检查启动状态
```

- 简单使用方法：
```
    |-----------------------------------------------------------------------------------------------------
    |                             帮助信息
    |   名称    ：  pssh
    |   类型    ：  Bash (主动推送)|zh_CN.UTF-8
    |   应用环境:   LINUX
    |   依赖命令：  ssh|scp|rsync|expect|openssl
    |   功能描述：  集群批量管理操作工具;
    |   三大功能:   1、ssh 单点/穿行登录
    |               2、ssh 批量远程命令
    |               3、scp 批量文件上传下载
    |         优点:通过配置 初始秘钥文件,和组操作文件制作出加密文件,
    |              #安装简单：vi /c/Users/ZTE/.bash_porfile
    |         缺点:配置初始秘钥文件,和组操作文件,脚本不能加密
    |              类似软件: pssh | clushtershell | Ansible  
    |-----------------------------------------------------------------------------------------------------
    |
    | Usage : pssh [OPTION] ....
    |
    | Options:
    |     --help              帮助信息
    |    *-g, --group         组选项  | 组名称标签；组配置文件[]
    |    *-g, --group         组清单  | 列举出组名清单
    |    *-h, --hosts         主机名称| all:所有主机|主机配置文件[]
    |    *-H, --hosts         主机清单| 列举出名称和IP
    |    *-U, --username      用户名称| 无该选项-用户 或者组标签中用户| all:所有用户   	
    |    *-l, --login         登录标识| 无参数
    |    *-c, --cmdsh         执行命令| 命令有空格的加引号:(注意单双引号和转义)                    
    |    *-s, --scp           文件传输| 发送:put:srcdir,destdir
    |                                 | 获取:get:srcdir,destdir
    |    *-S, --rsync         文件传输|  S:使用rsync 命令 小s:使用scp命令
    |     -w, --passwd        密码选项| 使用 expect 工具自动填充口令
    |     -W, --passwd        密码选项| 使用 sshpss  工具自动填充口令
    |     -v, --version       脚本版本|                 
    |     -L, --logleve       日志级别| debug:1; info:2; warn:3; error:4  ;#all:0 diss=8"    
    |     -p, --port          主机端口| 默:22   
    |     -t,                 进程数量| 默:10 、1-用于调试
    |     -T, --timeout       超时时间| 默:60 、   
    |    #-a, --all           所有用户| 所有组(暂未实现)
    |    #-x, --removel       排除主机| 组名| 多个用 逗号,分割(暂未实现)
    |     -k, --key           制作证书|
    |     -K, --key           制作互信|并传输互信文件 (执行该步骤时先执行 -c 'id')
    |     -E, --key           编辑本脚本|vi /c/Users/ZTE/Desktop/pshg-20210531/psh/sbin/pssh
    |    #-i, --install       安装脚本| 默认安装目录:/c/Users/ZTE/Zssh/bin
    |    #--clog              清除日志| 清除 pssh 执行的日志
    |    #--ping              ping   | 暂未实现
    | Exit status
    |      0      OK
    |      !=0    ERROR
    |
    | Example:
    |     1) 登录: ssh --port=22 UserName@IPADDR
    |
    |       A)使用秘钥文件自动登录
    |         pssh -lW -h hostname -U userName  
    |         pssh -lw -h hostname -U userName  #登录缓慢
    |       B)串行登录 groupApp 组
    |         pssh -lW -g groupApp -U userName  
    |      
    |     2) 执行命令
    |
    |       A) 执行 id 命令
    |         pssh -W -h hostname -U userName  -c 'id'
    |       B)并行 执行 id 命令
    |        pssh -W -g groupApp  -U userName  -c 'id'
    |        pssh -W -h all  -U all  -c 'id'  #已知所有IP 及所有用户执行
    |      
    |
    |     3)get file：下载文件(注意多节点下覆盖)
    |       SCP  ：   pssh -W -h hostname -s get:/destdir/file:/srcdir/
    |       RSYNC：   pssh -W -h hostname -S get:/destdir/file:/srcdir/
    |        - 组
    |        SCP  : pssh -W -g groupApp   -s get:/destdir/file:/srcdir/
    |        RSYNC: pssh -W -g groupApp   -S get:/destdir/file:/srcdir/
    |
    |     4)put file： 将本地文件上传至目标机
    |        SCP  : pssh -W -h hostname -s put:~/srcdir/file:~/destdir/
    |        RSYNC: pssh -W -h hostname -S put:~/srcdir/file:~/destdir/
    |        - 组
    |        SCP  : pssh -W -g groupApp -s put:~/srcdir/file:~/destdir/
    |        RSYNC: pssh -W -g groupApp -S put:~/srcdir/file:~/destdir/
    |
    |     5)key file:制作密钥
    |            -k
    |         配置文件[]不存在请在60s内输入:Zssh/bin/.hosts.cfg
    |         输入信息为:[Zssh/bin/.hosts.cfg]
    |         !!!! 证书制作成功 !!!
    |     
    |          根据提示输入：文件名称 内容格式如下：
    |          cat  .Example    
    |
    |     6)制作互信
    |       A) 执行 id 命令
    |         pssh -W -h all  -U all  -c 'id'
    |       B) 开始互信 所有 IP 及 所有用户
    |         pssh -W -h all  -U all  -K
    |       C) 开始互信 app 组 及 所有用户
    |         pssh -W -g app  -U all  -K
    |
    |     7)User_Group file：组文件
    |             cat  .Example
    |         注意:base64_key为初始秘钥口令串仅在制作证书时有效。
    |              该口令并不能解密证书。     
    |
    | Report bugs to 123456789@qq.com          
    |                                                         Tianhe  
    |                                                         2018年 08月 21日 星期二 08:48:35 CST
    |______________________________________________________________________________________________
```

## 3、网络验证工具-iport

- iport 配置
```sh
# $PSHOME/scfg/iport.list
# IP|port
#dingban pub
xxx.xxx.xxx.xxx| 21,22,23,80,5480
xxx.xxx.xxx.xxx| 21,22,23,80,5480
xxx.xxx.xxx.xxx| 21, 22,23, 80,5480
```
- ` iport ` 默认配置文件大批量网络验证使用
- ` iport  IP  port ` 单独
