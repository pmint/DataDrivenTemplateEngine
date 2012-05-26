package main;

use utf8;
use strict;
use Smart::Comments;

use Views;
use Models;

{
	# main::entrypoint
	
	### Model->new
	
	my $m = Model::_entries->new;
	my $v = View::_entries->new;
	my $ddt = DDT::_entries->new;
	
	print $v->inject($ddt->_markup($m));
}



package DDT::_entries;
use base qw/DDT/;

	sub __Model___entries
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: $path =~ / Model::_entries$/s
		
		$self->_markup($model->c, $path);
	}

	sub __Model___entry
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: $path =~ / Model::_entry$/s
		my $ret;
		
		# In case of fixed order
		$ret .= qq{\n <div class="entry"> \n};
		
		foreach my $key (qw/title body tags/){
			$ret .= $self->_markup($model->c->{$key}, $path.'->{'.$key.'}');
		}
		
		$ret .= qq{\n </div> \n};
		
		$ret;
	}

	sub __ARRAY_indexes_order
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: ref $model eq 'ARRAY'
		### assert: $path =~ / ARRAY$/s
		
		if ($path =~ / Model::_entries ARRAY$/s){
			# Model::_entries order
			0 .. $#$model;
		}
		elsif ($path =~ / Model::_entry->{tags} ARRAY$/s){
			# tags order
			0 .. $#$model;
		}
		else {
			die $path;
		}
	}

	sub __
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: not ref $model
		### assert: $path
		my $ret;
		
		# Markup
		if ($path =~ / Model::_entry->{title}$/s){
			### [markup Title]
			$ret .= qq{\n  <div class="title"> \n $model \n  </div> \n};
		}
		elsif ($path =~ / Model::_entry->{body}$/s){
			### [markup Body]
			$ret .= qq{\n  <div class="body"> \n $model \n  </div> \n};
		}
		elsif ($path =~ / Model::_entry->{tags} ARRAY->\[\d+\]$/s){
			### [markup Tag]
			$ret .= qq{ <span class="tag"> $model </span> };
		}
		else {
			$ret .= $model;
		}
		
		$ret;
	}

	sub new
	{
		bless {}, shift;
	}



__END__

=head1 NAME

DDT sample - Data-Driven HTML Template engine suggestion



=head1 Output

### Model->new

### _markup $path: undef

### call: '__Model___entries'

### _markup $path: ' Model::_entries'

### call: '__ARRAY'

### _markup $path: ' Model::_entries ARRAY->[0]'

### call: '__Model___entry'

### _markup $path: ' Model::_entries ARRAY->[0] Model::_entry->{title}'

### [markup Title]

### _markup $path: ' Model::_entries ARRAY->[0] Model::_entry->{body}'

### [markup Body]

### _markup $path: ' Model::_entries ARRAY->[0] Model::_entry->{tags}'

### call: '__ARRAY'

### _markup $path: ' Model::_entries ARRAY->[0] Model::_entry->{tags} ARRAY->[0]'

### [markup Tag]

### _markup $path: ' Model::_entries ARRAY->[0] Model::_entry->{tags} ARRAY->[1]'

### [markup Tag]

### _markup $path: ' Model::_entries ARRAY->[1]'

### call: '__Model___entry'

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{title}'

### [markup Title]

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{body}'

### [markup Body]

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{tags}'

### call: '__ARRAY'

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{tags} ARRAY->[0]'

### [markup Tag]

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{tags} ARRAY->[1]'

### [markup Tag]

### _markup $path: ' Model::_entries ARRAY->[1] Model::_entry->{tags} ARRAY->[2]'

### [markup Tag]



<html>
<head>
        <title>DDT sample</title>
        <style>
                .entry {
                        margin: 2em 0;
                }
                .title {
                        border: solid navy;
                        border-width: thin thin thin 1em;
                        font-size: x-large;
                        padding: 0 1ex;
                }
                .body {
                        padding: 1em 1em 1em 2em;
                }
                .tag {
                        border: dashed silver thin;
                        margin: 0 1ex;
                        padding: 0 1ex;
                        font-size: x-small;
                }
        </style>
</head>
<body>
        <div>
[
 <div class="entry">

  <div class="title">
 TITLE:1
  </div>

  <div class="body">
 BODY:1
  </div>

[  <span class="tag"> TAG:11 </span>  <span class="tag"> TAG:12 </span>  ]

 </div>

 <div class="entry">

  <div class="title">
 TITLE:2
  </div>

  <div class="body">
 BODY:21<br />BODY:22<br />BODY:23
  </div>

[  <span class="tag"> TAG:21 </span>  <span class="tag"> TAG:22 </span>  <span class="tag"> TAG:23 </span>  ]

 </div>
 ]
</div>
</body>
</html>

