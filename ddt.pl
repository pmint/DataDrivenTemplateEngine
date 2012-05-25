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

package Model;
use base qw/Model::_base/;

	sub new
	{
		my $class = shift;
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
		
		# sample data (complex and classified structure)
		$class->SUPER::new($content);
	}



package View;
	sub new
	{
		my $class = shift;

	 	bless {
			template => <<'__TEMPLATE__'
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
	<div><!--data--></div>
</body>
</html>
__TEMPLATE__
			,
		}, $class;
	}

	sub inject
	{
		my $self = shift;
		my($c) = @_;
		### assert: not ref $c
		
		$self->{template} =~ s{<!--data-->}{$c}e;
		$self->{template};
	}



package main;

	### Model->new

	sub _markup
	{
		my($model, $path) = @_;
		### _markup $path: $path
		my $ret;
		
		if (ref $model){
			# serialize
			my $sub = ref $model;
			$sub =~ s/::/__/g;
			$sub = '_'.$sub;
			# call: $sub
			no strict qw/refs/;
			$ret = $sub->($model, $path.' '.(ref $model));
			use strict qw/refs/;
		}
		elsif ($path =~ /Model::_entry HASH->{title}$/s){
			### [markup Title]
			$ret .= qq{\n  <div class="title"> \n $model \n  </div> \n};
		}
		elsif ($path =~ /Model::_entry HASH->{body}$/s){
			### [markup Body]
			$ret .= qq{\n  <div class="body"> \n $model \n  </div> \n};
		}
		elsif ($path =~ /Model::_entry HASH->{tags} ARRAY->\[\d+\]$/s){
			### [markup Tag]
			$ret .= qq{ <span class="tag"> $model </span> };
		}
		else {
			$ret = $model;
		}
		
		$ret;
	}

	sub _ARRAY
	{
		my($model, $path) = @_;
		
		my $ret;
		
		$ret .= "\n[ ";
		### assert: $path =~ / ARRAY$/s
		foreach my $i (0 .. $#$model){
			$ret .= _markup($model->[$i], $path.'->['.$i.']');
		}
		$ret .= " ]\n";
		
		$ret;
	}

	sub _HASH
	{
		my($model, $path) = @_;
		
		my $ret;
		
		### assert: $path =~ / HASH$/s
		foreach my $key (keys %$model){
			$ret .= _markup($model->{$key}, $path.'->{'.$key.'}');
		}
		
		$ret;
	}

	sub _Model
	{
		my($model, $path) = @_;
		
		_markup($model->c, $path);
	}

	sub _Model___entry
	{
		my($model, $path) = @_;
		my $ret;
		
		### assert: $path =~ / Model::_entry$/s
		# $ret .= qq{\n <div class="entry"> \n}._markup($model->c, $path).qq{\n </div> \n};
		
		# In case of fixed order
		$ret .= qq{\n <div class="entry"> \n};
		$ret .= _markup($model->c->{title}, $path.' HASH->{title}');
		$ret .= _markup($model->c->{body}, $path.' HASH->{body}');
		$ret .= _markup($model->c->{tags}, $path.' HASH->{tags}');
		$ret .= qq{\n </div> \n};
		
		$ret;
	}

{
	# main::entrypoint
	
	my $m = Model->new;
	
	print View->new->inject(_markup($m));
}



__END__

=head1 NAME

DDT sample - Data-Driven HTML Template engine suggestion



=head1 Output


### Model->new: bless( {
###                      c => [
###                             bless( {
###                                      c => {
###                                             body => 'BODY:1',
###                                             tags => [
###                                                       'TAG:11',
###                                                       'TAG:12'
###                                                     ],
###                                             title => 'TITLE:1'
###                                           }
###                                    }, 'Model::_entry' ),
###                             bless( {
###                                      c => {
###                                             body => 'BODY:21<br />BODY:22<br />BODY:23',
###                                             tags => [
###                                                       'TAG:21',
###                                                       'TAG:22',
###                                                       'TAG:23'
###                                                     ],
###                                             title => 'TITLE:2'
###                                           }
###                                    }, 'Model::_entry' )
###                           ]
###                    }, 'Model' )

### _markup $path: undef

### _markup $path: ' Model'

### _markup $path: ' Model ARRAY->[0]'

### _markup $path: ' Model ARRAY->[0] Model::_entry HASH->{title}'

### [markup Title]

### _markup $path: ' Model ARRAY->[0] Model::_entry HASH->{body}'

### [markup Body]

### _markup $path: ' Model ARRAY->[0] Model::_entry HASH->{tags}'

### _markup $path: ' Model ARRAY->[0] Model::_entry HASH->{tags} ARRAY->[0]'

### [markup Tag]

### _markup $path: ' Model ARRAY->[0] Model::_entry HASH->{tags} ARRAY->[1]'

### [markup Tag]

### _markup $path: ' Model ARRAY->[1]'

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{title}'

### [markup Title]

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{body}'

### [markup Body]

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{tags}'

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{tags} ARRAY->[0]'

### [markup Tag]

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{tags} ARRAY->[1]'

### [markup Tag]

### _markup $path: ' Model ARRAY->[1] Model::_entry HASH->{tags} ARRAY->[2]'

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

