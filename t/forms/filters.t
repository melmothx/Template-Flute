#!perl

use strict;
use warnings;
use Test::More tests => 1;
use Data::Dumper;
use DateTime;
use Template::Flute;

my $spec = <<'SPEC';
<specification>
  <form name="foo" link="name">
    <field name="date_time" filter="date"/>
  </form>
</specification>
SPEC

my $template = <<'HTML';
<form name="foo">
  <input name="date_time" type="text"/>
</form>
HTML

my $flute = new Template::Flute(specification => $spec,
                                template => $template,
                                filters => {
                                            date => {
                                                     options => {
                                                                 format => '%m/%d/%Y'
                                                                },
                                                    }
                                           },
                                );

my $form = $flute->template->form('foo');

my $dt_object = DateTime->new(year => 2015, month => 12, day => 31);
$form->fill({ date_time => $dt_object });


my $out = $flute->process;
like $out, qr{12/31/2015}, "date filtered correctly";


