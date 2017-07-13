#You need
#curl, wget, node, npm
VERSION=$(curl https://updates.counterplay.co/ | grep duelyst |grep -v staging | grep zip | tail -c 18 | head -c 6)
wget http://downloads.counterplay.co/duelyst/v$VERSION/duelyst-v$VERSION-win32-ia32.zip

#remove old stuff
rm -rf Duelyst-linux-ia32

#extract it
rm -rf duelyst-v$VERSION
unzip duelyst-v$VERSION-win32-ia32.zip -d duelyst-v$VERSION

#tweak app
cd duelyst-v$VERSION/resources/app
sed -i "s/app.on('ready', function () {/app.on('ready', function () {\n  argv.token = '32432543254'\n/" desktop.js
sed -i "/if (pkgJson.name === 'duelyst' && argv.token === undefined) {/,+12d" desktop.js
sed -i "s/fullscreen: \!argv.windowed/fullscreen: false/" desktop.js
sed -i "s/if (process.platform === 'win32') setupWin32Shortcuts()/if (process.platform === 'win32' || process.platform === 'linux') setupWin32Shortcuts()/" desktop.js

##You can optionally add T2k5 scripts lines here
## for example:decktracker module
#echo "\n $.getScript('https://duelyststats.info/scripts/deckTracker.js', function(){});" >  duelyst-v$VERSION/resources/app/src/duelyst.js

##bundle module
#echo "\n$.getScript('https://duelyststats.info/scripts/bundle.js', function(){});\n" >>  /home/mycroft/my_games/duelyst-v$VERSION/resources/app/src/duelyst.js
#echo " $.getScript('https://duelyststats.info/scripts/newstatscript.js', function(){});
#    $.getScript('https://duelyststats.info/scripts/collectionEnhancement.js', function(){var collectionMod = new CollectionEnhancementModule();});" >>  /home/mycroft/my_games/duelyst-v$VERSION/resources/app/src/duelyst.js



#build it
npm install electron-prebuilt --save
npm install 
npm install electron-packager --save-dev
sudo npm install electron-packager -g 
electron-packager . $npm_package_productName --asar --platform=linux --overwrite --arch=ia32 --app-version=$npm_package_version --icon=icon.icns --out=build --ignore='build|node_modules/gulp-*|node_modules/(electron-packager|electron-prebuilt|electron-rebuild|electron-windows-installer|electron-connect|gulp|tape)'

#make the folder
mv build/Duelyst-linux-ia32/ ../../../

#remove working folder
cd ../../..
rm -rf duelyst-v$VERSION

#zip it for backup
#zip -r Duelyst-linux-x32-v$VERSION.zip Duelyst-linux-ia32/

##modded version

