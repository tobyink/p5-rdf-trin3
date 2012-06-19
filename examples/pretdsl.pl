#!/usr/bin/perl

use 5.010;
use RDF::TriN3;
use RDF::TrineX::Parser::Pretdsl;

# Namespaces are just for Turtle output!
my $ns = {
	cpan    => 'http://purl.org/NET/cpan-uri/person/',
	dbug    => 'http://ontologi.es/doap-bugs#',
	dcs     => 'http://ontologi.es/doap-changeset#',
	dcterms => 'http://purl.org/dc/terms/',
	dist    => 'http://purl.org/NET/cpan-uri/dist/Example-Distribution/',
	doap    => 'http://usefulinc.com/ns/doap#',
	foaf    => 'http://xmlns.com/foaf/0.1/',
	rdfs    => 'http://www.w3.org/2000/01/rdf-schema#',
	rev     => 'http://purl.org/stuff/rev#',
	xsd     => 'http://www.w3.org/2001/XMLSchema#',
};

my $pretdsl = <<'DATA';

`Example-Distribution`
doap:developer cpan:TOBYINK ;
doap:maintainer cpan:TOBYINK .

`Example-Distribution 0.001 cpan:TOBYINK`
issued 2012-06-18 .

`Example-Distribution 0.002 cpan:TOBYINK`
issued 2012-06-19 ;
changeset [
	item "More monkey madness!"^^Addition ;
	item "Less lion laziness!"^^Removal ;
	item [ a dcs:Bugfix ; dcs:fixes RT#12345 ; label "Too much focus on lazy cats, but not enough focus on excited primates." ] ;
] .

DATA

my $model = RDF::Trine::Model->new;

RDF::TrineX::Parser::Pretdsl
	-> new
	-> parse_into_model('http://example.org/', $pretdsl, $model);

print RDF::Trine::Serializer
	-> new('Turtle', namespaces => $ns)
	-> serialize_model_to_string($model);
