#!/bin/bash

#CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
SRC="sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
# CID="${CIDdir}/User-ID" && [[ ! -e ${CID} ]] && echo > ${CID}
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
#[[ ! -e "/bin/ShellBot.sh" ]] && wget -O /bin/ShellBot.sh https://raw.githubusercontent.com/rudi9999/TeleBotGen/master/ShellBot.sh &> /dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="==========================="

# Importando API
source ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/status
source ${SRC}/reinicio
source ${SRC}/myip
source ${SRC}/id
source ${SRC}/comandos
source ${SRC}/update
source ${SRC}/comandline
source ${CIDdir}/botScript.sh

# Token del bot
bot_token="$(cat token)"

# Inicializando el bot
ShellBot.init --token "$bot_token" --monitor --return map
ShellBot.username

download_file () {
# shellbot.sh editado linea 3986
user=User-ID
[[ -e ${CID} ]] && rm ${CID}
local file_id
          ShellBot.getFile --file_id ${message_document_file_id[$id]}
          ShellBot.downloadFile --file_path "${return[file_path]}" --dir "${CIDdir}"
local bot_retorno="ID user botgen\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="Se restauro con exito!!\n"
		bot_retorno+="$LINE\n"
		bot_retorno+="${return[file_path]}\n"
		bot_retorno+="$LINE"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $bot_retorno)</i>" \
									--parse_mode html
return 0
}

msj_add () {
	      ShellBot.sendMessage --chat_id ${1} \
							--text "<i>$(echo -e $bot_retor)</i>" \
							--parse_mode html
}

upfile_fun () {
          ShellBot.sendDocument --chat_id ${message_chat_id[$id]}  \
                             --document @${1}
}

invalido_fun () {
local bot_retorno="$LINE\n"
         bot_retorno+="Comando invalido!\n"
         bot_retorno+="$LINE\n"
	     ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "<i>$(echo -e $bot_retorno)</i>" \
							--parse_mode html
	return 0	
}

msj_fun () {
	      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "<i>$(echo -e $bot_retorno)</i>" \
							--parse_mode html
	return 0
}

msj_donar () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	      ShellBot.sendMessage --chat_id $var \
							--text "<i>$(echo -e "$bot_retorno")</i>" \
							--parse_mode html \
							--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_donar')"
	return 0
}

#botao_conf=''
botao_donar=''
botao_extra=''
botao_atras=''
botao_up=''
botao_list=''

botao_user=''
botao_user2=''

#botao_key=''

#botao_keyMenu=''

ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text 'ID' --callback_data '/id edit'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text 'ayuda' --callback_data '/ayuda edit'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text 'menu' --callback_data '/menu'

user2(){
	length=$(jq '.script | length' ${confJSON})
	n=1
	for (( i = 0; i < $length; i++ )); do
		if [[ $(jq -r .script[$i].status < ${confJSON}) = "ON" ]]; then
			name=$(jq -r .script[$i].name < ${confJSON})
			ShellBot.InlineKeyboardButton --button 'botao_user2' --line $n --text "🔑 $name key 🔑" --callback_data "/keygen $i"
			let n++
		fi
	done
	ShellBot.InlineKeyboardButton --button 'botao_user2' --line $n --text 'menu' --callback_data '/menu'
	ShellBot.InlineKeyboardButton --button 'botao_user2' --line $n --text 'ayuda' --callback_data '/ayuda edit'
}



btn_conf(){
	unset botao_conf
	botao_conf=''

	ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'Nuevo ID' --callback_data "/add"
	#if [[ $(cat ${CID}) ]]; then
	if [[ $(echo ${user_id}) ]]; then
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'del 🗑' --callback_data '/del'
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'list 📝' --callback_data '/list edit'	
	fi
	ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'Mi ID' --callback_data '/ID edit'

	ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'extra' --callback_data '/extra edit'
	ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'cache' --callback_data '/cache edit'
	ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'on/off' --callback_data '/power edit'

	PIDGEN=$(ps aux|grep -v grep|grep -w "BotGen-server.sh")
	[[ $PIDGEN ]] && ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'reset' --callback_data '/reset edit'

	length=$(jq '.script | length' ${CIDdir}/conf.json)
	script_def=$(jq -r '.default' < ${confJSON})
	if [[ "$length" -ge "2" ]]; then
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text 'menu conf Key' --callback_data '/menukey edit'
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text '🔑 keygen 🔑' --callback_data "/keygen ${script_def}"
	elif [[ "$length" = "1" ]]; then
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text '🔑 keygen 🔑' --callback_data "/keygen ${script_def}"
		if [[ $(cat ${confJSON}|jq -r .script[0].status) = "ON" ]]; then
			idden="Ocul ✅"
			status="OFF"
		else
			idden="Most ❌"
			status="ON"
		fi
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text "${idden}" --callback_data "/idden 0 ${status}"
		ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text "🗑" --callback_data "/quitar 0"
	fi
}

ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'actualizar' --callback_data '/actualizar'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'reboot' --callback_data '/reboot'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 1 --text 'ayuda' --callback_data '/ayuda'
ShellBot.InlineKeyboardButton --button 'botao_extra' --line 2 --text '<<< menu' --callback_data '/menu edit'



