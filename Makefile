PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/7.3.2/libreoffice-7.3.2.2.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/7.3.2/libreoffice-dictionaries-7.3.2.2.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.3.2/libreoffice-help-7.3.2.2.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.3.2/libreoffice-translations-7.3.2.2.tar.xz ./ https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m97-a7230803d64ae9d44f4e1282444801119a3ae967.tar.xz : https://dev-www.libreoffice.org/src/neon-0.31.2.tar.gz :

include ../common/Makefile.common
