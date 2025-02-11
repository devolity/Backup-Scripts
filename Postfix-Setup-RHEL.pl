#! /usr/bin/perl -wl

print "########System Status##########";
$cen=system("cat /etc/issue | grep Cen");
$un = system("getconf LONG_BIT");
$value = qx(postconf -d | grep mail_version | grep 2.6);
chomp $value;
print $value;
$a="mail_version = 2.6.6";
if("$value" eq "$a"){&inst;}else{&upgrade;}
sub inst{
print q(Enter number for which you want to make instance);
chomp($input_num = <STDIN> );
print "Enter real hostname";
chomp($host=<STDIN>);
print "Enetr main ip";
chomp($ip=<STDIN>);
print q(Enter Domain Name);
chomp($domain = <STDIN> );

print "Enter root password";
chomp($root_pass=<STDIN>);
print "Enter selector name";
chomp($selector = <STDIN> );

$name=system("yum install bind -y");
print $name;
$edns=system("echo -e '\$TTL 2h\;
\@ IN SOA $host hostmaster.domain.com (
           1            ; Serial
           10800        ; Refresh after 3 hours
           3600         ; Retry after 1 hour
           604800       ; Expire after 1 week
           3600 )       ; Minimum TTL of 1 hour
\@                         IN    NS $host.
$host. IN A  $ip' > /var/named/$domain");
print $edns;
$number = 1;
$po=system(" postmulti -e init ");
print $po;
$rmresolve=system("rm -f /etc/resolv.conf");
print $rmresolve;
$resolveentry=system("echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' > /etc/resolv.conf");
print $resolveentry;
$rmhosts=system("rm -f /etc/hosts");
print $rmhosts;
$hostsentry=system("echo -e '127.0.0.1       localhost
$ip     $host' > /etc/hosts");
print $hostsentry;

 while ($number <= $input_num)
  {
     print qq(Please enter $number Hostname);
     chomp($number_host = <STDIN>);
     print qq(Please enter $number IP);
     chomp($number_IP = <STDIN> );
     $out=system("postmulti -I postfix-out$number -G mta -e create");
     print $out;
     $host_ed1=system("echo -e '$number_IP                $number_host' >> /etc/hosts");
     print $host_ed1;
     $hdc=system("sed -i 's/#header_checks/#header_checks/' /etc/postfix-out$number/main.cf");
     print $hdc;
     $out_myhost=system("sed -i 's/#myhostname = host.domain.tld/myhostname = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_myhost;
     $out_inet=system("sed -i 's/inet_interfaces = all/inet_interfaces = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_inet;
     $out_inet1=system("sed -i 's/inet_interfaces = localhost/inet_interfaces = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_inet1;
     $out_mynetwork=system("sed -i 's/#mynetworks_style = host/mynetworks_style = host/' /etc/postfix-out$number/main.cf");
     print $out_mynetwork;
     $out_auth=system("sed -i 's/authorized_submit_users = /authorized_submit_users = root/' /etc/postfix-out$number/main.cf");
     print $out_auth;
     $send=system("echo -e 'sender_based_routing = yes' >> /etc/postfix-out$number/main.cf");
     print $send;
     $bind=system("echo -e 'smtp_bind_address = $number_IP' >> /etc/postfix-out$number/main.cf");
     print $bind;
     $alt=system("echo -e 'alternative_config_directories = /etc/postfix' >> /etc/postfix-out$number/main.cf");
     print $alt;
     $body=system("echo -e 'body_checks = regexp:/etc/postfix/body_checks' >> /etc/postfix-out$number/main.cf");
     print $body;
     $sender=system("echo -e 'smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access' >> /etc/postfix-out$number/main.cf");
     print $sender;
     $lastfiv=system("echo -e 'multi_instance_enable = yes
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
smtpd_sasl_security_options = noanonymous
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination' >> /etc/postfix-out$number/main.cf");
print $lastfiv;
$remove1=system("sed -i 's/master_service_disable = inet/#master_service_disable = inet/' /etc/postfix-out$number/main.cf ");
print $remove1;

$sasl_enter=system("echo -e '$number_host   root:$root_pass' >> /etc/postfix/sasl_passwd");
print $sasl_enter;

$e=system("echo -e '$number_host. IN A  $number_IP' >> /var/named/$domain");
print $e;
$ed=system("echo -e '\@ IN  MX        0 $number_host.' >> /var/named/$domain");
print $ed;
 $number++;
}

$post_myhost=system("sed -i 's/#myhostname = host.domain.tld/myhostname = $host/' /etc/postfix/main.cf");
print $post_myhost;
$hdcm=system("sed -i 's/#header_checks/header_checks/' /etc/postfix/main.cf");
print $hdcm;
$body_c=system("echo -e 'body_checks = regexp:/etc/postfix/body_checks' >> /etc/postfix/main.cf");
print $body_c;
$sender=system("echo -e 'smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/sender_access' >> /etc/postfix/main.cf");
print $sender;   
$post_inet=system("sed -i 's/inet_interfaces = all/inet_interfaces = $host/' /etc/postfix/main.cf");
print $post_inet;
 $r=system("sed -i 's/#relayhost = \$mydomain/relayhost = $domain/' /etc/postfix/main.cf");
print $r;
$post_lastfo=system("echo -e 'alternative_config_directories = /etc/postfix-out
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
maximal_queue_lifetime = 0
initial_destination_concurrency = 10
default_destination_concurrency_limit = 50' >> /etc/postfix/main.cf");
print $post_lastfo;

$own=chown (0,0, "/etc/postfix/sasl_passwd");
print $own;
$mod=chmod (0600, "/etc/postfix/sasl_passwd");
print $mod;

$header=system("echo -e '# Sample For Dropping Headers:
#/^Header: IfContains/          IGNORE
/^Received: from /              IGNORE
/^User-Agent:/                  IGNORE
/^X-Mailer:/                    IGNORE
/^X-Originating-IP:/            IGNORE' >> /etc/postfix/header_checks");

print $header;

$body_che=system("echo -e '/sarv/ REJECT BODY CHECKS (100 use word sarv in body)
/sarvmail/ REJECT BODY CHECKS (100 use word sarvmail in body)
/snet/ REJECT BODY CHECKS (100 use word snet in body)' >> /etc/postfix/body_checks");
print $body_che;

$sender_res=system("echo -e 'sarv.com REJECT FROM ADDRESS (SARV.COM NOT ALLOWED)
sarvmail.com REJECT FROM ADDRESS (SARVMAIL.COM NOT ALLOWED)
tld6.com REJECT FROM ADDRESS (TLD6.COM NOT ALLOWED)' >> /etc/postfix/sender_access");
print $sender_res;

$sen=system("yum install wget sendmail-devel  openssl* -y");
print $sen;
$pstmp=system("postmap /etc/postfix/sasl_passwd");
print $pstmp;
$psen=system("postmap /etc/postfix/sender_access");
print $psen;
$pbody=system("postmap /etc/postfix/body_checks");
print $pbody;

$hos=system("sed -i '/HOSTNAME/d' /etc/sysconfig/network");
print $hos;
$hos_ch=system("echo -e 'HOSTNAME=$host' >> /etc/sysconfig/network");
print $hos_ch;
$nameded=system("echo -e 'zone \"$domain\" IN {
        type master;
        file \"/var/named/$domain\";
     }\;' >> /etc/named.conf");
print $nameded;
$sasl=system("service saslauthd start");
print $sasl;
#$re=system("sed -i  '1i nameserver 127.0.0.1' /etc/resolv.conf");
#print $re;
$cro=system("echo -e '\@daily rm -f /var/log/maillog-* /var/log/spooler-* /var/log/btmp-* /var/log/cron-* /var/log/messages-* /var/log/secure-* /var/log/procmail.log-*' >> /var/spool/cron/root");
print $cro;
$cron=system("echo -e '\@daily rm -f /var/log/maillog.* /var/log/spooler.* /var/log/btmp.* /var/log/cron.* /var/log/messages.* /var/log/secure.* /var/log/procmail.log.*' >> /var/spool/cron/root");
print $cron;
$secr=system("service crond restart");
print $secr;
&dkim;
}


sub upgrade{
print "You need to upgrade postfix!!! For upgrading press Y else N";
chomp($yes=<STDIN>);
$y= "y";
$Y= "Y";
if ("$yes" eq "$y" || "$Y")
{
#! /bin/sh
$path="/usr/local/src";
chdir($path);
$gc=system("yum install gcc make -y");
print $gc;
$epel=system("wget http://www.artfiles.org/postfix.org/postfix-release/official/postfix-2.6.6.tar.gz");
print $epel;
$ext=system("tar zxvf postfix-2.6.6.tar.gz");
print $ext;
$rpm_buil=system("yum install db4-devel -y");
print $rpm_buil;

$pat="/usr/local/src/postfix-2.6.6";
chdir($pat);
$to=system("touch /usr/local/src/postfix-2.6.6/make_postfix.sh");
print $to;

$ec=system("echo -e '#/bin/sh' > /usr/local/src/postfix-2.6.6/make_postfix.sh");
print $ec;

$cho=system("echo -e 'make makefiles CCARGS='-fPIC -DUSE_TLS -DUSE_SSL -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DPREFIX=\\/usr/ -DHAS_LDAP -DLDAP_DEPRECATED=1 -DHAS_PCRE -I/usr/include/openssl -I/usr/include/sasl  -I/usr/include' AUXLIBS='-L/usr/lib64 -L/usr/lib64/openssl -lssl -lcrypto -L/usr/lib64/sasl2 -lsasl2 -lpcre -lz -lm -lldap -llber -Wl,-rpath,/usr/lib64/openssl -pie -Wl,-z,relro' OPT='-O' DEBUG='-g'' >> /usr/local/src/postfix-2.6.6/make_postfix.sh");
print $cho;
$ch=system("chmod 755 make_postfix.sh");
print $ch;

$cm=system("./make_postfix.sh");
print $cm;
$yu=system("yum install cyrus-sasl cyrus-sasl-devel openssl openssl-devel pcre pcre-devel openldap openldap-devel -y");

print $yu;
$mk=system("make");
print $mk;
$mke=system("make upgrade");
print $mke;

$rm1=system("rm /etc/postfix/postfix-files");
print $rm1;
$rm2=system("rm /etc/postfix/post-install");
print $rm2;
$rm3=system("rm /etc/postfix/postfix-script");
print $rm3;
$rm4=system("rm /usr/share/doc/postfix-2.3.3/README_FILES/QMQP_README");
print $rm4;
$pst=system("postfix upgrade-configuration");
print $pst;
$ser=system("service postfix restart");
print $ser;
print q(Enter number for which you want to make instance);
chomp($input_num = <STDIN> );

print "Enter real hostname";
chomp($host=<STDIN>);

print "Enetr main ip";
chomp($ip=<STDIN>);

print q(Enter Domain Name);
chomp($domain = <STDIN> );

print "Enter root password";
chomp($root_pass=<STDIN>);
print "Enter selector name";
chomp($selector = <STDIN> );
$edns=system("echo -e '\$TTL 2h\;
\@ IN SOA $host hostmaster.domain.com (
           1            ; Serial
           10800        ; Refresh after 3 hours
           3600         ; Retry after 1 hour
           604800       ; Expire after 1 week
           3600 )       ; Minimum TTL of 1 hour
\@                         IN    NS $host.
$host. IN A  $ip' > /var/named/$domain");
print $edns;
$number = 1;
$po=system(" postmulti -e init ");
print $po;
$rmresolve=system("rm -f /etc/resolv.conf");
print $rmresolve;
$resolveentry=system("echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' > /etc/resolv.conf");
print $resolveentry;
$rmhosts=system("rm -f /etc/hosts");
print $rmhosts;
$hostsentry=system("echo -e '127.0.0.1       localhost
$ip     $host' > /etc/hosts");
print $hostsentry;

 while ($number <= $input_num)
  {
     print qq(Please enter $number Hostname);
     chomp($number_host = <STDIN>);
     print qq(Please enter $number IP);
     chomp($number_IP = <STDIN> );
     $out=system("postmulti -I postfix-out$number -G mta -e create");
     print $out;
     $host_ed1=system("echo -e '$number_IP                $number_host' >> /etc/hosts");
     print $host_ed1;
     $hdc=system("sed -i 's/#header_checks/#header_checks/' /etc/postfix-out$number/main.cf");
     print $hdc;
     $out_myhost=system("sed -i 's/#myhostname = host.domain.tld/myhostname = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_myhost;
     $out_inet=system("sed -i 's/inet_interfaces = localhost/inet_interfaces = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_inet;
$out_inet1=system("sed -i 's/inet_interfaces = all/inet_interfaces = $number_host/' /etc/postfix-out$number/main.cf");
     print $out_inet1;
     $out_mynetwork=system("sed -i 's/#mynetworks_style = host/mynetworks_style = host/' /etc/postfix-out$number/main.cf");
     print $out_mynetwork;
     $out_auth=system("sed -i 's/authorized_submit_users = /authorized_submit_users = root/' /etc/postfix-out$number/main.cf");
     print $out_auth;
     $send=system("echo -e 'sender_based_routing = yes' >> /etc/postfix-out$number/main.cf");
     print $send;
     $bind=system("echo -e 'smtp_bind_address = $number_IP' >> /etc/postfix-out$number/main.cf");
     print $bind;
     $alt=system("echo -e 'alternative_config_directories = /etc/postfix' >> /etc/postfix-out$number/main.cf");
     print $alt;
     $lastfiv=system("echo -e 'multi_instance_enable = yes
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
smtpd_sasl_security_options = noanonymous
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination' >> /etc/postfix-out$number/main.cf");
print $lastfiv;
$remove1=system("sed -i 's/master_service_disable = inet/#master_service_disable = inet/' /etc/postfix-out$number/main.cf ");
print $remove1;
$sasl_enter=system("echo -e '$number_host   root:$root_pass' >> /etc/postfix/sasl_passwd");
print $sasl_enter;

$e=system("echo -e '$number_host. IN A  $number_IP' >> /var/named/$domain");
print $e;
$ed=system("echo -e '\@ IN  MX        0 $number_host.' >> /var/named/$domain");
print $ed;
 $number++;
}

$post_myhost=system("sed -i 's/#myhostname = host.domain.tld/myhostname = $host/' /etc/postfix/main.cf");
print $post_myhost;
$hdcm=system("sed -i 's/#header_checks/#header_checks/' /etc/postfix/main.cf");
print $hdcm;
$body_c=system("echo -e 'body_checks = regexp:/etc/postfix/body_checks' >> /etc/postfix/main.cf");
print $body_c;
$post_inet=system("sed -i 's/inet_interfaces = all/inet_interfaces = $host/' /etc/postfix/main.cf");
print $post_inet;
 $r=system("sed -i 's/#relayhost = \$mydomain/relayhost = $domain/' /etc/postfix/main.cf");
print $r;
$post_lastfo=system("echo -e 'alternative_config_directories = /etc/postfix-out
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
maximal_queue_lifetime = 0
initial_destination_concurrency = 10
default_destination_concurrency_limit = 50' >> /etc/postfix/main.cf");
print $post_lastfo;

$own=chown (0,0, "/etc/postfix/sasl_passwd");
print $own;
$mod=chmod (0600, "/etc/postfix/sasl_passwd");
print $mod;
$pstmp=system("postmap /etc/postfix/sasl_passwd");
print $pstmp;

$header=system("echo -e '# Sample For Dropping Headers:
#/^Header: IfContains/          IGNORE
/^Received: from /              IGNORE
/^User-Agent:/                  IGNORE
/^X-Mailer:/                    IGNORE
/^X-Originating-IP:/            IGNORE' >> /etc/postfix/header_checks");
print $header;

$body_che=system("echo -e '
/sarv/ REJECT BODY CHECKS (100 use word sarv in body)
/sarvmail/ REJECT BODY CHECKS (100 use word sarvmail in body)' >> /etc/postfix/body_checks");

$hos=system("sed -i '/HOSTNAME/d' /etc/sysconfig/network");
print $hos;
$hos_ch=system("echo -e 'HOSTNAME=$host' >> /etc/sysconfig/network");
print $hos_ch;
$nameded=system("echo -e 'zone \"$domain\" IN {
        type master;
        file \"/var/named/$domain\";
     }\;' >> /etc/named.conf");
print $nameded;
#$re=system("sed -i  '1i nameserver 127.0.0.1' /etc/resolv.conf");
#print $re;
$cro=system("echo -e '\@daily rm -f /var/log/maillog-* /var/log/spooler-* /var/log/btmp-* /var/log/cron-* /var/log/messages-* /var/log/secure-* /var/log/procmail.log-*' >> /var/spool/cron/root");
print $cro;
$cron=system("echo -e '\@daily rm -f /var/log/maillog.* /var/log/spooler.* /var/log/btmp.* /var/log/cron.* /var/log/messages.* /var/log/secure.* /var/log/procmail.log.*' >> /var/spool/cron/root");
print $cron;
$secr=system("service crond restart");
print $secr;
&dkim;
}
else
{
print "Thanks for using"
}
}
sub dkim{
$gcc=system("yum install gcc -y");
print $gcc;
$mk=system("yum install make  wget -y");
print $mk;
$p = "/usr/local/src";
chdir($p);
$dow=system("wget http://sourceforge.net/projects/opendkim/files/Previous%20Releases/opendkim-2.4.2.tar.gz");
print $dow;
$sen=system("yum install sendmail-devel openssl-devel -y");
print $sen;
$ext=system("tar zxvf opendkim-2.4.2.tar.gz");
print $ext;
$pa="/usr/local/src/opendkim-2.4.2/";
chdir($pa);
$co=system("./configure --sysconfdir=/etc --prefix=/usr/local --localstatedir=/var");
print $co;
$mk=system("make");
print $mk;
$mkin=system("make install");
print $mkin;
$adu=system("adduser opendkim");
print $adu;
$m = mkdir("/var/run/opendkim", 0700);
print $m;
$gadd=system("groupadd opendkim");
print $gadd;
$am=system("useradd -G mail opendkim");
print $am;
$um=system("usermod -c \"OpenDKIM\" opendkim");
print $um;
$chon=system("chown opendkim:opendkim /var/run/opendkim");
print $chon;
$mdi=system("mkdir -p /etc/opendkim/keys");
print $mdi;
$chop=system("chown -R opendkim:opendkim /etc/opendkim");
print $chop;
$chkey=system("chmod -R go-wrx /etc/opendkim/keys");
print $chkey;
$cp=system("cp /usr/local/src/opendkim-2.4.2/contrib/init/redhat/opendkim /etc/init.d/");
print $cp;
$chopen=chmod (0755, "/etc/init.d/opendkim");
print $chopen;
$mkd=system("mkdir /etc/opendkim/keys/$domain");
print $mkd;
$keygen=system("/usr/local/bin/opendkim-genkey -D /etc/opendkim/keys/$domain/ -d /$domain -s $selector");
print $keygen;
$condom=system("chown -R opendkim:opendkim /etc/opendkim/keys/$domain");
print $condom;
$mop=system("mv /etc/opendkim/keys/$domain/$selector.private /etc/opendkim/keys/$domain/$selector");
print $mop;
$c=system("echo -e 'AutoRestart    Yes
AutoRestartRate         10/1h
Canonicalization       relaxed/simple
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
LogWhy                  Yes
Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256
SigningTable            refile:/etc/opendkim/SigningTable
Socket                  inet:8891\@localhost
Syslog                  Yes
SyslogSuccess           Yes
TemporaryDirectory      /var/tmp
UMask                   022
UserID                  opendkim:opendkim ' > /etc/opendkim.conf");
print $c;
$k=system("echo -e '$selector._domainkey.$domain $domain:$selector:/etc/opendkim/keys/$domain/$selector' > /etc/opendkim/KeyTable");
print $k;
$s=system("echo -e '* $selector._domainkey.$domain' > /etc/opendkim/SigningTable");
print $s;
$t=system("echo -e '127.0.0.1
localhost
$host
$domain ' >  /etc/opendkim/TrustedHosts");
print $t;
$postfi=system("echo -e 'smtpd_milters   = inet:127.0.0.1:8891
non_smtpd_milters       = \$smtpd_milters
milter_default_action   = accept
milter_protocol   = 2 ' >> /etc/postfix/main.cf");
print $postfi;
$ser=system("service opendkim start");
print $ser;
$por=system("postfix reload");
print $por;
$chk=system("chkconfig --level 2345 opendkim on");
print $chk;
$rkey=system("sed -i 's/r=postmaster\;/ /' /etc/opendkim/keys/$domain/$selector.txt ");
print $rkey;
$keyv = system("cat /etc/opendkim/keys/$domain/$selector.txt");
print $keyv;
$seropen=system("service opendkim restart");
print $seropen;
$sernamed=system("service named restart");
print $sernamed;
$serpo=system("service postfix restart");
print $serpo;
}
