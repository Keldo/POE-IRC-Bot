requires 'POE';
requires 'POE::Component::IRC';
requires 'POE::Componet::IRC::Plugin';
requires 'Config::Simple';
requires 'DateTime';
requires 'HTTP::Request';
requires 'LWP::UserAgent';
requires 'LWP::Simple';
requires 'XML::RSS';
requires 'HTML::Strip';

# dependencies for platforms

on build => sub {
	requires 'Text::More', '0.98';
};