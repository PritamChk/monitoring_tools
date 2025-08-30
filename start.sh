# source apps.properties
prop_file=$(find . -iname "apps.properties" | xargs -I {} realpath {})


get_prop(){
    # set -x
    prop_key=$1
    # prop_file=$(find . -iname "$prop_file" >/dev/null 2>&1 || { echo "Property file '$prop_file' not found!"; return 1; })
    local prop_value=$(grep -ir "${prop_key}=" $prop_file | cut -d'=' -f2- | tr -d '\t' | tr -d '\r')
    echo "$prop_value"
}

echo "SELECT THE APP[1-9] TO START"
echo "----------------------"
grep -ir "app.=" $prop_file |tr -d '\r' | sed "s|=| = |g"
echo "----------------------"
echo -n "Enter your choice: "
read no
echo "----------------------"

app_name="app${no}"

case "$app_name" in
    "app1")
        app_key="app1"
        app_name=$(get_prop $app_key)
        cd ${app_name}/bin
        pwd
        cp -v ../conf/defaults.ini ./custom.ini
        sed -i "s|^http_port = .*|http_port = $(get_prop $app_key.port)|" ./custom.ini
        ./"${app_name}" server --config ./custom.ini > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app2")
        app_key="app2"
        app_name=$(get_prop $app_key)
        cd ${app_name}
        pwd
        ./"${app_name}" --web.enable-lifecycle --web.listen-address=0.0.0.0:$(get_prop $app_key.port) --storage.tsdb.retention.time=1d  --storage.tsdb.retention.size=2GB > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid 
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app3")
        app_key="app3"
        app_name=$(get_prop $app_key)
        cd ${app_name}
        pwd
        ./"${app_name}" --web.listen-address=0.0.0.0:$(get_prop $app_key.port) --data.retention=48h > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid 
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app4")
        app_key="app4"
        app_name=$(get_prop $app_key)
        cd ${app_name}
        pwd
        ./"${app_name}" --web.listen-address=0.0.0.0:$(get_prop $app_key.port) > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid 
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app5")
        app_key="app5"
        app_name=$(get_prop $app_key)
        cd ${app_name}
        pwd
        ./"${app_name}" --web.listen-address=0.0.0.0:$(get_prop $app_key.port) > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid 
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app6")
        app_key="app6"
        app_name=$(get_prop $app_key)
        cd ${app_name}
        pwd
        if [ ! -f loki ]; then
            mv -v loki-linux-amd64 loki
            chmod +x loki
            echo "loki binary name should be moved / renamed from loki-linux-amd64 to loki . . . so renaming done."
        fi
        ./"${app_name}" -server.http-listen-port=$(get_prop $app_key.port) -config.file=loki-config.yaml > ${app_name}.log 2>&1 & 
        jobs -p > ${app_name}.pid 
        echo "$app_name started on port $(get_prop $app_key.port)."
        ;;
    "app7")
        app_key="app7"
        ;;
    "app8")
        app_key="app8"
        ;;
    "app9")
        app_key="app9"
        ;;
    *)
        echo "Invalid app name. Please provide a valid app name (app1, app2, app3)."
        exit 1
        ;;
esac