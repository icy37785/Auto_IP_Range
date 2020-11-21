#!/bin/bash

set -e
if [ -e ALL_IP.txt ] ; then rm ALL_IP.txt ; fi
if [ -e Amazon.txt ] ; then rm Amazon.txt ; fi
if [ -e Netflix.txt ] ; then rm Netflix.txt ; fi
if [ -e Telegram.txt ] ; then rm Telegram.txt ; fi

curl -s "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN-CSV&license_key=${LICENSE_KEY}&suffix=zip" >ip_ranges.zip
for as in $(unzip -p ip_ranges.zip `unzip -l ip_ranges.zip |grep -e GeoLite2-ASN-Blocks-IPv4.csv | sed 's/^.\{30\}//g'` | grep -i netflix | cut -d"," -f2 | sort -u)
    do
		whois -h whois.radb.net -- '-i origin AS'$as | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>netflix.tmp
		whois -h whois.radb.net -- '-i origin AS2906' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>netflix.tmp
		whois -h whois.radb.net -- '-i origin AS394406' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>netflix.tmp
		whois -h whois.radb.net -- '-i origin AS40027' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>netflix.tmp
		whois -h whois.radb.net -- '-i origin AS55095' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>netflix.tmp
done
cat netflix.tmp | aggregate -q >Netflix.txt

curl -s https://ip-ranges.amazonaws.com/ip-ranges.json |grep ip_prefix |cut -d"\"" -f4 >>amazon.tmp
cat amazon.tmp | aggregate -q >Amazon.txt

for as in $(unzip -p ip_ranges.zip `unzip -l ip_ranges.zip |grep -e GeoLite2-ASN-Blocks-IPv4.csv | sed 's/^.\{30\}//g'` | grep -i Telegram | cut -d"," -f2 | sort -u)
    do
     whois -h whois.radb.net -- '-i origin AS'$as | grep -Eo "([0-9.]+){4}/[0-9]+" | tee telegram_ranges.txt >>telegram.tmp
     whois -h whois.radb.net -- '-i origin AS62041' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee telegram_ranges.txt >>telegram.tmp
     whois -h whois.radb.net -- '-i origin AS62014' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee telegram_ranges.txt >>telegram.tmp
     whois -h whois.radb.net -- '-i origin AS59930' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee telegram_ranges.txt >>telegram.tmp
     whois -h whois.radb.net -- '-i origin AS44907' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee telegram_ranges.txt >>telegram.tmp
done
cat telegram.tmp | aggregate -q >Telegram.txt

cat netflix.tmp amazon.tmp telegram.tmp | aggregate -q >ALL_IP.txt

rm ip_ranges.zip
rm netflix.tmp
rm netflix_ranges.txt
rm amazon.tmp
rm telegram.tmp
rm telegram_ranges.txt