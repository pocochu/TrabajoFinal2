#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $user = $q->param("user");
my $password = $q->param("password");
my $firstName = $q->param("firstName");
my $lastName = $q->param("lastName");

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if(comprobar($user)==0){
    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $query = "INSERT INTO Users(userName,password,firstName,lastName) VALUES(?,?,?,?);";

    my $sth = $dbh->prepare($query);
    $sth->execute($user,$password,$firstName,$lastName);
    $sth->finish;
    $dbh->disconnect;

    print<<BLOCK;
    <user>
        <owner>$user</owner>
        <firstName>$firstName</firstName>
        <lastName>$lastName</lastName>
    </user>
BLOCK
} else {
    print<<BLOCK;
    <user>
    </user>
BLOCK
}

sub comprobar {
    my $userC = $_[0];
    my $queryC = "SELECT * FROM Users WHERE userName = ?;";

    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $sthC = $dbh->prepare($queryC);
    $sthC->execute($userC);
    my @row = $sthC->fetchrow_array;

    $sthC->finish;
    $dbh->disconnect;
    return @row;
}
