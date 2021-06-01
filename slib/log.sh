#!/bin/bash
#############################################################################
## Copyright:
## Filename: log.sh
## Description:
## Version: v1.0
## Created: 
## encoding=utf-8
## fileencoding=utf-8
## termencoding=gb18030
############################################################################
#echo  "${LINENO}" "g_logPath[$g_logPath]|g_logFile=[$g_logFile]|g_logLevel=${g_logLevel}|log: debug:1; info:2; warn:3; error:4  ;#all:0 diss=8"

if false;then
{
    #使用方法：

	[ -d ${g_logPath} ] || mkdir -m 755 -p ${g_logPath}
	[ -d ${g_dirDatE} ] || mkdir -m 755 -p ${g_dirDatE}
	[ -f ${g_logPath}/${g_logFile} ] || touch  "${g_logPath}/${g_logFile}"
	chmod 700 "${g_logPath}/${g_logFile}"
    #--------------------------------------#
	#    导入日志头文件                    #
	#--------------------------------------#
	#echo "${LINENO};${g_dirSlib},导入头文件"
	.  "${g_dirSlib}/log.sh" || { echo "[${g_scriptName}:${LINENO}] ERROR:Failed to load ${g_curPath}/log.sh.:";exit 1;}
	showLog_hide  "${LINENO}" "g_logPath[$g_logPath]|g_logFile=[$g_logFile]|g_logLevel=${g_logLevel}|当前脚本日志级别: debug:1; info:2; warn:3; error:4  ;#all:0 diss=8"
#---------日志部分结束--------------------------------------------------
}
fi

############################################################################
# Function: logDef
# Description:
# Parameter: 
#     input:"${g_logPath}/${g_logFile}"
#     N/A
#     output:
#     N/A
# Return: 0 -- success; not 0 -- failure
# Others: 
############################################################################
logDef()
{
	local funcName="$1"
	shift

	local logType="$1"
	shift

	local lineNO="$1"
	shift
		
	local logTime="$(date -d today +'%Y-%m-%d %H:%M:%S')"
	#logStr="$(printf "[${logTime}] ${logType} $* [${g_scriptName}(${funcName}):${lineNO}]($$)\n" )"
	logStr=$(printf "[${logTime}|%-5s] $* [${g_scriptName}(${funcName}):${lineNO}]($$)\n" ${logType})

	if [ -d "${g_logPath}" ];then
	#{	
		case "$logType" in
			hide|HIDE)   [[ $g_logLevel -le -2 ]] && return 0;;
			all |ALL)    [[ $g_logLevel -le -1 ]] && echo "${logStr}";;
			trace|TRACE) [[ $g_logLevel -le  0 ]] && echo "${logStr}";;
			debug|DEBUG) [[ $g_logLevel -le  1 ]] && echo "${logStr}";;
			info|INFO)   [[ $g_logLevel -le  2 ]] && echo "${logStr}";;
			warn|WARN)   [[ $g_logLevel -le  3 ]] && echo "${logStr}";;
			error|ERROR) [[ $g_logLevel -le  4 ]] && echo "${logStr}";; 
			fatal|FATAL) [[ $g_logLevel -le  5 ]] && echo "${logStr}";;
			diss|DISS)   [[ $g_logLevel -le  8 ]] && echo "[$(date -d today +'%Y-%m-%d %H:%M:%S')] ${logLevel}:$*";; 
			*) ;;
		esac
	#}>> "${g_logPath}/${g_logFile}" 2>&1
	fi
	
	return 0
}



logDef2File()
{
  {
	logDef "$@"
  }>> "${g_logPath}/${g_logFile}" 2>&1
}

logDef2Stdout()
{
	logDef "$@"
}



############################################################################
# Function: log_error
# Description:
# Parameter:
#     input:
#     N/A
#     output:
#     N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
############################################################################
log_diss()
{ 
	logDef2File "${FUNCNAME[1]}" "DISS"  "$@" 
}
log_fatal()
{ 
	logDef2File "${FUNCNAME[1]}" "FATAL" "$@" 
}
log_error()
{ 
	logDef2File "${FUNCNAME[1]}" "ERROR" "$@" 
}
log_warn()
{
	logDef2File "${FUNCNAME[1]}" "WARN"  "$@" 
}

log_info()
{ 
	logDef2File "${FUNCNAME[1]}" "INFO"  "$@" 
}

log_debug()
{ 
	logDef2File "${FUNCNAME[1]}" "DEBUG" "$@" 
}

log_trace() 
{ 
	logDef2File "${FUNCNAME[1]}" "TRACE" "$@" 
}
log_all()
{ 
	logDef2File "${FUNCNAME[1]}" "ALL"   "$@" 
}
log_hide()
{ 
	logDef2File "${FUNCNAME[1]}" "HIDE"  "$@" 
}


############################################################################
# Function: showLog
# Description:
# Parameter:
#     input:
#     N/A
#     output:
#     N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
############################################################################
showLog()
{
	logDef2File    "${FUNCNAME[2]}" "$@"
	logDef2Stdout  "${FUNCNAME[2]}" "$@"

	#hide|HIDE)   |#打印隐藏日志,不落�?
	#all |ALL)    |#�?有日�?
	#trace|TRACE) |#日志追踪
	#debug|DEBUG) |#日志调试
	#info|INFO)   |#日志信息
	#warn|WARN)   |#日志警告
	#error|ERROR) |#日志错误
	#fatal|FATAL) |#日志失败
	#diss|DISS)   |#日志宣传
		
}


############################################################################
# Function: showLog_error
# Description:
# Parameter:
#     input:
#     N/A
#     output:
#     N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
############################################################################
showLog_diss()
{ 
	showLog "DISS"  "$@"
}

showLog_fatal()
{
	showLog "FATAL" "$@"
}

showLog_error()
{ 
	showLog "ERROR" "$@" 
}

showLog_warn()
{ 
	showLog "WARN"  "$@" 
}
	
showLog_info()
{ 
	showLog "INFO"  "$@"
}

showLog_debug()
{ 
	showLog "DEBUG" "$@"
}

showLog_trace()
{ 
	showLog "TRACE" "$@"
}

showLog_all()
{ 
	showLog "ALL"   "$@"
}

showLog_hide()
{
	showLog "HIDE"  "$@" 
}

############################################################################
# Function: syslog
# Description:
# Parameter:
#     input:
#     $1 is componet name;
#     $2 is filename;
# 	  $3 is status;
#     $4 is message;
#     output:
#     N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
############################################################################
function syslog()
{
	showLog "ERROR" "$@"
	local componet="$1"
	local filename="$2"
	local status="$3"
	local message="$4"

	if [ "$3" -eq "0" ];then
		status="success"
	else
		status="failed"
	fi

	which logger >/dev/null 2>&1
	[ "$?" -ne "0" ] && return 0;

	login_user_ip="$(who -m|sed 's/.*(//g;s/)*$//g')"
	execute_user_name="$(whoami)"
	logger -p local0.notice -i "${comonent};[${filename}];${status};${login_user_ip};${execute_user_name};${message}"
	
	return 0;
}

