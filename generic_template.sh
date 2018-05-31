#!/bin/bash

################################
# Readme to use the template: 
#   Please change ${sh_name}, ${output_path} and showMenu()
#  
# -----------------------------
# Author: Tony
# Mail: meteorq@live.co.uk
# Version: 1.0.0.1
# Datetime: 21/12/2017
################################

# Remind: all variables should be quoted with "*" to avoid unknown issues caused by special characters.

#   -------------------------------
#   App Profile
#   -------------------------------

# load from defaultConfigList
default_profile(){
    constructSeperator "Loading default_profile configuration." "*" "${notify_profile_color}"
        
    count=0
    for index in "${defaultConfigList[@]}"; do
        KEY="${index%%::*}"
        FUN="${index#*::}"
        FUN="${FUN%::*}"
        FUN="${FUN//[[:space:]]/}"
        DES="${index##*::}"

        if [[ "${FUN}" != "" ]]; then
            item="${KEY}=${FUN}"
            eval ${item}
        fi

        count=$((${count}+1))
    done 

    constructSeperator "Default Configuration Loaded." "*" "${notify_profile_color}"
}

read_user_profile(){
    constructSeperator "Loading user profile configuration." "*" "${notify_profile_color}"

    # read from profile
    while read line; do
        eval "$line"
    done < "${profile_path}"

    constructSeperator "User Configuration Loaded." "*" "${notify_profile_color}"
}

loadProfile(){
    if [ -f "${profile_path}" ]
    then
        read_user_profile      
    else    
        default_profile
    fi
    
    # if profile folder not exist, create it
    if [ ! -d "${profile_folder}" ]
    then
        mkdir "${profile_folder}"
    fi
    
    updateConfig
}

updateConfig(){
    echoFuncSeperator "updateConfig"
        
    count=0
    for index in "${defaultConfigList[@]}"; do
        KEY="${index%%::*}"

        if [[ ${count} == 0 ]]; then
            item="echo "${KEY}=\\\"\${${KEY}}\\\"" > "\"${profile_path}\"""
        else
            item="echo "${KEY}=\\\"\${${KEY}}\\\"" >> "\"${profile_path}\"""
        fi

        eval ${item}
        count=$((${count}+1))
    done 
}

updateRunHistory(){
    run_history=$1

    updateConfig
}

#   -------------------------------
#   App functions
#   -------------------------------

setOutputDir(){
    echoFuncSeperator "setOutputDir"
    echo "Please input the target output directory:"
    read output_path

    updateConfig
}

open_output(){
    echoFuncSeperator "open_output"
}

open_output_dir(){
    echoFuncSeperator "open_output_dir"
    open -a Finder "${output_path}"
}

clean_cache(){
    echoFuncSeperator "clean_cache"

#   if [ -d "${video_tmp_path}" ]
#   then
#       rm -r "${video_tmp_path}"
#   fi
}

rename_output(){
    echoFuncSeperator "rename_output"
    echo "Please input the target output name:"
    read output_name

    updateConfig
}

#   -------------------------------
#   UI functions
#   -------------------------------

enable_color_theme(){
  NC='\033[0m'  # the end
  
  # foreground colours
  BLACK='\033[0;30m'
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  D_GREEN='\033[1;32m'
  YELLOW='\033[0;33m'
  D_YELLOW='\033[2;33m'
  BLUE='\033[0;34m'
  MAGENTA='\033[0;35m'
  CYAN='\033[0;36m'
  LIGHT_GRAY='\033[0;37m'
  D_GRAY='\033[2;37m'
  DARK_GRAY='\033[0;90m'
  LIGHT_RED='\033[0;91m'
  LIGHT_GREEN='\033[0;92m'
  LIGHT_YELLOW='\033[0;93m'
  LIGHT_BLUE='\033[0;94m'
  LIGHT_MAGENTA='\033[0;95m'
  LIGHT_CYAN='\033[0;96m'
  WHITE='\033[0;97m'
  D_WHITE='\033[1;97m'
}

