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

    my $query = "SELECT owner, title, text FROM Articles WHERE owner = ? AND title = ?;";

    my $sth = $dbh->prepare($query);
    $sth->execute($user,$title);
    
    my $row = $sth->fetchrow_hashref();

    my $ownerR = $row->{"owner"};
    my $titleR = $row->{"title"};
    my $textR = $row->{"text"};

    $sth->finish;
    $dbh->disconnect;

    print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar pagina</title>
</head>
<body>
    <header>
        <h1>Edita tu pagina</h1>
    </header>
    <article>
        <form action="update.pl">
            <label for="1">Titulo: </label>
            <input type="text" name="title" id="1" value="$titleR" readonly><br><br>
            <label for="2">Texto: </label>
            <textarea name="text" id="2" cols="30" rows="10">$textR</textarea><br>
            <label for="3">Usuario: </label>
            <input type="text" name="user" id="3" value="$ownerR" readonly><br><br>
            <input type="submit" value="Editar">
        </form>
    </article>
</body>
</html>
BLOCK
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