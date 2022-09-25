export PATH="/home/$USER/.config/nvim/language-servers:$PATH";

# fzf keybindings
source /usr/share/doc/fzf/examples/key-bindings.bash;

# my bash aliases
alias update='sudo apt update;
	sudo apt upgrade;
	sudo apt autoremove --purge;
	sudo apt autoclean;
	tput setaf 6;
	figlet -ct -f kmono Complete'
	# flatpak update;
	# sudo snap refresh;

alias asciiquarium='snap run asciiquarium'

function clock() {
	str=$(curl -s wttr.in/?format="%l:+%C+%t+%p\n");
	tput civis;
	watch -ct -n 1 "
	tput setaf 14;
	date '+%T'|figlet -ct -f kmono;
	tput setaf 7;
	tput bold;
	tput sgr0;
	date '+%A%t%D'|figlet -ct -f future;
	# echo '\n';
	tput setaf 7;
	figlet -ct -f term $str;"
	tput cnorm;
}

function note-upload(){
	cd ~/Documents/Notes/;
	git add --all -- ':!*.pdf';
	git add tex -- ':!*.pdf';
	git add md -- ':!*.pdf';
	git add Quick_Notes -- ':!*.pdf';
	git add cpp;
	git add pdf;
	printf "\n";
	git commit -m "$(date +'%d/%m/%Y')";
	printf "\n";
	git push -u origin main;
	# sudo ssmtp kalankaboom@murena.io < email.txt;
}

alias note-pull='cd ~/Documents/Notes/; git pull "git@github.com:kalankaboom/sv-notes.git";'

function note(){
	FILE_TYPE=$(echo $1 | grep -E -o '\..+')
	FILE_DIR=~/Documents/Notes/$(echo $FILE_TYPE | grep -E -o '[^\.]+')
	FILE_PATH=$FILE_DIR/$1
	if [ -n "$(echo $1 | grep -o '/')" ]; then
		FILE_DIR=$FILE_DIR/$(echo $1 | grep -P -o '.+(?=/.+\.)')
	fi
	if [ ! -d "$FILE_DIR" ]; then
		mkdir -p $FILE_DIR;
	fi
	TEMP=$(find ~/Templates/Quickplates/ -type f -name "*$FILE_TYPE")
	if [ -f "$FILE_PATH" ]; then
		echo -e "\e[95;1mFile already exists!\e[0m"
	else
		cp $TEMP $FILE_PATH;
		if [ "$FILE_TYPE" = ".tex" ] || [ "$FILE_TYPE" = ".md" ]; then
			nvim -c "%s/\[today\]/\=strftime('%d-%m-%Y')" -c "%s/\[title\]/\=expand('%:t:r')" $FILE_PATH;
		else
			nvim $FILE_PATH;
		fi
	fi
}

#function checkbt() {
#	if [ "$(hciconfig -a|grep -o DOWN)" == "DOWN" ];
#	then
#		echo 'OFF';
#	else
#		echo 'ON';	
#	fi
#}
