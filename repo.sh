#!/bin/bash

VERSIYON='0.1'
PAKET_KLASOR='/var/www/html/komutan'
KOD_ADI='raiders'

# kullanim bilgisi
kullanim() {
	echo "$0 $VERSIYON - repoya deb paketi ekleme aracidir."
	echo "Kullanimi:"
	echo "	$0 ekle|-e paket-adi.deb"
	echo "	$0 sil|-s paket-adi"
	echo "	$0 list|-l"
	exit  1
}
[[ $# -eq 0 ]] && kullanim

# dosya var mi?
dosya_var_mi(){
	local f="$1" #fonksiyona gonderilen ilk deger
	[[ -f "$f" ]] && return 0 || return 1
}

case $1 in
	ekle|-e)
		if ( ! dosya_var_mi "$2" ); then echo "Dosya bulunamadi!"; exit 1; fi
		reprepro -Vb $PAKET_KLASOR includedeb $KOD_ADI $2;;
	sil|-s)
		reprepro remove $KOD_ADI $2;;
	list|-l)
		reprepro list $KOD_ADI;;
	*)
		kullanim;;
esac
