#!/bin/bash

starttime=`date +'%Y-%m-%d %H:%M:%S'`

echo "------------ start -------------"

wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36" "https://site.ip138.com/gitee.io" -O gitee.io-ip-search &> /dev/null

cat ./gitee.io-ip-search | grep -o -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | uniq > gitee.io-real-ip

echo "----------- execute for loop ------------"

for ip in `cat gitee.io-real-ip`
do
wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36" "https://site.ip138.com/"$ip -O $ip"-url-search" &> /dev/null
cat $ip"-url-search" | grep '"date"' |awk -F '("/|/")' '{print $2}' > $ip"-real-url"
rm -rf $ip"-url-search"

if [[ `cat $ip"-real-url" | grep "gitee.io" | wc -l` -eq 0 ]];then
rm $ip"-url-search" $ip"-real-url" -rf
continue
fi

for j in `cat $ip"-real-url"`
do
res=`curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36" -s --head -L "https://"$j --connect-timeout 3 | grep "HTTP/" | awk '{printf $2}'`
if [[ $res -eq 200 ]]
then
echo $j >> all-real-url
fi
done

rm $ip"-real-url" -rf
done

cat all-real-url | awk '!a[$0]++' > real-urls 
rm all-real-url -rf

for j in `cat real-urls`
do
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36" -s -L "https://"$j -o tmp
if [[ $? -eq 0 ]]
then
title=`cat tmp | grep -m 1 "<title>"  | awk -F '</title>' '{print $1}' | awk -F '>' '{print $NF}'`
rm -rf ./tmp
if [[ "$title" = "" ]]
then
echo '  <a href="https://'$j'" target="_blank">
    <article>'$j'</article>
    </a>' >> index.html
else
echo '  <a href="https://'$j'" target="_blank">
    <article>'$title'</article>
    </a>' >> index.html
fi
else
echo '  <a href="https://'$j'" target="_blank">
    <article>'$j'</article>
    </a>' >> index.html
fi
done




endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_s=`date --date="$starttime" +%s`
end_s=`date --date="$endtime" +%s`

echo '本次运行时间： '`expr $end_s - $start_s`'s'
