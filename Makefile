PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/7.4.2/libreoffice-7.4.2.3.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/7.4.2/libreoffice-dictionaries-7.4.2.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.4.2/libreoffice-help-7.4.2.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.4.2/libreoffice-translations-7.4.2.3.tar.xz ./ https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m103-b301ff025004c9cd82816c86c547588e6c24b466.tar.xz : https://dev-www.libreoffice.org/src/neon-0.31.2.tar.gz :

include ../common/Makefile.common
