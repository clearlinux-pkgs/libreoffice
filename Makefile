PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/7.1.0/libreoffice-7.1.0.3.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/7.1.0/libreoffice-dictionaries-7.1.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.1.0/libreoffice-help-7.1.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.1.0/libreoffice-translations-7.1.0.3.tar.xz ./ https://dev-www.libreoffice.org/src/QR-Code-generator-1.4.0.tar.gz : https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m88-59bafeeaa7de9eb753e3778c414e01dcf013dcd8.tar.xz : https://dev-www.libreoffice.org/src/neon-0.31.1.tar.gz :

include ../common/Makefile.common
