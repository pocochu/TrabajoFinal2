#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $user = $q->param("user");
my $password = $q->param("password");

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if(comprobar($user,$password)==0){
    print<<BLOCK;
    <user>
    </user>
BLOCK
} else {
    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $query = "SELECT userName, lastName, firstName FROM Users WHERE userName = ? AND password = ?;";

    my $sth = $dbh->prepare($query);
    $sth->execute($user,$password);

    my $row = $sth->fetchrow_hashref();

    $sth->finish;
    $dbh->disconnect;

    print<<BLOCK;
    <user>
        <owner>$row->{"userName"}</owner>
        <firstName>$row->{"firstName"}</firstName>
        <lastName>$row->{"lastName"}</lastName>
    </user>
BLOCK
}

sub comprobar {
    my $userC = $_[0];
    my $passwordC = $_[1];
    my $queryC = "SELECT * FROM Users WHERE userName = ? AND password = ?;";

    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $sthC = $dbh->prepare($queryC);
    $sthC->execute($userC,$passwordC);
    my @row = $sthC->fetchrow_array;

    $sthC->finish;
    $dbh->disconnect;
    return @row;
}
