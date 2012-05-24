use utf8;
use strict;
use Smart::Comments;

package Model;
	sub new
	{
		my $class = shift;
		
		# sample data (complex and classified structure)
		bless {
			root => Model::_root->new([
				Model::_entry->new([
						Model::_title->new('TITLE:1'),
						Model::_body->new('BODY:1'),
						Model::_noop->new([Model::_tag->new('TAG:11'), Model::_tag->new('TAG:12'), ]),
				]),
				Model::_entry->new([
						Model::_title->new('TITLE:2'),
						Model::_body->new("BODY:21<br />BODY:22<br />BODY:23"),
						Model::_noop->new([Model::_tag->new('TAG:21'), Model::_tag->new('TAG:22'), Model::_tag->new('TAG:23'), ]),
				]),
			]),
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

package Model::_root;
use base qw/Model::_base/;
package Model::_entry;
use base qw/Model::_base/;
package Model::_title;
use base qw/Model::_base/;
package Model::_body;
use base qw/Model::_base/;
package Model::_tag;
use base qw/Model::_base/;
package Model::_noop;
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
		my($model, $rule) = @_;
		### assert: UNIVERSAL::isa($model, 'Model::_base') or ref($model) eq 'ARRAY' or not ref $model
		### assert: ref $rule eq 'HASH'
		my $ret;
		my $c;
		
		# serialize
		if (ref $model->c and UNIVERSAL::isa($model->c, 'Model::_base')){
			$c = _markup($model->c, $rule);
		}
		elsif (ref $model->c eq 'ARRAY'){
			### assert: not defined $c
			foreach my $e (@{$model->c}){
				$c .= _markup($e, $rule);
			}
		}
		else {
			### assert: ref $model and not ref $model->c
			$c = $model->c;
		}
		
		# markup
		if ($rule->{ref $model}){
			my $template = $rule->{ref $model};
			$template =~ s{\$c}{$c}g;
			$ret = $template;
		}
		else {
			$ret = $c;
		}
		
		$ret;
	}

{
	# main::entrypoint
	
	my $m = Model->new;
	my $markup_rule = {
		'Model::_entry' => qq{\n<div class="entry">\n \$c \n</div>\n},
		'Model::_title' => qq{\n<div class="title">\n \$c \n</div>\n},
		'Model::_body' => qq{\n<div class="body">\n \$c \n</div>\n},
		'Model::_tag' => qq{<span class="tag"> \$c </span>},
		# 'Model::_root',
		# 'Model::_noop',
	};
	
	print View->new->inject(_markup($m->root, $markup_rule));
}



__END__

=head1 NAME

DDT sample - Data-Driven HTML Template engine suggestion



=head1 Output

### Model->new: bless( {
###                      root => bless( {
###                                       c => [
###                                              bless( {
###                                                       c => [
###                                                              bless( {
###                                                                       c => 'TITLE:1'
###                                                                     }, 'Model::_title' ),
###                                                              bless( {
###                                                                       c => 'BODY:1'
###                                                                     }, 'Model::_body' ),
###                                                              bless( {
###                                                                       c => [
###                                                                              bless( {
###                                                                                       c => 'TAG:11'
###                                                                                     }, 'Model::_tag' ),
###                                                                              bless( {
###                                                                                       c => 'TAG:12'
###                                                                                     }, 'Model::_tag' )
###                                                                            ]
###                                                                     }, 'Model::_noop' )
###                                                            ]
###                                                     }, 'Model::_entry' ),
###                                              bless( {
###                                                       c => [
###                                                              bless( {
###                                                                       c => 'TITLE:2'
###                                                                     }, 'Model::_title' ),
###                                                              bless( {
###                                                                       c => 'BODY:21<br />BODY:22<br />BODY:23'
###                                                                     }, 'Model::_body' ),
###                                                              bless( {
###                                                                       c => [
###                                                                              bless( {
###                                                                                       c => 'TAG:21'
###                                                                                     }, 'Model::_tag' ),
###                                                                              bless( {
###                                                                                       c => 'TAG:22'
###                                                                                     }, 'Model::_tag' ),
###                                                                              bless( {
###                                                                                       c => 'TAG:23'
###                                                                                     }, 'Model::_tag' )
###                                                                            ]
###                                                                     }, 'Model::_noop' )
###                                                            ]
###                                                     }, 'Model::_entry' )
###                                            ]
###                                     }, 'Model::_root' )
###                    }, 'Model' )

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
<div class="entry">
 
<div class="title">
 TITLE:1 
</div>

<div class="body">
 BODY:1 
</div>
<span class="tag"> TAG:11 </span><span class="tag"> TAG:12 </span> 
</div>

<div class="entry">
 
<div class="title">
 TITLE:2 
</div>

<div class="body">
 BODY:21<br />BODY:22<br />BODY:23 
</div>
<span class="tag"> TAG:21 </span><span class="tag"> TAG:22 </span><span class="tag"> TAG:23 </span> 
</div>
</div>
</body>
</html>

