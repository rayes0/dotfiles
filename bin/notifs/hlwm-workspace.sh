#!/bin/bash
# Shows the workspace in a notification for when barless on hlwm

check_tags() {
    tags_list=( $(herbstclient tag_status) )
    tags=""      
    
    for t in "${tags_list[@]}"; do
        case $t in
            '#'*)
                tags="${tags} <b>${t#?}</b> " ;;
            '-'*)
                tags="${tags} <u><i>${t#?}</i></u> " ;;
            ':'*|'%'*)
                tags="${tags} ${t#?} " ;;
        esac
    done
}

query() {
    herbstclient -i &
    hpid=$!
    sleep 7
    kill $hpid
}

check_tags
id1=$(dunstify -p -h string:x-canonical-private-synchronous:barless-info "Workspaces" "$tags")

while read -r; do
    check_tags
    id2=$(dunstify -p -h string:x-canonical-private-synchronous:barless-info "Workspaces" "$tags")
done < <(query)

[ -n "$id1" ] && dunstify -C $id1
[ -n "$id2" ] && dunstify -C $id2
