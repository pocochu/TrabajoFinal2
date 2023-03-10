#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $user = $q->param("user");
my $title = $q->param("title");

if(comprobar($user,$title)==0){
    print $q->header('text/XML');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print<<BLOCK;
    <article>
    </article>
BLOCK
} else {
    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $query = "SELECT text FROM Articles WHERE owner = ? AND title = ?;";

    my $sth = $dbh->prepare($query);
    $sth->execute($user,$title);
    
    my $row = $sth->fetchrow_hashref();

    print $q->header('text/html');
    my $textRaw = $row->{"text"};

    $sth->finish;
    $dbh->disconnect;

    my $textHtml = convertor($textRaw);

    print $textHtml;
}

sub comprobar {
    my $userC = $_[0];
    my $titleC = $_[1];
    my $queryC = "SELECT owner, title FROM Articles WHERE owner = ? AND title = ?;";

    my $userDB = 'alumno';
    my $passwordDB = 'pweb1';
    my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
    my $dbh = DBI->connect($dsn, $userDB, $passwordDB) or die("No se pudo conectar!");

    my $sthC = $dbh->prepare($queryC);
    $sthC->execute($userC,$titleC);
    my @row = $sthC->fetchrow_array;

    $sthC->finish;
    $dbh->disconnect;
    return @row;
}

sub convertor {

    my $markdown = $_[0];

    $markdown =~ s/^#\s+(.*)$/<h1>$1<\/h1>/gm;

    $markdown =~ s/^##\s+(.*)$/<h2>$1<\/h2>/gm;
    
    $markdown =~ s/^###\s+(.*)$/<h3>$1<\/h3>/gm;

    $markdown =~ s/^####\s+(.*)$/<h4>$1<\/h4>/gm;

    $markdown =~ s/^#####\s+(.*)$/<h5>$1<\/h5>/gm;

    $markdown =~ s/^######\s+(.*)$/<h6>$1<\/h6>/gm;

    $markdown =~ s/\*\*(.+?)\*\*/<p><strong>$1<\/strong><\/p>/g;

    $markdown =~ s/\*(.+?)\*/<p><em>$1<\/em><\/p>/g;

    $markdown =~ s/\*\*\*(.+?)\*\*\*/<p><strong><em>$1<\/em><\/strong><\/p>/g;

    $markdown =~ s/~~(.+?)~~/<p><del>$1<\/del><\/p>/g;

    $markdown =~ s/```(.+?)```/<pre style="background-color: rgb(230, 230, 230)"><code>$1<\/code><\/pre>/gs;

    $markdown =~ s/\[(.+?)\]\((.+?)\)/<p><a href="$2">$1<\/a>.<\/p>/g;
    return $markdown;
}
