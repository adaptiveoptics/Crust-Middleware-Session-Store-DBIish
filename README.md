# NAME

Crust::Middleware::Session::Store::DBIish - Implements database storage role for Crust::Middleware::Session

# SYNOPSIS

    ```
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
    ```

# DESCRIPTION
    
Crust::Middlewear::Session::Store::DBIish implements a backend storage
role for Crust::Middlewear::Session in any database supported by
DBIish.

You must pass in a database handle to `new()`.

Session data is stored serialized in the database table as JSON and is
de-serialized from JSON on get, and made available via the normal
Crust::Middlewear::Session methods.

The very fast and compact JSON::Fast is used to serialize and
de-serialize the session data to the database table.

# ATTRIBUTES

## dbh

An active DBIish database handle to the database where session data
will be stored.

## table

Table name that will store session data (defaults to "sessions").

# AUTHOR

Mark Rushing <mark@orbislumen.net>

# LICENSE

This is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.
