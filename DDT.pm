use utf8;
use strict;
use Smart::Comments;

package DDT;
	sub _markup
	{
		my $self = shift;
		my($model, $path) = @_;
		### _markup $path: $path
		### assert: not ref $path
		my $ret;
		
		if (ref $model){
			# serialize
			my $sub = ref $model;
			$sub =~ s/::/__/g;
			$sub = '__'.$sub;
			### call: $sub
			no strict qw/refs/;
			$ret = $self->$sub($model, $path.' '.(ref $model));
			use strict qw/refs/;
		}
		else {
			$ret = $self->__($model, $path);
		}
		
		$ret;
	}

	sub __
	{
		my $self = shift;
		die 'Not implemented';
	}

	sub __ARRAY
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: $path =~ / ARRAY$/s
		
		my $ret;
		
		my @indexes = $self->__ARRAY_indexes_order($model, $path);
		
		$ret .= "\n[ ";
		foreach my $i (@indexes){
			$ret .= $self->_markup($model->[$i], $path.'->['.$i.']');
		}
		$ret .= " ]\n";
		
		$ret;
	}

	sub __ARRAY_indexes_order
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: ref $model eq 'ARRAY'
		### assert: $path =~ / ARRAY$/s
		
		# default order (as is)
		0 .. $#$model;
	}

	sub __HASH
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: $path =~ / HASH$/s
		
		my $ret;
		
		my @keys = $self->__HASH_keys_order($model, $path);
		
		foreach my $key (@keys){
			$ret .= $self->_markup($model->{$key}, $path.'->{'.$key.'}');
		}
		
		$ret;
	}

	sub __HASH_keys_order
	{
		my $self = shift;
		my($model, $path) = @_;
		### assert: ref $model eq 'HASH'
		### assert: $path =~ / HASH$/s
		
		# default order (not defined)
		keys %$model;
	}



1;
