package RDF::TrineX::Parser::Pretdsl;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.140';

our $PROFILE = <<'PRETDSL_PROFILE';

# RDFa 1.1 prefixes
@prefix grddl:    <http://www.w3.org/2003/g/data-view#> .
@prefix ma:       <http://www.w3.org/ns/ma-ont#> .
@prefix owl:      <http://www.w3.org/2002/07/owl#> .
@prefix rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfa:     <http://www.w3.org/ns/rdfa#> .
@prefix rdfs:     <http://www.w3.org/2000/01/rdf-schema#> .
@prefix rif:      <http://www.w3.org/2007/rif#> .
@prefix skos:     <http://www.w3.org/2004/02/skos/core#> .
@prefix skosxl:   <http://www.w3.org/2008/05/skos-xl#> .
@prefix wdr:      <http://www.w3.org/2007/05/powder#> .
@prefix void:     <http://rdfs.org/ns/void#> .
@prefix wdrs:     <http://www.w3.org/2007/05/powder-s#> .
@prefix xhv:      <http://www.w3.org/1999/xhtml/vocab#> .
@prefix xml:      <http://www.w3.org/XML/1998/namespace> .
@prefix xsd:      <http://www.w3.org/2001/XMLSchema#> .
@prefix cc:       <http://creativecommons.org/ns#> .
@prefix ctag:     <http://commontag.org/ns#> .
@prefix dc:       <http://purl.org/dc/terms/> .
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix foaf:     <http://xmlns.com/foaf/0.1/> .
@prefix gr:       <http://purl.org/goodrelations/v1#> .
@prefix ical:     <http://www.w3.org/2002/12/cal/icaltzd#> .
@prefix og:       <http://ogp.me/ns#> .
@prefix rev:      <http://purl.org/stuff/rev#> .
@prefix sioc:     <http://rdfs.org/sioc/ns#> .
@prefix v:        <http://rdf.data-vocabulary.org/#> .
@prefix vcard:    <http://www.w3.org/2006/vcard/ns#> .
@prefix schema:   <http://schema.org/> .

# Additional useful vocabularies
@prefix cpant:       <http://purl.org/NET/cpan-uri/terms#>.
@prefix dbug:        <http://ontologi.es/doap-bugs#> .
@prefix dcs:         <http://ontologi.es/doap-changeset#> .
@prefix doap:        <http://usefulinc.com/ns/doap#> .
@prefix earl:        <http://www.w3.org/ns/earl#> .
@prefix pretdsl:     <http://ontologi.es/pretdsl#> .
@prefix pretdsl-dt:  <http://ontologi.es/pretdsl#dt/> .
@prefix rt-ticket:   <http://purl.org/NET/cpan-uri/rt/ticket/> .
@prefix rt-status:   <http://purl.org/NET/cpan-uri/rt/status/> .
@prefix rt-priority: <http://purl.org/NET/cpan-uri/rt/priority/> .

# Useful XSD datatypes
@dtpattern
	"[0-9]{4}-[0-9]{2}-[0-9]{2}"
	<http://www.w3.org/2001/XMLSchema#date> .
@dtpattern
	"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{4}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})?"
	<http://www.w3.org/2001/XMLSchema#dateTime> .

# Other datatype shorthands
@pattern
	"`(?<x>.+?)`"
	"$x"^^pretdsl-dt:ProjectOrVersion .
@pattern
	"p`(?<x>.+?)`"
	"$x"^^pretdsl-dt:Project .
@pattern
	"v`(?<x>.+?)`"
	"$x"^^pretdsl-dt:Version .
@pattern
	"m`(?<x>.+?)`"
	"$x"^^pretdsl-dt:Module .
@pattern
	"f`(?<x>.+?)`"
	"$x"^^pretdsl-dt:File .
@pattern
	"cpan:(?<x>\\w+)"
	"$x"^^pretdsl-dt:CpanId .

# Generally useful predicates
@term label    rdfs:label .
@term comment  rdfs:comment .
@term seealso  rdfs:seeAlso .

# Makefile predicates
@term abstract_from          cpant:abstract_from .
@term author_from            cpant:author_from .
@term license_from           cpant:license_from .
@term requires_from          cpant:requires_from .
@term perl_version_from      cpant:perl_version_from .
@term version_from           cpant:version_from .
@term readme_from            cpant:readme_from .
@term no_index               cpant:no_index .
@term install_script         cpant:install_script .
@term requires               cpant:requires .
@term requires_external_bin  cpant:requires_external_bin .
@term recommends             cpant:recommends .
@term test_requires          cpant:test_requires .
@term configure_requires     cpant:configure_requires .
@term build_requires         cpant:build_requires .

# Changelog predicates
@term issued     dc:issued .
@term changeset  dcs:changeset .
@term item       dcs:item .
@term versus     dcs:versus .

