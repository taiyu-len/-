clear
for i in "$HOME"/.config/bash/*.bash "$HOME"/.config/zsh/*.zsh
do
	source $i
done
daily_message
