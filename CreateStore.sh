#!/bin/sh

#source $HOME/.bash_profile

#---------------------------------#
# dynamically build the classpath #
#---------------------------------#
CLASSPATH=
for i in `ls /usr/local/trustlab-apps/lib/util/*.jar`
do
  CLASSPATH=${CLASSPATH}:${i}
done

for i in `ls /usr/local/trustlab-apps/lib/jena262/*.jar`
do
  CLASSPATH=${CLASSPATH}:${i}
done


echo ${CLASSPATH}
export CLASSPATH

TEMP=/usr/local/trustlab-apps/visko-3.0-triple-store/staging-area
pwd

URLS=('http://rio.cs.utep.edu/ciserver/ciserver/viewresource/visko-operator/' 'http://rio.cs.utep.edu/ciserver/ciserver/viewresource/visko-service/' 'http://rio.cs.utep.edu/ciserver/ciserver/viewresource/visko-view/' 'http://rio.cs.utep.edu/ciserver/ciserver/viewresource/visko/')

rm -rf $TEMP/*
cd $TEMP

wget -nv -r -c -nH -np --domains=minas.cs.utep.edu --reject=v2.owl,.txt,.pdf,.jpg,.png,.hsr,.csr,.htm,.html http://minas.cs.utep.edu/visko/ontology/

for url in ${URLS[*]}
do
   wget -nv -l1 -r -c -nc -nH --domains=rio.cs.utep.edu --reject=v2.owl,.txt,.pdf,.jpg,.png,.hsr,.csr,.htm,.html $url
done

# clear temp folder where I rename the ciserver html files labed as ".owl" to ".html"
rm /minas/web/visko-temp/* -f

cd /usr/local/trustlab-apps/visko-3.0-triple-store/staging-area/ciserver/visko
for i in *.owl; do cp "$i" /minas/web/visko-temp/"`basename $i .owl`.html"; done

cd $TEMP

wget --include-directories=/visko-temp/,/ciserver/ciprojects/visko --level=3 --domains=trust.utep.edu,rio.cs.utep.edu --exclude-domains=acquia.com,drupal.org,topnotchthemes.com,cybershare.utep.edu,www.teragrid.org -H -r -c -nH -np -nv --reject=.txt,.pdf,.jpg,.png,.hsr,.csr,.htm,.html,visko.owl,visko-v1.owl http://trust.utep.edu/visko-temp/

cd /usr/local/trustlab-apps/visko-3.0-triple-store/

groovy ./CreateTripleStore.groovy $TEMP

rm /home/users/tomcat/visko-triple-store/TDB-VISKO-3/* -f
cp triple-store/TDB-VISKO-3/* /home/users/tomcat/visko-triple-store/TDB-VISKO-3/
