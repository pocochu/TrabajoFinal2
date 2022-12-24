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

if(comprobar($title,$user)==0){
    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $query = "INSERT INTO Articles(owner,title,text) VALUES(?,?,?);";

    my $sth = $dbh->prepare($query);
    $sth->execute($user,$title,$text);

    $sth->finish;
    $dbh->disconnect;

    print<<BLOCK;
    <article>
        <title>$title</title>
        <text>$text</text>
    </article>
BLOCK
} else {
    print<<BLOCK;
    <article>
    </article>
BLOCK
}

sub comprobar {
    my $titleC = $_[0];
    my $userC = $_[1];
    my $queryC = "SELECT * FROM Articles WHERE title = ? AND owner = ?;";

    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $sthC = $dbh->prepare($queryC);
    $sthC->execute($titleC,$userC);
    my @row = $sthC->fetchrow_array;

    $sthC->finish;
    $dbh->disconnect;
    return @row;
}
