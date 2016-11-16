use v6;
use Crust::Middleware::Session;
use JSON::Fast;

class Crust::Middleware::Session::Store::DBIish does Crust::Middleware::Session::StoreRole
{
    has $.dbh   is required;
    has $.table = 'sessions';

    method get($cookie-name) {
	my $sth = $.dbh.prepare("SELECT session_data FROM $.table WHERE id = ?");
	$sth.execute($cookie-name);
	my @row = $sth.row;
	return @row.elems ?? from-json(@row[0]) !! ();
    }

    method set($cookie-name, $session) {
	my $sth = $.dbh.prepare("SELECT 1 FROM $.table WHERE id = ?");
	$sth.execute($cookie-name);
	
	if ($sth.row.elems) {
	    $sth = $.dbh.prepare("UPDATE $.table SET session_data = ? WHERE id = ?");
	    $sth.execute(to-json($session), $cookie-name);
	} else {
	    $sth = $.dbh.prepare("INSERT INTO $.table (id, session_data) VALUES (?, ?)");
	    $sth.execute($cookie-name, to-json($session));
	}
    }

    method remove($cookie-name) {
	my $sth = $.dbh.prepare("DELETE from $.table WHERE id = ?");
	$sth.execute($cookie-name);
    }
}

=begin pod

=TITLE class Crust::Middleware::Session::Store::DBIish

=SUBTITLE Implements database storage role for Crust::Middleware::Session

=head1 SYNOPSIS

    =begin code :skip-test
    use Crust::Builder;
    use Crust::Middlewear::Session;
    use Crust::Middlewear::Session::Store::DBIish;

    sub app($env) {
	$env<p6sgix.session>.get('username').say if $env<p6sgix.session>.defined;
	$env<p6sgix.session>.set('username', 'ima-username');

	# ...crust-y stuff...
    }

    my $store   = Crust::Middleware::Session::Store::DBIish.new(:dbh($dbh));
    my $builder = Crust::Builder.new;
    
    $builder.add-middlewear('Session', store => $store);
    $builder.wrap(&app);
    =end code

=head1 DESCRIPTION
    
Crust::Middlewear::Session::Store::DBIish implements a backend storage
role for Crust::Middlewear::Session in any database supported by
DBIish.

You must pass in a database handle to new().

Session data is stored serialized in the database table as JSON and is
de-serialized from JSON on get, and made available via the normal
Crust::Middlewear::Session methods.

The very fast and compact JSON::Fast is used to serialize and
de-serialize the session data to the database table.

=head1 ATTRIBUTES

=head2 dbh

An active DBIish database handle to the database where session data
will be stored.

=head2 table

Table name that will store session data (defaults to "sessions").

=head1 AUTHOR

Mark Rushing <mark@orbislumen.net>

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod
