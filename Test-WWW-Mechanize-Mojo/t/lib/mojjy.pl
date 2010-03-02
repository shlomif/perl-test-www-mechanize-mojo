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

get "/die/" => sub {
    my $self = shift;

    my $html = html( "Die", "This is the die page" );
    $self->render_text($html);
    die "erk!";
};

sub _gzipped {
    my $self = shift;

    # If done properly this test should check the accept-encoding header, but we
    # control both ends, so just always gzip the response.
    require Compress::Zlib;

    my $html = html( "Hello", "Hi there! ☺" );
   
    $self->res->headers->content_type("text/html; charset=utf-8");
    $self->render_text( Compress::Zlib::memGzip($html) );
    $self->res->headers->content_transfer_encoding('gzip');
    $self->res->headers->add( 'Vary', 'Accept-Encoding' );

    return;
}

get "/gzipped/" => \&_gzipped;


get "/user_agent" => sub {
    my $self = shift;
    
    my $agent = $self->req->headers->user_agent();
    my $html = html($agent, $agent);
    
    $self->render_text($html);
    $self->res->headers->content_type("text/html; charset=utf-8");
    
    return;
};


get "/host" => sub {
    my $self = shift;

    my $host = $self->req->headers->header('Host') || "<undef>";
    my $html = html( "Foo", "Host: $host" );
    $self->render_text($html);

    return;
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
