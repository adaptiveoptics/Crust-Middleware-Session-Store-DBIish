use v6;
use Test;
use lib 'lib';

plan 3;

use-ok 'Crust::Builder', 'load dependency Crust::Builder';
use-ok 'Crust::Middlewear::Session', 'load dependency Crust::Builder::Session';
use-ok 'Crust::Middlewear::Session::Store::DBIish', 'load module Crust::Middlewear::Session::Store::DBIish';

