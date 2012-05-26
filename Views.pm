use utf8;
use strict;
#use Smart::Comments;

package View::_entries;
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



1;
