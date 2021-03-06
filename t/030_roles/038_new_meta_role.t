#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;

do {
    package My::Meta::Role;
    use Moose;
    BEGIN { extends 'Moose::Meta::Role' };
};

do {
    package My::Role;
    use Moose::Role -metaclass => 'My::Meta::Role';
};

is(My::Role->meta->meta->name, 'My::Meta::Role');

