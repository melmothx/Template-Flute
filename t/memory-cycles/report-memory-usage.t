#!perl
use strict;
use warnings;
use utf8;
use Test::More;
use XML::Twig;
use Template::Flute;
use Memory::Usage;
use Test::Memory::Cycle;
use Data::Dumper;
use Scalar::Util qw/weaken/;

my $mu = Memory::Usage->new;

$mu->record('start template');

for my $iter (1..10) {
    $mu->record("Twig iteration $iter");
    parse_twig();
}


for my $iter (1..10) {
    $mu->record("Template Iteration $iter");
    process_minimal();
}

for my $iter (1..10) {
    $mu->record("Template Iteration with lists $iter");
    process_template();
}

my $test = process_template();

$Data::Dumper::Maxdepth = 2;
# on destroy we do the same
weaken($test->{specification}->{xml});
weaken($test->{template}->{xml});
memory_cycle_ok($test);



$mu->record('end');

diag $mu->report();

done_testing;

sub parse_twig {
    my $html = q{<div class="test">TEST</div>};
    my $parser = XML::Twig->new;
    my $parsed = $parser->safe_parse_html($html);
}


sub process_minimal {
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

sub process_template {

    my $spec = q{<specification>
<list name="attributes" iterator="attributes">
<param name="value" field="title"/>
<list name="values" class="values" iterator="attribute_values">
<param name="value" class="attribute_value"/>
<param name="title" class="attribute_title"/>
</list>
</list>
</specification>
};

    my $html = q{<html>
<ul><li class="attributes"><span class="value">Name</span>
<ul><li class="values"><span class="attribute_title">Title</span></li>
</li></ul>
</html>
};

    my $attributes = [{name => 'color', title => 'Color',
                       attribute_values =>
                       [{value => 'red', title => 'Red'},
                        {
                         value => 'white', title => 'White'},
                        {
                         value => 'yellow', title => 'Yellow'},
                       ]},
                      {name => 'size', title => 'Size',
                       attribute_values =>
                       [{value => 'small', title => 'S'},
                        {
                         value => 'large', title => 'L'},
                       ]},
                     ];

    my $flute = Template::Flute->new(template => $html,
                                     specification => $spec,
                                     values => {attributes => $attributes},
                                    );

    my $out = $flute->process;
    return $flute;
}


