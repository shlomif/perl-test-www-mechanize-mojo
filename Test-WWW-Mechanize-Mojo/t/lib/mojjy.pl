#!/usr/bin/env perl

use Mojolicious::Lite;

sub html {
    my ( $title, $body ) = @_;
    return qq{
<html>
<head><title>$title</title></head>
<body>
$body
<a href="/hello/">Hello</a>.
</body></html>
};
}

get '/check_auth_basic/' => sub {
    my $self = shift;

    my $auth = $self->req->headers->authorization;
    ($auth) = $auth =~ /Basic\s(.*)/i;
    $auth = decode_base64($auth);

    if ( $auth eq "user:pass" )
    {
        my $html = html( "Auth", "This is the auth page" );
        $self->render_text($html);
        return;
    }
    else
    {
        my $html = html( "Auth", "Auth Failed!" );
        $self->render_text($html, status => "401",);
        return;
    }
};

get '/' => 'index';

get '/:groovy' => sub {
    my $self = shift;
    $self->render_text($self->param('groovy'), layout => 'funky');
};

shagadelic;

=head1 TODO

* Add a status (Not logged-in / Logged in as something) ruler to the top.

=cut

__DATA__

@@ index.html.ep
% layout 'funky';

@@ layouts/funky.html.ep
<!doctype html><html>
    <head><title>Foo Bar</title></head>
    <body><%== content %></body>
</html>
