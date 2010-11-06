# Template::Zoom - Template::Zoom Rose database class
#
# Copyright (C) 2010 Stefan Hornburg (Racke) <racke@linuxia.de>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

package Template::Zoom::Database::Rose;

use strict;
use warnings;

use Rose::DB;

use Template::Zoom::Iterator::Rose;

# Constructor
sub new {
	my ($class, @args) = @_;
	my ($self);
	
	$class = shift;
	$self = {@args};

	bless $self, $class;
	
	$self->initialize();
	
	return $self;
}

# Initialization routine
sub initialize {
	my ($self) = @_;
	
	my %rose_parms;
	
	if ($self->{dbh}) {
		# database handle exist already
	}
	else {
		%rose_parms = (domain => 'default',
					   type => 'default',
					   driver => $self->{dbtype},
					   database => $self->{dbname},
					   username => $self->{dbuser},
					   password => $self->{dbpass},
					  );
		
		Rose::DB->register_db(%rose_parms);
		$self->{rose} = new Rose::DB;
		$self->{dbh} = $self->{rose}->dbh();
	}
}

# Build query and return iterator
sub build {
	my ($self, $query) = @_;
	my ($iter);

	$iter = new Template::Zoom::Iterator::Rose(dbh => $self->{dbh},
											   query => $query);
	$iter->build();

	return $iter;
}

1;