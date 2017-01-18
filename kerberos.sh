#!/bin/bash

#################################################
# to be used for  rc4-hmac
# or whatever that doesn't require JCE. Laziness! 
# ###############################################


printf "\n"
echo "............Installing kerberos server............"

yum install -y krb5-server
yum install  -y openldap-clients
yum -y install krb5-workstation


echo "............Updating krb5.conf file............"
sed -i  "s/EXAMPLE.COM/"${HOSTNAME^^}"/g" /etc/krb5.conf
sed -i  "s/kerberos.example.com/"${HOSTNAME}"/g" /etc/krb5.conf
sed -i  "s/example.com/"${HOSTNAME}"/g" /etc/krb5.conf


echo "............Updating kdc.conf file............"
sed -i "s/EXAMPLE.COM/"${HOSTNAME^^}"/g" /var/kerberos/krb5kdc/kdc.conf

sed -i 's/dict_file/max_life = 1d/g' /var/kerberos/krb5kdc/kdc.conf
sed -i  's/dict_file/max_renewable_life = 7d/g' /var/kerberos/krb5kdc/kdc.conf


echo "............Updating kadmn.acl............"
sed -i "s/EXAMPLE.COM/"${HOSTNAME^^}"/g" /var/kerberos/krb5kdc/kadm5.acl


echo ".............Creating database............"

kdb5_util create -s

echo '.............Start kerberos services..............'
printf "\n"
service krb5kdc start
printf "\n"
echo '>>>krb5kdc status'
service krb5kdc status

printf "\n"
echo ".............Start kerberos kadmin service.............."
service kadmin start
printf "\n"

echo '>>>kadmin status'
service kadmin status


