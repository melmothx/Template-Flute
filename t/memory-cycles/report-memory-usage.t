#!perl
use strict;
use warnings;
use utf8;
use Test::More;
use XML::Twig;
use Template::Flute;
use Memory::Usage;


my $mu = Memory::Usage->new;

$mu->record('start template');

for my $iter (1..10) {
    $mu->record("Twig iteration $iter");
    parse_twig();
}


for my $iter (1..30) {
    $mu->record("Template Iteration $iter");
    process_template();
}
$mu->record('end');

diag $mu->report();

plan skip_all => "Nothing to do";

sub parse_twig {
    my $html = q{<div class="test">TEST</div>};
    my $parser = XML::Twig->new;
    my $parsed = $parser->safe_parse_html($html);
}

sub process_template {
    my $spec = q{<specification>
<value name="test"/>
</specification>
};

    my $html = q{<div class="test">TEST</div>};

    my $flute = Template::Flute->new(template => $html,
                                     specification => $spec,
                                     values => {test => rand(100)},
                                    );
    my $output = $flute->process;
    return $flute;
}


