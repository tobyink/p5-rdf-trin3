use lib "lib";
use RDF::TriN3;

my $model = RDF::Trine::Model->temporary_model;

my $n3 = <<'NOTATION3';
@keywords is, of, a.
@dtpattern "\d{1,2}[a-z]{3}\d{4}" <http://example.com/day> .
@pattern    "(\d{1,2})(?<month>[A-z]{3})(\d{4})" <http://example.com/day/$3/$2/$1> .
@term lit <http://example.org/#as_literal> .

1Apr2003 lit 1apr2003 .

NOTATION3

my $parser = RDF::Trine::Parser::ShorthandRDF->new();

$parser->parse_into_model('http://example.org/', $n3, $model);

my $iter = $model->as_stream;
while (my $st = $iter->next) {
	print $st->sse . "\n";
};
