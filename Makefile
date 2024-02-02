PKG_NAME := libreoffice
URL = https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-24.2.0.3.tar.xz
ARCHIVES = https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-dictionaries-24.2.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-help-24.2.0.3.tar.xz ./ https://download.documentfoundation.org/libreoffice/src/24.2.0/libreoffice-translations-24.2.0.3.tar.xz ./ https://dev-www.libreoffice.org/src/dtoa-20180411.tgz : https://dev-www.libreoffice.org/src/skia-m111-a31e897fb3dcbc96b2b40999751611d029bf5404.tar.xz :

include ../common/Makefile.common
