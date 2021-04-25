url="$1"
download_manga() {
	tty="$(ps -eo comm,tty |
		grep manga-dl |
		awk '{print $2}')"
	if [ -z "$tty" ]; then return 1; fi
	pane_id="$(tmux list-panes -aF'#{pane_tty} #D' |
		grep "$tty" |
		awk '{print $2}')"
	if [ -z "$pane_id" ]; then return 1; fi
	tmux send -lt "$pane_id" "$url"
	tmux send  -t "$pane_id" $'\n'
}
view_nitter_image() {
	/bin/feh "$url" 2> /dev/null &
}
view_image() {
	/bin/feh "$url" 2> /dev/null &
}
view_video() {
	mpv "$url"
}
open_in_browser() {
	palemoon "$url" &
}

case "$url" in
#	( *mangadex.org*    ) download_manga ;;
	( *nitter.*.jpg  ) view_nitter_image ;;
	( *nitter.*.jpeg ) view_nitter_image ;;
	( *nitter.*.png  ) view_nitter_image ;;
	( *.jpg             ) view_image ;;
	( *.jpeg            ) view_image ;;
	( *.png             ) view_image ;;
	( *.gif             ) view_image ;;
	( *.mp4             ) view_video ;;
	( *                 ) open_in_browser ;;
esac