default_theme(){
    default_color="$D_WHITE"  # white color

    title_window_color="$GREEN"
    title_name_color="$RED"

    profile_color="$BLUE"
    menu_color="$D_GREEN"
    fun_seperator_color="$D_GRAY"
    func_name_color="$D_GRAY"
    status_seperator_color="$GREEN"

    notify_profile_color="$WHITE"
    notify_color="$D_YELLOW"

    ICON_ACCEPT="✅  "
    ICON_WARN="⚠️  "
    ICON_ERR="❌  "
}

echoFuncSeperator(){
    echo -e "\n"
    constructSeperator "[$1]" "*" "${fun_seperator_color}"
}

repeatEcho(){
    if [[ "$2" != "0" ]]; then
        seq  -f "$1" -s '' $2; echo
    fi
}

constructSeperator(){
    terminalWidth=$(tput cols)
    windowWidth=${terminalWidth}
    instructionTitle=$1 

    if [[ ${windowWidth} -le $((${#sh_name}+${#sh_ver}+7)) ]]; then
        windowWidth=$((${#sh_name}+${#sh_ver}+7))
        # echo "new" ${windowWidth} ${#instructionTitle}
    fi

    if [[ ${windowWidth} -le $((${#instructionTitle})) ]]; then
        windowWidth=$((${#instructionTitle}+2))
    fi

    lengthSeperator=$((windowWidth-${#instructionTitle}))
    tmpSeperator=$(repeatEcho "$2" $lengthSeperator)
    insertPos=$(($lengthSeperator/2))
    
    if [[ "$3" == "" ]]; then
        color="${default_color}"
    else
        color=$3
    fi

    if [[ "$2" != " " ]]; then
        echo -e "${color}${tmpSeperator:0:$insertPos}${NC}${func_name_color}${instructionTitle}${NC}${color}${tmpSeperator:$insertPos:${#tmpSeperator}}${NC}"
    else
        tmpSeperator=${tmpSeperator/#[[:space:]]/*}
        tmpSeperator=${tmpSeperator/%[[:space:]]/*}
        echo -e "${color}${tmpSeperator:0:$insertPos}${NC}${title_name_color}${instructionTitle}${NC}${color}${tmpSeperator:$insertPos:${#tmpSeperator}}${NC}"
    fi
}

showAppTitle(){
    # echo -e "\n"
    constructSeperator "" "*" "${title_window_color}"
    constructSeperator " ${sh_name} v${sh_ver} " " " "${title_window_color}"
    constructSeperator " ${sh_time} " " " "${title_window_color}"
    constructSeperator "" "*" "${title_window_color}"

}

showProfile(){
    echoFuncSeperator "Profile"

    arrayProfile=(
        # VAR::Description
        "${output_path}::Current output directory"
        )

    for index in "${arrayProfile[@]}"; do
        KEY="${index%%::*}"
        DES="${index##*::}"

        echo -e "${DES}: ${profile_color}${KEY}${NC}"
    done   
    constructSeperator "" "-" "${status_seperator_color}"
}

showMenu(){
    arrayMenu=(
        # KEY::Function::Description
        'q      or Q::exit            ::Exit (Ctrl+C)'
        'o      or O::open_output     ::Open output'
        'r      or R::rename_output   ::Rename output'
        'd      or D::clean_cache     ::Clean output cache'
        'c      or C::setOutputDir    ::Choose the output directory'
        'p      or P::open_output_dir ::Open out directory'
        )
        
    count=0
    for index in "${arrayMenu[@]}"; do
        KEY="${index%%::*}"
        KEY_1="${KEY%%or*}"
        KEY_2="${KEY##*or}"
        FUN="${index#*::}"
        FUN="${FUN%::*}"
        DES="${index##*::}"

        alignPrefix="${count}"
        alignPrefix=${#alignPrefix}
        alignTotal=${#arrayMenu[@]}
        alignTotal="${alignTotal}"
        alignTotal=${#alignTotal}
        alignPrefix=$(($alignTotal-$alignPrefix))    
        alignPrefix=$(repeatEcho "0" $alignPrefix)

        echo -e "[${alignPrefix}${count}] ${menu_color}${KEY_1}${NC} or ${menu_color}${KEY_2}${NC} -> ${FUN} -> ${DES}"
        count=$((${count}+1))
    done    

    showRunHistory  
    
    read -n1 option
    echo ;
    
    # read -s -n1 -p "Hit a key " keypress
    # -s 选项意味着不打印输入.
    # -n N 选项意味着只接受N个字符的输入.
    # -p 选项意味着在读取输入之前打印出后边的提示符.
    
    final_option=""
    for index in "${arrayMenu[@]}"; do
        KEY="${index%%::*}"
        KEY_1="${KEY%%or*}"
        KEY_2="${KEY##*or}"
        FUN="${index#*::}"
        FUN="${FUN%::*}"
        DES="${index##*::}"

        KEY_1=${KEY_1//[[:space:]]/}
        KEY_2=${KEY_2//[[:space:]]/}
        FUN=${FUN//[[:space:]]/}

        if [[ "$option" = "${KEY_1}" ]] || [[ "$option" = "${KEY_2}" ]]; then
            final_option="${FUN}"
        fi
    done  

    if [[ "${final_option}" != "" ]]; then
        if [[ "${final_option}" != "exit" ]]; then
            echo -e "${notify_color}<${final_option}... begin.>${NC}"  
            updateRunHistory "${final_option}... failed."
        else
            updateRunHistory "quit... done."
            echo -e "${notify_color}<${run_history}>${NC}"
        fi 

        eval ${final_option}  

        EXIT_CODE=$?
        if [[ $EXIT_CODE -eq 0 ]]; then
            updateRunHistory "${ICON_ACCEPT}[${option}]: ${final_option}... done."
        else
            updateRunHistory "${ICON_ERR}[${option}]: ${final_option}... fail."
        fi  

    else
        updateRunHistory "${ICON_ERR}[${option}]: Invalid option."
    fi   

    echo -e "${notify_color}<${run_history}>${NC}"
}

showRunHistory(){
    constructSeperator "" "-"
    echo -e "Last run history: ${profile_color}${run_history}${NC}"
    constructSeperator "" "-"
}

trim_sh_name(){
    local tmp=$1

    if [[ "$2" != "" ]]; then
        tmp=${tmp//[[:space:]]/$2}
    fi   
    echo "$tmp"
}

init(){
    # app name for the shell 
    sh_name="test"
    sh_ver="1.0.0.1"
    sh_time="21/12/2017 19:52:30"

    # name for files in project folder, e.g. "webVideoProcessor.profile"
    sh_name_extra=$(trim_sh_name "${sh_name}" "_")

    # shell path
    # shell_path=$HOME"/Software/Writing with Latex/"
    shell_path=$(dirname "${0}")"/"
    profile_folder=${shell_path}"profile/"

    # profile path
    profile_path=${profile_folder}"${sh_name_extra}.profile"

    # write new configuration to profile file
    defaultConfigList=(
        # name::value::Description
        'output_path::$HOME"/test"     ::output dir path'
        'run_history::                ::run history'
        )

    enable_color_theme

    default_theme

    showAppTitle
    
    loadProfile
}

inputParser(){
    echoFuncSeperator "inputParser"
    if [[ $# != 0 ]]; then
        # read the options, available options: -a -b -c -o
        # To use long options, use gnu-getopt instead
        TEMP=`getopt abco: $*`
        
        if [[ $? != 0 ]]; then
            echo "Usage: ..."
        fi
        eval set -- "$TEMP"

        # extract options and their arguments into variables.
        for i
        do
            case "$i" in
                -a|-b)
                    echo flag $i set; sflags="${i#-}$sflags";
                    shift;;
                -o)
                    echo oarg is "'"$2"'"; oarg="$2"; shift;
                    shift;;
                --)
                    shift; break;;
            esac
        done

        echo -e "\n"single-char flags: "'"$sflags"'"
        echo oarg is "'"$oarg"'"
    fi
}

main(){
    init

    # inputParser $*

    until [ "$option" = "q" ]
    do
            # clear previous running
            clear
    
            showAppTitle  

            showProfile

            showMenu
    
    done
    
    constructSeperator " Exit " "*" "${default_color}"
    exit 0          
}

main $*