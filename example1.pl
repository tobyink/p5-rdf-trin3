use lib "lib";
use RDF::TriN3;

my $model = RDF::Trine::Model->temporary_model;

my $n3 = <<'NOTATION3';
@keywords is, of, a.
@dtpattern "\d{1,2}[a-z]{3}\d{4}" <http://example.com/day> .
@base <http://example.com/day/> .
@pattern    "(\d{1,2})(?<month>[A-Z][a-z]{2})(\d{4})" <$3/$2/$1> .
@base <http://example.org/> .
@term lit <#as_literal> .

1Apr2003 lit 1apr2003 ; <foo> <bar> .

NOTATION3

my $parser = RDF::Trine::Parser::ShorthandRDF->new();

$parser->parse_into_model('http://example.org/', $n3, $model);

my $iter = $model->as_stream;
while (my $st = $iter->next) {
	print $st->sse . "\n";
};

print "########\n";
$model = RDF::Trine::Model->temporary_model;

my $n3 = <<'NOTATION3';
@base <http://example.com/people/> .
@pattern "\@(\S+)" <$1> .
@base <http://example.com/documents/> .
@pattern "\Doc(\d+)" <$1> .
@base <http://example.com/terms/> .

@tobyink <created> Doc1234 .
NOTATION3

my $parser = RDF::Trine::Parser::ShorthandRDF->new();

$parser->parse_into_model('http://example.org/', $n3, $model);

my $iter = $model->as_stream;
while (my $st = $iter->next) {
	print $st->sse . "\n";
};
