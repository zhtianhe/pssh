
# <p align="center"> <kbd> pshg </kbd> </p>

## 1����װ�ű���

vi ~/.bash_profile
```sh
export PSHOME=$HOME/sbin/pssh
source $PSHOME/scfg/pssh.env
```
���أ�` source ~/.bash_profile `

## 2�������ļ���$PSHOME/scfg
- $PSHOME/scfg/.pssh-hosts.conf
```ini
#column-t-s''
#1��IP|hostname
#2����������
#3����������
#4���û�����
#IP,hostname|��id|��Ҫ˵��|�û�1/key1,u2/k2,
#MBFE ����
#IP            ,hostname,�ڵ���,|xxx��,|������;,����˵��   |User1/password,User2/password,......,
#===============================================================================================================
#NCD��
xxx.xxx.xxx.xxx,NCD01, node1 ,  |NCD ,| Ӧ��01    ,01 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD02, node2 ,  |NCD ,| Ӧ��02    ,02 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD03, node3 ,  |NCD ,| Ӧ��03    ,03 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD04, node4 ,  |NCD ,| Ӧ��04    ,04 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCD05, node5 ,  |NCD ,| Ӧ��05    ,05 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,


#NCY��
xxx.xxx.xxx.xxx,NCY01, node1 ,  |NCY ,| Ӧ��01    ,01 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY02, node2 ,  |NCY ,| Ӧ��02    ,02 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY03, node3 ,  |NCY ,| Ӧ��03    ,03 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY04, node4 ,  |NCY ,| Ӧ��04    ,04 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,
xxx.xxx.xxx.xxx,NCY05, node5 ,  |NCY ,| Ӧ��05    ,05 , centos7.6 :pg14.0 ,|User1/password,User2/password,......,

```
- ������

```ini
#ini
[CONF]
base64_key=shid
[CONF_END]
[all]
#egrep  "\<$(sed -n '/HostList/p' psh-UserGroup |cut -d'=' -f2)\>" hosts-YQ.conf
#------��Ǩ�ƶ��滷��---------

#ncd��
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

��Ҫ���

```sh

