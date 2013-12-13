package MyTestApp;

use Dancer ':syntax';

get '/' => sub {
    set template => 'template_flute';
    set views => 't/views';

    template 'index';
};

get '/iter' => sub {
    set template => 'template_flute';
    set views => 't/views';
    template dropdown => {
                          my_wishlists_dropdown => iterator()
                         };
};

sub iterator {
    return [{ label => "a",
              value => "b" },
            { label => "c",
              value => "d" }]
}


1;

