use utf8;
use strict;
use Smart::Comments;

package Model::_base;
	sub new
	{
		my $class = shift;
		my($content) = @_;
		
		bless _init($content), $class;
	}
	sub _init
	{
		my($content) = @_;
		{c => $content};
	}
	sub c
	{
		my $self = shift;
		$self->{c};
	}

package Model::_entry;
use base qw/Model::_base/;

package Model::_entries;
use base qw/Model::_base/;

	sub new
	{
		my $class = shift;
		
		# sample data (complex and classified structure)
		my $content = [
			Model::_entry->new({
					title => 'TITLE:1',
					body => 'BODY:1',
					tags => ['TAG:11', 'TAG:12', ],
			}),
			Model::_entry->new({
					title => 'TITLE:2',
					body => "BODY:21<br />BODY:22<br />BODY:23",
					tags => ['TAG:21', 'TAG:22', 'TAG:23', ],
			}),
		];
		
		$class->SUPER::new($content);
	}



1;
