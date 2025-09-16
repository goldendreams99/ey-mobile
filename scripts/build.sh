read -p "Clean project (y/n)?" clean
if [[ $clean =~ ^(yes|y|Y|Yes| ) ]] || [[ -z $clean ]]; then flutter clean; fi

read -p "Build environment (dev/release)?" environment

read -p "Build android (y/n)?" android
if [[ $android =~ ^(yes|y|Y|Yes| ) ]] || [[ -z $android ]];
then
    if [[ $environment =~ ^(dev|d|development| ) ]]; 
        then 
            flutter build appbundle --release --target lib/main_dev.dart --flavor=staging
            flutter build apk --release --target lib/main_dev.dart --flavor=staging  --split-per-abi
    fi
    if [[ $environment =~ ^(rel|r|release| ) ]] || [[ -z $environment ]]; 
        then 
            flutter build appbundle --release --target lib/main_release.dart --flavor=production
            flutter build apk --release --target lib/main_release.dart --flavor=production  --split-per-abi
    fi
fi
read -p "Build ios (y/n)?" ios
if [[ $ios =~ ^(yes|y|Y|Yes| ) ]] || [[ -z $ios ]];
then
    read -p "Remove Pods (y/n)?" pods
    if [[ $pods =~ ^(yes|y|Y|Yes| ) ]] || [[ -z $pods ]];
    then    cd ios/
        echo 'removing PodFile.lock';
        rm PodFile.lock
        echo 'removing prev Pods packages';
        rm -rf Pods/
        cd ..
    fi
    if [[ $environment =~ ^(dev|d|development| ) ]]; then flutter build ios --target lib/main_dev.dart --flavor=staging; fi
    if [[ $environment =~ ^(rel|r|release| ) ]] || [[ -z $environment ]]; then flutter build ios --target lib/main_release.dart --flavor=production; fi
fi