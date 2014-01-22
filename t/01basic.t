use Test::More tests => 9;
BEGIN { use_ok('RDF::TriN3') };

my $model = RDF::Trine::Model->temporary_model;
ok($model, "RDF::Trine autoloaded");

my $n3 = <<NOTATION3;
\@prefix foaf: <http://xmlns.com/foaf/0.1/> .

#comment

{
	?person a foaf:Person .
} =>
	{
		?person a foaf:Agent .
	} .

NOTATION3

my $parser = RDF::Trine::Parser::Notation3->new();
ok($parser, "Created parser");

$parser->parse_into_model('http://example.com/', $n3, $model);

is($model->count_statements, 1, "Got exactly one statement.");

my $iter = $model->get_statements;
my $f;
while (my $st = $iter->next)
{
	ok($st, "Retrieved the statement");
	
	is($st->subject->as_ntriples,
		'"?person <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://xmlns.com/foaf/0.1/Person> .\n"^^<http://open.vocab.org/terms/Formula>',
		'Statement looks good.');

	$f = $st->subject;
}

ok($f->pattern->[0]->isa('RDF::Trine::Statement'), 'Formulae can be introspected.');


my $parser = RDF::Trine::Parser::Notation3->new( 
    namespaces => { foaf => 'http://xmlns.com/foaf/0.1/' }
);
ok($parser && $parser->namespaces->{foaf}, "Created parser with namespaces");
my $formula = $parser->parse_formula(undef,'?a foaf:knows ?b');
my ($predicate) = map { $_->predicate } $formula->pattern->triples;
is( $predicate->uri, 'http://xmlns.com/foaf/0.1/knows' );

