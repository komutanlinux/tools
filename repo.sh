#!/bin/bash

VERSIYON='0.4'
PAKET_KLASOR='/var/www/html/komutan'
KOD_ADI='raiders'
GPGKEY='..'

# kullanim bilgisi
kullanim() {
        echo "$0 $VERSIYON - repoya deb paketi ekleme aracidir."
        echo "Kullanimi:"
        echo "  --ekle|-e <paket-yolu/paket-adi.deb>"
        echo "          Repoya yeni paket ekler.."
        echo "  --sil|-s paket-adi"
        echo "          Belirtilen paketi repodan siler.."
        echo "  --sil-hepsi|-sh"
        echo "          Repodan tum paketleri siler, ONAY ISTEMEZ!"
        echo "  --list|-l"
        echo "          Repodaki tum paketleri listeler.."
        echo "  --ara|-a <paket-adi>"
        echo "          Belirtilen paket adini arar.."
        echo "  --imzala | -i <paket-yolu/paket-adi.db>"
        echo "          Belirtilen paketi imzalar.."
        exit  1
}

case $1 in
        --ekle|-e)
                if [ ! -f $2 ]; then echo "Dosya bulunamadi!"; exit 1; fi
                reprepro -Vb $PAKET_KLASOR includedeb $KOD_ADI $2;;

        --sil|-s)
                if [ -z $2 ]; then echo "Paket adi belirtilmelidir!"; exit 1; fi
                reprepro -Vb $PAKET_KLASOR remove $KOD_ADI $2;;

        --sil-hepsi|-sh)
                $0 -l | cut -d ' ' -f2 > sil.txt
                for i in $(cat sil.txt); do
                        $0 --sil $i
                done
                rm sil.txt;;

        --list|-l)
                reprepro -Vb $PAKET_KLASOR list $KOD_ADI;;

        --ara|-a)
                $0 -l | cut -d ' ' -f2 | grep $2;;

        --imzala|-i)
                if [ ! -f $2 ]; then echo "Dosya bulunamadi!"; exit 1; fi
                debsigs --sign=origin -k $GPGKEY $2;;

        *)
                kullanim;;
esac