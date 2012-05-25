use utf8;
use strict;
use Smart::Comments;

package Model;
	sub new
	{
		my $class = shift;
		
		# sample data (complex and classified structure)
		bless {
			root => [
				Model::_entry->new([
						'TITLE:1',
						'BODY:1',
						['TAG:11', 'TAG:12', ],
				]),
				Model::_entry->new([
						'TITLE:2',
						"BODY:21<br />BODY:22<br />BODY:23",
						['TAG:21', 'TAG:22', 'TAG:23', ],
				]),
			],
		}, $class;
	}

	sub root
	{
		my $self = shift;
		$self->{root};
	}

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
		my($model, $topicpath) = @_;
		### _markup $topicpath: $topicpath
		my $ret;
		
		if (ref $model){
			# serialize
			my $sub = ref $model;
			$sub =~ s/::/__/g;
			$sub = '_'.$sub;
			# call: $sub
			no strict qw/refs/;
			$ret = *$sub->($model, $topicpath);
			use strict qw/refs/;
		}
		else {
			$ret = $model;
		}
		
		$ret;
	}

	sub _Model
	{
		my($model, $topicpath) = @_;
		
		_markup($model->root, $topicpath.' '.(ref $model));
	}

	sub _ARRAY
	{
		my($model, $topicpath) = @_;
		
		my $ret;
		
		if ($topicpath =~ /Model::_entry$/s){
			### [markup Title]
			$ret .= qq{\n  <div class="title"> \n}.$model->[0].qq{\n  </div> \n};
			### [markup Body]
			$ret .= qq{\n  <div class="body"> \n}.$model->[1].qq{\n  </div> \n};
			
			# Tags
			foreach my $e (@$model[2..$#$model]){
				$ret .= qq{\n  <div>}._markup($e, $topicpath.' '.(ref $model)).qq{</div>\n};
			}
		}
		elsif ($topicpath =~ /Model::_entry ARRAY$/s){
			### [markup Tags]
			foreach my $e (@$model){
				$ret .= ' <span class="tag">'._markup($e, $topicpath.' '.(ref $model)).'</span> ';
			}
		}
		else {
			foreach my $e (@$model){
				$ret .= '{'._markup($e, $topicpath.' '.(ref $model))."}\n";
			}
		}
		
		$ret;
	}

	sub _HASH
	{
		my($model, $topicpath) = @_;
		
		my $ret;
		
		foreach my $key (keys %$model){
			$ret .= _markup($model->{$key}, $topicpath.' '.(ref $model));
		}
		
		$ret;
	}

	sub _Model___entry
	{
		my($model, $topicpath) = @_;
		
		qq{\n <div class="entry"> \n}._markup($model->c, $topicpath.' '.(ref $model)).qq{\n </div> \n};
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
###                      root => [
###                                bless( {
###                                         c => [
###                                                'TITLE:1',
###                                                'BODY:1',
###                                                [
###                                                  'TAG:11',
###                                                  'TAG:12'
###                                                ]
###                                              ]
###                                       }, 'Model::_entry' ),
###                                bless( {
###                                         c => [
###                                                'TITLE:2',
###                                                'BODY:21<br />BODY:22<br />BODY:23',
###                                                [
###                                                  'TAG:21',
###                                                  'TAG:22',
###                                                  'TAG:23'
###                                                ]
###                                              ]
###                                       }, 'Model::_entry' )
###                              ]
###                    }, 'Model' )

### _markup $topicpath: undef

### _markup $topicpath: ' Model'

### _markup $topicpath: ' Model ARRAY'

### _markup $topicpath: ' Model ARRAY Model::_entry'

### [markup Title]

### [markup Body]

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY'

### [markup Tags]

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY ARRAY'

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY ARRAY'

### _markup $topicpath: ' Model ARRAY'

### _markup $topicpath: ' Model ARRAY Model::_entry'

### [markup Title]

### [markup Body]

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY'

### [markup Tags]

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY ARRAY'

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY ARRAY'

### _markup $topicpath: ' Model ARRAY Model::_entry ARRAY ARRAY'

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
	<div>{
 <div class="entry"> 

  <div class="title"> 
TITLE:1
  </div> 

  <div class="body"> 
BODY:1
  </div> 

  <div> <span class="tag">TAG:11</span>  <span class="tag">TAG:12</span> </div>

 </div> 
}
{
 <div class="entry"> 

  <div class="title"> 
TITLE:2
  </div> 

  <div class="body"> 
BODY:21<br />BODY:22<br />BODY:23
  </div> 

  <div> <span class="tag">TAG:21</span>  <span class="tag">TAG:22</span>  <span class="tag">TAG:23</span> </div>

 </div> 
}
</div>
</body>
</html>
