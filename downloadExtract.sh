# source apps.properties
prop_file=$(find . -iname "apps.properties" | xargs -I {} realpath {})


get_prop(){
    # set -x
    prop_key=$1
    # prop_file=$(find . -iname "$prop_file" >/dev/null 2>&1 || { echo "Property file '$prop_file' not found!"; return 1; })
    local prop_value=$(grep -ir "${prop_key}=" $prop_file | cut -d'=' -f2- | tr -d '\t' | tr -d '\r')
    echo "$prop_value"
}

for app in $(grep -ir "app.=" $prop_file |tr -d '\r' | cut -d'=' -f1);
do 

    echo "app name : $(get_prop $app)"
    echo "app download link : $(get_prop $app.download_link)"
    echo "app start port : $(get_prop $app.port)"
    
    isAlreadyDownloaded=$(grep -ir "$(get_prop $app)" downloadStatus | cut -d'|' -f1 | tr -d ' ')
    if [ "$isAlreadyDownloaded" == "$(get_prop $app)" ]; then
        echo "$(get_prop $app) is already downloaded. Skipping download and extract."
        continue
    fi

    rm -rf $(get_prop $app)
    mkdir -p $(get_prop $app)
    cd $(get_prop $app)
    extension=$(get_prop $app.download_link | rev | cut -d'.' -f1 | rev)
    # set -x
    wget $(get_prop $app.download_link)
    # set +x
    mv $(get_prop $app)*.$extension "$(get_prop $app).$extension"
    if [ "$extension" == "zip" ]; then
        unzip $(get_prop $app).$extension
    elif [ "$extension" == "tar" ] || [ "$extension" == "gz" ] || [ "$extension" == "tgz" ]; then
        tar --strip-components=1 -vzxf $(get_prop $app).$extension
    else
        echo "No need to extract $extension file"
    fi
    cd ..   
    echo "$(get_prop $app) | Y " >> downloadStatus  
done