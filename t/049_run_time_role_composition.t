#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Scalar::Util qw(blessed);

BEGIN {
    use_ok('Moose');
}

=pod

This test can be used as a basis for the runtime role composition.
Apparently it is not as simple as just making an anon class. One of 
the problems is the way that anon classes are DESTROY-ed, which is
not very compatible with how instances are dealt with.

{
    package Bark;
    use Moose::Role;

    sub talk { 'woof' }

    package Sleeper;
    use Moose::Role;

    sub sleep { 'snore' }
    sub talk { 'zzz' }

    package My::Class;
    use Moose;

    sub sleep { 'nite-nite' }
}

my $obj = My::Class->new;
ok(!$obj->can( 'talk' ), "... the role is not composed yet");


{
    isa_ok($obj, 'My::Class');    
    
    ok(!$obj->does('Bark'), '... we do not do any roles yet');
    
    Bark->meta->apply($obj);

    ok($obj->does('Bark'), '... we now do the Bark role');
    ok(!My::Class->does('Bark'), '... the class does not do the Bark role');    

    isa_ok($obj, 'My::Class');
    isnt(blessed($obj), 'My::Class', '... but it is not longer blessed into My::Class');

    ok(!My::Class->can('talk'), "... the role is not composed at the class level");
    ok($obj->can('talk'), "... the role is now composed at the object level");
    
    is($obj->talk, 'woof', '... got the right return value for the newly composed method');
}

{
    is($obj->sleep, 'nite-nite', '... the original method responds as expected');

    ok(!$obj->does('Bark'), '... we do not do the Sleeper role');

    Sleeper->meta->apply($obj);

    ok($obj->does('Bark'), '... we still do the Bark role');
    ok($obj->does('Sleeper'), '... we now do the Sleeper role too');   
    
    ok(!My::Class->does('Sleeper'), '... the class does not do the Sleeper role');         
    
    isa_ok($obj, 'My::Class');

    is(My::Class->sleep, 'nite-nite', '... the original method still responds as expected');

    is($obj->sleep, 'snore', '... got the right return value for the newly composed method');
    is($obj->talk, 'zzz', '... got the right return value for the newly composed method');    
}

=cut