# ������������
pshg -W -g ncd -U User1  -c 'kall;startall'  #����ncd�� xxx �û��µ� Ӧ�ü�����          ;���Ѿ�������������״̬
pshg -W -g ncd -U USER1   -c 'startall'       #����ncd�� USER1  �û��µ�Ӧ��;���Ѿ�������������״̬
pshg -W -g User-app   -c 'startall'    #����ncd�� USER1 �û��µ� UserName;���Ѿ�������������״̬
```

- ��ʹ�÷�����
```
    |-----------------------------------------------------------------------------------------------------
    |                             ������Ϣ
    |   ����    ��  pssh
    |   ����    ��  Bash (��������)|zh_CN.UTF-8
    |   Ӧ�û���:   LINUX
    |   �������  ssh|scp|rsync|expect|openssl
    |   ����������  ��Ⱥ���������������;
    |   ������:   1��ssh ����/���е�¼
    |               2��ssh ����Զ������
    |               3��scp �����ļ��ϴ�����
    |         �ŵ�:ͨ������ ��ʼ��Կ�ļ�,��������ļ������������ļ�,
    |              #��װ�򵥣�vi /c/Users/ZTE/.bash_porfile
    |         ȱ��:���ó�ʼ��Կ�ļ�,��������ļ�,�ű����ܼ���
    |              �������: pssh | clushtershell | Ansible  
    |-----------------------------------------------------------------------------------------------------
    |
    | Usage : pssh [OPTION] ....
    |
    | Options:
    |     --help              ������Ϣ
    |    *-g, --group         ��ѡ��  | �����Ʊ�ǩ���������ļ�[]
    |    *-g, --group         ���嵥  | �оٳ������嵥
    |    *-h, --hosts         ��������| all:��������|���������ļ�[]
    |    *-H, --hosts         �����嵥| �оٳ����ƺ�IP
    |    *-U, --username      �û�����| �޸�ѡ��-�û� �������ǩ���û�| all:�����û�   	
    |    *-l, --login         ��¼��ʶ| �޲���
    |    *-c, --cmdsh         ִ������| �����пո�ļ�����:(ע�ⵥ˫���ź�ת��)                    
    |    *-s, --scp           �ļ�����| ����:put:srcdir,destdir
    |                                 | ��ȡ:get:srcdir,destdir
    |    *-S, --rsync         �ļ�����|  S:ʹ��rsync ���� Сs:ʹ��scp����
    |     -w, --passwd        ����ѡ��| ʹ�� expect �����Զ�������
    |     -W, --passwd        ����ѡ��| ʹ�� sshpss  �����Զ�������
    |     -v, --version       �ű��汾|                 
    |     -L, --logleve       ��־����| debug:1; info:2; warn:3; error:4  ;#all:0 diss=8"    
    |     -p, --port          �����˿�| Ĭ:22   
    |     -t,                 ��������| Ĭ:10 ��1-���ڵ���
    |     -T, --timeout       ��ʱʱ��| Ĭ:60 ��   
    |    #-a, --all           �����û�| ������(��δʵ��)
    |    #-x, --removel       �ų�����| ����| ����� ����,�ָ�(��δʵ��)
    |     -k, --key           ����֤��|
    |     -K, --key           ��������|�����以���ļ� (ִ�иò���ʱ��ִ�� -c 'id')
    |     -E, --key           �༭���ű�|vi /c/Users/ZTE/Desktop/pshg-20210531/psh/sbin/pssh
    |    #-i, --install       ��װ�ű�| Ĭ�ϰ�װĿ¼:/c/Users/ZTE/Zssh/bin
    |    #--clog              �����־| ��� pssh ִ�е���־
    | Exit status
    |      0      OK
    |      !=0    ERROR
    |
    | Example:
    |     1) ��¼: ssh --port=22 UserName@IPADDR
    |
    |       A)ʹ����Կ�ļ��Զ���¼
    |         pssh -lW -h hostname -U userName  
    |         pssh -lw -h hostname -U userName  #��¼����
    |       B)���е�¼ groupApp ��
    |         pssh -lW -g groupApp -U userName  
    |      
    |     2) ִ������
    |
    |       A) ִ�� id ����
    |         pssh -W -h hostname -U userName  -c 'id'
    |       B)���� ִ�� id ����
    |        pssh -W -g groupApp  -U userName  -c 'id'
	|        pssh -W -h all  -U all  -c 'id'  #��֪����IP �������û�ִ��
    |      
    |
    |     3)get file�������ļ�(ע���ڵ��¸���)
    |       SCP  ��   pssh -W -h hostname -s get:/destdir/file:/srcdir/
    |       RSYNC��   pssh -W -h hostname -S get:/destdir/file:/srcdir/
    |        - ��
    |        SCP  : pssh -W -g groupApp   -s get:/destdir/file:/srcdir/
	|        RSYNC: pssh -W -g groupApp   -S get:/destdir/file:/srcdir/
	|
    |     4)put file�� �������ļ��ϴ���Ŀ���
    |        SCP  : pssh -W -h hostname -s put:~/srcdir/file:~/destdir/
	|        RSYNC: pssh -W -h hostname -S put:~/srcdir/file:~/destdir/
    |        - ��
    |        SCP  : pssh -W -g groupApp -s put:~/srcdir/file:~/destdir/
	|        RSYNC: pssh -W -g groupApp -S put:~/srcdir/file:~/destdir/
	|
    |     5)key file:������Կ
    |            -k
    |         �����ļ�[]����������60s������:Zssh/bin/.hosts.cfg
    |         ������ϢΪ:[Zssh/bin/.hosts.cfg]
    |         !!!! ֤�������ɹ� !!!
    |     
    |          ������ʾ���룺�ļ����� ���ݸ�ʽ���£�
    |          cat  .Example    
    |
    |     6)��������
    |       A) ִ�� id ����
    |         pssh -W -h all  -U all  -c 'id'
    |       B) ��ʼ���� ���� IP �� �����û�
    |         pssh -W -h all  -U all  -K
    |       c) ��ʼ���� app �� �� �����û�
    |         pssh -W -g app  -U all  -K
	|
    |     7)User_Group file�����ļ�
    |             cat  .Example
    |         ע��:base64_keyΪ��ʼ��Կ�����������֤��ʱ��Ч��
    |              �ÿ�����ܽ���֤�顣     
    |
    | Report bugs to 123456789@qq.com          
    |                                                         ZhangTianhe  
    |                                                         2018�� 08�� 21�� ���ڶ� 08:48:35 CST
    |______________________________________________________________________________________________
```

## ������֤����-iport

- iport ����
```sh
# $PSHOME/scfg/iport.list
# IP|port
#dingban pub
xxx.xxx.xxx.xxx| 21,22,23,80,5480
xxx.xxx.xxx.xxx| 21,22,23,80,5480
xxx.xxx.xxx.xxx| 21, 22,23, 80,5480
```
- ` iport ` Ĭ�������ļ�������������֤ʹ��
- ` iport  IP  port ` ����
