#!/usr/bin/env perl

use strict;
use warnings;
use XML::Twig;
use Test::More tests => 6;

diag "If the tests here fail, the XML::Twig used is not good for us";

my $parser = XML::Twig->new();

my $value =<< 'EOF';
<h1>Here&amp;there</h1>
<p>marco&company ;</p>
EOF

my $html = $parser->safe_parse_html($value);
if ($@) {
    diag $@;
}
ok($html, "Entities parsed without errors");
diag $html->sprint;
my $expected = <<'EOF';
<body>
<h1>Here&amp;there</h1>
<p>marco&amp;company ;</p>
</body>
EOF

$expected =~ s/\n//g;
like $html->sprint, qr{\Q$expected\E};

$value =<< 'EOF';
<h1 style="display:none">Here &amp; there</h1>
EOF

$html = $parser->safe_parse_html($value);
if ($@) {
    diag $@;
}
ok(!$@);
ok($html);

$html = $parser->safe_parse_html($value);
my @elts = $html->root()->get_xpath("//body");
is($elts[0]->first_child->{att}->{style}, "display:none",
   "style found with default converter");
diag $html->sprint;
like $html->sprint, qr{\Q<h1 style="display:none">Here &amp; there</h1>\E};
