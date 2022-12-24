#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $user = $q->param("user");

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if(comprobar($user)==0){
    print<<BLOCK;
    <articles>
    </articles>
BLOCK
} else {
    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $query = "SELECT owner, title FROM Articles WHERE owner = ?;";

    my $sth = $dbh->prepare($query);
    $sth->execute($user);

    print "<articles>";

    while (my $row = $sth->fetchrow_hashref()) {
        print<<BLOCK;
        <article>
            <owner>$row->{"owner"}</owner>
            <title>$row->{"title"}</title>
        </article>
BLOCK
    }

    print "</articles>";
    

    $sth->finish;
    $dbh->disconnect;
}

sub comprobar {
    my $userC = $_[0];
    my $queryC = "SELECT owner, title FROM Articles WHERE owner = ?;";

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