ShellBot.InlineKeyboardButton --button 'botao_atras' --line 1 --text 'menu' --callback_data '/menu edit'



ShellBot.InlineKeyboardButton --button 'botao_list' --line 1 --text 'menu' --callback_data '/menu edit'
ShellBot.InlineKeyboardButton --button 'botao_list' --line 1 --text 'info' --callback_data '/info'



ShellBot.InlineKeyboardButton --button 'botao_up' --line 1 --text 'menu' --callback_data '/menu'


btn_menukey(){
	unset botao_key
	botao_key=''
	ShellBot.InlineKeyboardButton --button 'botao_key' --line 1 --text 'menu' --callback_data '/menu'
	ShellBot.InlineKeyboardButton --button 'botao_key' --line 1 --text 'keygen' --callback_data "/keygen ${comando[1]}"
}

btn_keymenu(){
	unset botao_keyMenu
	botao_keyMenu=''
	length=$(jq '.script | length' ${confJSON})
	def=$(jq -r '.default' < $conf_json)
	n=1
	for (( i = 0; i < ${length}; i++ )); do
		name=$(cat ${confJSON}|jq -r .script[$i].name)

		if [[ $(cat ${confJSON}|jq -r .script[$i].dev) = "false" ]]; then
			ShellBot.InlineKeyboardButton 	--button 'botao_keyMenu' --line $n --text "${name}" --callback_data "/keygen $i"
			if [[ $def = $i ]]; then
				_def="Default ✅"
				_name=''
			else
				_def="Set def ❌"
				_name="$i"
			fi
			ShellBot.InlineKeyboardButton 	--button 'botao_keyMenu' --line $n --text "${_def}" --callback_data "/default ${_name}"

			if [[ $(cat ${confJSON}|jq -r .script[$i].status) = "ON" ]]; then
				idden="Ocul ✅"
				status="OFF"
			else
				idden="Most ❌"
				status="ON"
			fi
			ShellBot.InlineKeyboardButton 	--button 'botao_keyMenu' --line $n --text "${idden}" --callback_data "/idden $i ${status}"
			ShellBot.InlineKeyboardButton 	--button 'botao_keyMenu' --line $n --text "🗑" --callback_data "/quitar $i"
			let n++
			fi
	done
	ShellBot.InlineKeyboardButton 	--button 'botao_keyMenu' --line $n --text "menu" --callback_data '/menu edit'
}

sendID(){
	unset botao_send_id
	botao_send_id=''
	ShellBot.InlineKeyboardButton 	--button 'botao_send_id' --line 1 --text "enviar al admin" --callback_data '/sendid edit'
	ShellBot.InlineKeyboardButton 	--button 'botao_send_id' --line 1 --text "menu" --callback_data '/menu edit'
}

saveID(){
	unset botao_save_id
	botao_save_id=''
	ShellBot.InlineKeyboardButton 	--button 'botao_save_id' --line 1 --text "Autorizar ID" --callback_data "/saveid $1"
}

botao_listmenu=''
ShellBot.InlineKeyboardButton 	--button 'botao_listmenu' --line 1 --text 'menu' --callback_data '/menu edit'
ShellBot.InlineKeyboardButton 	--button 'botao_listmenu' --line 1 --text 'list' --callback_data '/list edit'

ShellBot.InlineKeyboardButton --button 'botao_donar' --line 1 --text 'Donar Paypal' --callback_data '1' --url 'https://www.paypal.me/Rufu99'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 2 --text 'Donar MercadoPago ARG' --callback_data '1' --url 'http://mpago.li/1SAHrwu'
ShellBot.InlineKeyboardButton --button 'botao_donar' --line 3 --text 'Acortador adf.ly' --callback_data '1' --url 'http://caneddir.com/2J9J'


# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do
	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    echo $chatuser >&2
	    comando=(${message_text[$id]})
	    [[ ! -e "Admin-ID" ]] && echo "null" > Admin-ID
	    permited=$(cat Admin-ID)
	    comand
    done
done
