PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-24.2.0.3.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-dictionaries-24.2.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-help-24.2.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-translations-24.2.0.3.tar.xz ./ https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m116-2ddcf183eb260f63698aa74d1bb380f247ad7ccd.tar.xz :

include ../common/Makefile.common
