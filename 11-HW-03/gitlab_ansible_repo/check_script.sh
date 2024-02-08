[ -z $NGINX_URL ] && { echo "Url needed to check md5"; exit 1; }
[ -z $CONTROL_FILE ] && { echo "Control file needed to check md5"; exit 1; }

responce () {
    TEXT=$1
    echo $TEXT
    echo "TELEGRAM_BOT_TOKEN: $TELEGRAM_BOT_TOKEN"
    echo "CHAT_ID:" $CHAT_ID
    curl    -X POST \
            -d "text=$TEXT&chat_id=$CHAT_ID" \
            https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage
    exit $2
}

check_curl_responce_code () {
    status_code=$(curl --write-out %{http_code} --silent --output /dev/null $NGINX_URL)

    if [[ "$status_code" -ne 200 ]] ; then
        responce "Site status changed to: $status_code" 1
    else
        responce "Site status: $status_code" 0
    fi
}

check_md5 () {

    online_md5="$(curl -sL $NGINX_URL | md5sum | cut -d ' ' -f 1)"
    echo "md5 of online page from $NGINX_URL: $online_md5"
    local_md5="$(md5sum "$CONTROL_FILE" | cut -d ' ' -f 1)"
    echo "md5 of control page file from $CONTROL_FILE: $local_md5"    

if [ "$online_md5" = "$local_md5" ]; then
    responce "SUCCESS: md5 of online page $NGINX_URL are equal md5 of control page file $CONTROL_FILE" 0
else
    responce "ERROR: md5 of online page $NGINX_URL NOT equal md5 of control page file $CONTROL_FILE" 1
fi
}

case $1 in

    check_md5)
        check_md5
        ;;

    check_curl_responce_code)
        check_curl_responce_code
        ;;

    *)
        echo "The script requires one of two parameters: check_md5\check_curl_responce_code"
        ;;
esac