# Changelog datatypes
@term Addition            pretdsl-dt:Addition .
@term Bugfix              pretdsl-dt:Bugfix .
@term Change              pretdsl-dt:Change .
@term Documentation       pretdsl-dt:Documentation .
@term Packaging           pretdsl-dt:Packaging .
@term Regresion           pretdsl-dt:Regression .
@term Removal             pretdsl-dt:Removal .
@term SecurityFix         pretdsl-dt:SecurityFix .
@term SecurityRegression  pretdsl-dt:SecurityRegression .
@term Update              pretdsl-dt:Update .

PRETDSL_PROFILE

our $CALLBACKS = {};

use RDF::Trine qw< statement iri blank literal >;
use RDF::NS::Trine;

my $curie = RDF::NS::Trine->new('20120521');

sub _CB_ (&$)
{
	my ($coderef, $uri) = @_;
	$uri = "http://ontologi.es/pretdsl#dt/$uri" unless $uri =~ /\W/;
	$CALLBACKS->{$uri} = $coderef;
}

_CB_
{
	my ($lit, $cb) = @_;
	my ($dist, $version, $author) = split /\s+/, $lit->literal_value;
	goto $CALLBACKS->{'http://ontologi.es/pretdsl#dt/Version'}
		if length $version;
	goto $CALLBACKS->{'http://ontologi.es/pretdsl#dt/Project'};
} 'ProjectOrVersion';

_CB_
{
	my ($lit, $cb) = @_;
	my $dist = $lit->literal_value;
	
	my $node = iri(sprintf(
		'http://purl.org/NET/cpan-uri/dist/%s/project',
		$dist,
	));
	
	my $metacpan = iri(sprintf(
		'https://metacpan.org/release/%s',
		$dist,
	));
	
	$cb->(statement($node, $curie->rdf_type, $curie->doap_Project));
	$cb->(statement($node, $curie->doap_name, literal($dist)));
	$cb->(statement($node, $curie->URI('doap:programming-language'), literal('Perl')));
	$cb->(statement($node, $curie->doap_homepage, $metacpan));
	$cb->(statement($node, $curie->URI('doap:download-page'), $metacpan));
	
	return $node;
} 'Project';

_CB_
{
	my ($lit, $cb) = @_;
	my ($dist, $version, $author) = split /\s+/, $lit->literal_value;
	(my $version_token = $version) =~ s/\./-/g;

	my $dist_node = iri(sprintf(
		'http://purl.org/NET/cpan-uri/dist/%s/project',
		$dist,
	));
	
	my $node = iri(sprintf(
		'http://purl.org/NET/cpan-uri/dist/%s/v_%s',
		$dist,
		$version_token,
	));
	
	$cb->(statement($dist_node, $curie->doap_release, $node));
	$cb->(statement($node, $curie->rdf_type, $curie->doap_Version));
	$cb->(statement($node, $curie->doap_revision, literal($version, undef, $curie->xsd_string->uri)));
	
	if ($author =~ /^cpan:(\w+)$/)
	{
		$author = $1;
		my $author_node = iri(sprintf(
			'http://purl.org/NET/cpan-uri/person/%s',
			lc $author,
		));
		$cb->(statement($node, $curie->dcterms_publisher, $author_node));
		my $download = iri(sprintf(
			'http://backpan.cpan.org/authors/id/%s/%s/%s/%s-%s.tar.gz',
			substr(uc $author, 0, 1),
			substr(uc $author, 0, 1),
			uc($author),
			$dist,
			$version,
		));
		$cb->(statement($node, $curie->URI('doap:file-release'), $download));
	}
	
	return $node;
} 'Version';

_CB_
{
	my ($lit, $cb) = @_;
	my $node = blank();
	$cb->(statement($node, $curie->rdf_type, $curie->nfo_FileDataObject));
	$cb->(statement($node, $curie->nfo_fileName, literal($lit->literal_value)));
	return $node;
} 'File';

_CB_
{
	my ($lit, $cb) = @_;
	my $node = iri(sprintf('http://purl.org/NET/cpan-uri/person/%s', lc $lit->literal_value));
	$cb->(statement($node, $curie->rdf_type, $curie->foaf_Person));
	$cb->(statement($node, $curie->foaf_nick, literal($lit->literal_value)));
	$cb->(statement($node, $curie->foaf_page, iri(sprintf 'https://metacpan.org/author/%s', uc $lit->literal_value)));
	return $node;
} 'CpanId';

foreach my $change_type (qw(
	Addition Bugfix Change Documentation Packaging Regression
	Removal SecurityFix SecurityRegression Update
))
{
	_CB_
	{
		my ($lit, $cb) = @_;
		my $node = blank();
		$cb->(statement($node, $curie->rdf_type, iri("http://ontologi.es/doap-changeset#$change_type")));
		$cb->(statement($node, $curie->rdfs_label, literal($lit->literal_value)));
		return $node;		
	} $change_type;
}

use namespace::clean;
use base 'RDF::Trine::Parser::ShorthandRDF';

sub new
{
	my ($class, %args) = @_;
	$class->SUPER::new(
		datatype_callback => $CALLBACKS,
		profile           => $PROFILE,
		%args,
	);
}

__PACKAGE__
