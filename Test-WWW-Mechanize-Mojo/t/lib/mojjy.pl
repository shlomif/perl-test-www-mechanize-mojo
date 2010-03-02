#!/usr/bin/env perl

use Mojolicious::Lite;

use MIME::Base64;
use Encode qw//;
use Cwd;

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

    my $auth = $self->req->headers->header("Authorization");
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


get "/hi" => sub {
    my $self = shift;

    $self->redirect_to('/hello');

    return;
};

get "/greetings" => sub {
    my $self = shift;

    # This relative URL is something that Catalyst eats and appears
    # in Catty.pm , but Mojo won't accept.
    # -- Shlomi Fish
    # $self->redirect_to('hello');
    $self->redirect_to('/hello');

    return;
};

get "/bonjour" => sub {
    my $self = shift;

    $self->redirect_to('/hi');

    return;
};


get '/hello' => sub {
    my $self = shift;

    my $str = Encode::encode('utf-8', "\x{263A}"); # ☺
    my $html = html( "Hello", "Hi there! $str" );
    $self->res->headers->content_type("text/html; charset=utf-8");
    $self->render_text($html);

    return;
};

get '/redirect_with_500' => sub {
    my $self = shift;

    $self->redirect_to('/bonjour');

    die "erk!";
};

get '/:groovy' => sub {
    my $self = shift;
    $self->render_text($self->param('groovy'), layout => 'funky');
};

get '/' => sub {
    my $self = shift;

    $self->render_text(html("Root", "This is the root page"));

    return;
};

shagadelic;

=head1 TODO

* Add a status (Not logged-in / Logged in as something) ruler to the top.

=cut

__DATA__

@@ layouts/funky.html.ep
<!doctype html><html>
    <head><title>Foo Bar</title></head>
    <body><%== content %></body>
</html>
