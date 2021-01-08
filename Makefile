PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/7.0.4/libreoffice-7.0.4.2.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/7.0.4/libreoffice-dictionaries-7.0.4.2.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.0.4/libreoffice-help-7.0.4.2.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/7.0.4/libreoffice-translations-7.0.4.2.tar.xz ./ https://dev-www.libreoffice.org/src/QR-Code-generator-1.4.0.tar.gz : https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m85-e684c6daef6bfb774a325a069eda1f76ca6ac26c.tar.xz : https://dev-www.libreoffice.org/src/neon-0.30.2.tar.gz :

include ../common/Makefile.common
