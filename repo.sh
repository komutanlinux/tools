#!/bin/bash

VERSIYON='0.5'
PAKET_KLASOR='/var/www/html/komutan'
KOD_ADI='raiders'
GPGKEY='..'

# kullanim bilgisi
kullanim() {
        echo "
        $0 $VERSIYON - repo uzerinde paket islemlerini kolaylastirma aracidir.

        Kullanimi:

        --ekle | -e <paket-yolu/paket-adi.deb>
                Repoya yeni paket ekler..

        --ekle-hepsi | -eh <klasor>
                Belirtilen tum paketleri once kontrol eder sonra ekler..

        --sil | -s paket-adi
                Belirtilen paketi repodan siler..

        --sil-hepsi | -sh
                Repodan tum paketleri siler, ONAY ISTEMEZ!

        --list | -l
                Repodaki tum paketleri listeler..

        --ara | -a <paket-adi>
                Belirtilen paket adini arar..

        --imzala | -i <paket-yolu/paket-adi.db>
                Belirtilen paketi imzalar..
        "
        exit  1
}

case $1 in
        --ekle|-e)
                if [ ! -f $2 ]; then echo "Dosya bulunamadi!"; exit 1; fi
                reprepro -Vb $PAKET_KLASOR includedeb $KOD_ADI $2;;

        --ekle-hepsi|-eh)
                if [ ! -d $2 ]; then echo "$2 klasoru bulunamadi!"; exit 1; fi
                for i in $(ls $2); do
                        $0 --ekle $2/$i
                done;;

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
                $0 --list | cut -d ' ' -f2 | grep $2;;

        --imzala|-i)
                if [ ! -f $2 ]; then echo "Dosya bulunamadi!"; exit 1; fi
                debsigs --sign=origin -k $GPGKEY $2;;

        *)
                kullanim;;
esac
