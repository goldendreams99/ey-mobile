read -p "armeabi-v7a (y/n)?" armeabi
if [[ $armeabi =~ ^(yes|y|Y|Yes| ) ]] || [[ -z $armeabi ]];
    then
        adb install --abi armeabi-v7a build/app/outputs/apk/production/release/app-production-armeabi-v7a-release.apk
    fi
if [[ $armeabi =~ ^(no|n|N|No|NO|nO| ) ]] || [[ -z $armeabi ]]; 
    then 
        adb install --abi arm64-v8a build/app/outputs/apk/production/release/app-production-arm64-v8a-release.apk
fi
