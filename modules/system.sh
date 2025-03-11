errMsg() {
  echo " 
                                             
  _/          _/  _/_/_/    _/      _/  Winbox     
 _/          _/  _/    _/    _/  _/     Installer V.1     
_/    _/    _/  _/_/_/        _/        Using Winbox 3.41     
 _/  _/  _/    _/    _/    _/  _/       Coded@Ariikun     
  _/  _/      _/_/_/    _/      _/           
                                             

Installation :
sudo bash setup install

Uninstall :
sudo bash setup remove
"
  exit 1
}

checkDep() {
  DISTRIBUTION=`sed "/^ID/s/ID=//gp" -n /etc/os-release`
  echo -n "The System Detected Wine is not installed. Installing wine and dependencies..."
  case $DISTRIBUTION in
    'fedora' | '"rhel"' | '"centos"' | '"IGN"' )
      dnf -q -y install wine wget curl > /dev/null 2>&1 || yum -q -y install wine wget curl > /dev/null 2>&1
      echo "OK"
    ;;
    'ubuntu' | 'debian' | '"elementary"' | 'zorin' | 'linuxmint' | 'kali' | 'neon' | 'pop' | 'Deepin')
      if [ -f /etc/os-release ]
      then
        source /etc/os-release
      fi

      if [ $(echo $VERSION_ID | awk '{printf "%1.0f",$1}') -ge 18 ]
      then
        WINEPKG="wine-stable"
      else
        WINEPKG="wine"
      fi
      apt-get -q -y install $WINEPKG wget curl > /dev/null 2>&1
      echo "OK"
    ;;
    'arch' )
      sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
      pacman -Sy
      pacman -Sq --noconfirm wine wget curl > /dev/null 2>&1
      echo "OK"
    ;;
    *)
      echo "FAILED"
      exit 1
    ;;
  esac
}

wbxDL() {
  if [[ -f winbox.exe ]]
  then
    echo "Using previously downloaded winbox.exe"
  else
    echo -n "Downloading Winbox..."

    URL="https://download.mikrotik.com/routeros/winbox/3.41/winbox64.exe"
    if [[ $(uname -a | grep -o "x86_64") ]]; then
      URL=${URL}
    fi

    wget -q -c -O ./modules/winbox.exe $URL
    echo "OK"
  fi
}


movingFile() {
  echo -n "Copying files..."
  if [[ !$(mkdir -p /usr/local/bin) ]]
  then
    if [[ !$(cp -f ./modules/winbox.exe /usr/local/bin/winbox.exe) ]]
    then
    	cp -f ./modules/winbox.sh /usr/local/bin/winbox.sh
    	chmod a+x /usr/local/bin/winbox.sh
	    chmod a+x /usr/local/bin/winbox.exe
	    for size in $( ls -1 icons/winbox-*.png | cut -d\- -f2 | cut -d\. -f1 | paste -sd ' ') ; do
		    mkdir -p /usr/share/icons/hicolor/${size}/apps/
		    cp -f icons/winbox-${size}.png /usr/share/icons/hicolor/${size}/apps/winbox.png
	    done
      echo "OK"
    else
      echo "FAILED"
      exit 1
    fi
  else
    echo "FAILED"
    exit 1
  fi
}

lncCrt() {
  echo -n "Creating application launcher..."
  if touch /usr/share/applications/winbox.desktop
  then
    echo "[Desktop Entry]" > /usr/share/applications/winbox.desktop
    echo "Name=Winbox" >> /usr/share/applications/winbox.desktop
    echo "GenericName=Configuration tool for RouterOS" >> /usr/share/applications/winbox.desktop
    echo "Comment=Configuration tool for RouterOS" >> /usr/share/applications/winbox.desktop
    echo "Exec=/usr/local/bin/winbox.sh" >> /usr/share/applications/winbox.desktop
    echo "Icon=winbox" >> /usr/share/applications/winbox.desktop
    echo "Terminal=false" >> /usr/share/applications/winbox.desktop
    echo "Type=Application" >> /usr/share/applications/winbox.desktop
    echo "StartupNotify=true" >> /usr/share/applications/winbox.desktop
    echo "StartupWMClass=winbox.exe" >> /usr/share/applications/winbox.desktop
    echo "Categories=Network;RemoteAccess;" >> /usr/share/applications/winbox.desktop
    echo "Keywords=winbox;mikrotik;" >> /usr/share/applications/winbox.desktop
    xdg-desktop-menu forceupdate --mode system
    echo "OK"
  else
    echo "FAILED"
    exit 1
  fi
}

filesRm() {
  echo -n "Purging launcher..."
  find /usr/share/applications/ -name "winbox.desktop" -delete
  echo "OK"

  echo -n "Purging icons..."
  find /usr/share/icons -name "winbox.png" -delete
  echo "OK"

  echo -n "Removing files..."
  rm -rf /usr/local/bin/winbox.exe
  rm -rf /usr/local/bin/winbox.sh
  echo "OK"
}

if [ -z "$1" ]; then
  errMsg;
fi
case $1 in
  'install' )
    if [[ ! $(wine --version) ]]
    then
        checkDep
    fi
    if wbxDL
    then
      if movingFile
      then
        lncCrt
      else
        echo "FAILED"
        exit 1
      fi
    else
      echo "FAILED"
      exit 1
    fi
  ;;

  'purge' )
    filesRm
  ;;

  * )
    errMsg
  ;;
esac
