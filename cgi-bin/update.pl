#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $title = $q->param("title");
my $text = $q->param("text");
my $user = $q->param("user");

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $userDB = 'alumno';
my $passwordDB = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";

my $dbh1 = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");
my $query1 = "DELETE FROM Articles WHERE owner = ? AND title = ?;";
my $sth1 = $dbh1->prepare($query1);
$sth1->execute($user,$title);
$sth1->finish;
$dbh1->disconnect;

my $dbh2 = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");
my $query2 = "INSERT INTO Articles(owner,title,text) VALUES(?,?,?);";
my $sth2 = $dbh2->prepare($query2);
$sth2->execute($user,$title,$text);
$sth2->finish;
$dbh2->disconnect;

print<<BLOCK;
<article>
    <title>$title</title>
    <text>$text</text>
</article>
BLOCK