package Template::Plugin::Apache::SessionManager;

use Apache::SessionManager;
use Template::Plugin;
use vars qw( $VERSION );
use base qw( Template::Plugin );
use strict;

$VERSION = '0.01';

sub new {
	my ($class, $context, @params) = @_; 
	my $session = Apache::SessionManager::get_session(Apache->request);
	bless {
		_CONTEXT => $context,
		session  => $session,
	}, $class;
}

sub get {
	my $self = shift;
	my @args = ref($_[0]) eq 'ARRAY' ? @{$_[0]} : @_;
	if ( ! @args ) {
		@args = keys %{$self->{session}};
	}
	my @ary;
	foreach ( @args ) {
		push @ary, $self->{session}->{$_};
	}
	return @ary;
}

sub set {
	my ($self, @args) = @_;
	my $config = @args && ref $args[-1] eq 'HASH' ? pop(@args) : {};
	foreach ( keys %$config ) {
		# to avoid ovverride session special keys
		next if /^_session/;
		$self->{session}->{$_} = $config->{$_};
	}
	return '';
}

sub delete {
	my $self = shift;
	my @args = ref($_[0]) eq 'ARRAY' ? @{$_[0]} : @_;
	foreach ( @args ) {
		# to avoid ovverride session special keys
		next if /^_session/;
		delete $self->{session}->{$_};
	}
	return '';
}

sub destroy {
	my $self = shift;
	Apache::SessionManager::destroy_session(Apache->request);
}

1;
__END__

=pod 

=head1 NAME

Template::Plugin::Apache::SessionManager - Session manager Template Toolkit plugin 

=head1 SYNOPSIS

   [% USE my_sess = Apache.SessionManager %]

   # Getting single session value
   SID = [% my_sess.get('_session_id') %]

   # Getting multiple session values
   [% FOREACH s = my_sess.get('_session_id','_session_timestamp') %]
   * [% s %]
   [% END %]
   # same as
   [% keys = ['_session_id','_session_timestamp'];
      FOREACH s = my_sess.get(keys) %]
   * [% s %]
   [% END %]

   # Getting all session values
   [% FOREACH s = my_sess.get %]
   * [% s %]
   [% END %]

   # Setting session values:
   [% my_sess.set('foo' => 10, 'bar' => 20, ...) %]

   # Deleting session value(s)
   [% my_sess.delete('foo', 'bar') %]
   # same as
   [% keys = ['foo', 'bar'];
      my_sess.delete(keys) %]

   # Destroying session
   [% my_sess.destroy %]

=head1 DESCRIPTION

This Template Toolkit plugin provides an interface to Apache::SessionManager 
module wich provide a session manager for a web application. 
This modules allows you to integrate a transparent session management into your
template documents (it handles for you the cookie/URI session tracking management
of a web application)

An Apache.SessionManager plugin object can be created as follows:

   [% USE my_sess = Apache.SessionManager %]

or directly: 

   [% USE Apache.SessionManager %]

This restore a pre-existent session (or create new if this fails).
You can then use the plugin methods.

=head1 METHODS

=head2 get([array])

Reads a session value(s) and returns an array containing the keys values:

   Session id is [% my_sess.get('_session_id') %]

   [% FOREACH s = my_sess.get('foo', 'bar') %]
   * [% s %]
   [% END %]

Also it is possible to call C<get> method:

   [% keys = [ 'foo', 'bar' ];
      FOREACH s = my_sess.get(keys) %]
   * [% s %]
   [% END %]

Called with no args, returns all keys values.

=head2 set(hash)

Set session values 

   [% my_sess.set('foo' => 10, 'bar' => 20, ...) %]

Called with no args, has no effects.

=head2 delete(array)

Delete session values 

   [% my_sess.delete('foo', 'bar', ...) %]

Also it is possible to call C<delete> method:

   [% keys = [ 'foo', 'bar' ];
      my_sess.delete(keys) %]

Called with no args, has no effects.

=head2 destroy

Destroy current session

   [% my_sess.destroy %]

=head1 AUTHORS

Enrico Sorcinelli <enrico@sorcinelli.it>

=head1 BUGS 

This library has been tested by the author with Perl versions 5.005,
5.6.0 and 5.6.1 on different platforms: Linux 2.2 and 2.4, Solaris 2.6
and 2.7.

Send bug reports and comments to: enrico@sorcinelli.it.
In each report please include the version module, the Perl version,
the Apache, the mod_perl version and your SO. If the problem is 
browser dependent please include also browser name and
version.
Patches are welcome and I'll update the module if any problems 
will be found.

=head1 VERSION

Version 0.01

=head1 SEE ALSO

Apache::SessionManager, Template, Apache, perl

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2001-2003 Enrico Sorcinelli. All rights reserved.
This program is free software; you can redistribute it 
and/or modify it under the same terms as Perl itself. 

=cut
