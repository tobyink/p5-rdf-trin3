#!/usr/bin/perl

use 5.010;
use utf8;
use RDF::TriN3;

my $n3 = <<'NOTATION3';

#foo gist #bar .

##foo gist #baz .

@tai says "Phooey" .

NOTATION3

my $parser = RDF::Trine::Parser::ShorthandRDF->new(profile => <<'STUFF');
@import <http://buzzword.org.uk/2009/microturtle/profile.n3x> .
STUFF

$parser->parse('http://example.org/', $n3, sub {say $_[0]->sse});
