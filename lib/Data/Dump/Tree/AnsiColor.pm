 
class AnsiColor
{
has %!color_lookup ;
has Bool $.is_ansi is rw = False ;

method new
{
my $o = self.bless() ;

try
	{
	require Terminal::ANSIColor;
	$o.is_ansi = True ;
	}

$o
}

method !set_lookup_table(%lookup, $ansi_code) { for %lookup.kv -> $k, $v { %!color_lookup{$k} = $ansi_code($v) } }

method set_colors(%lookup, Bool $do_ansi)
{
%lookup<reset> = 'reset' ;
	
$.is_ansi && $do_ansi 
	?? self!set_lookup_table(%lookup, GLOBAL::Terminal::ANSIColor::EXPORT::DEFAULT::<&color>)
	!! self!set_lookup_table(%lookup, sub (Str $s) {''}) ;

}


multi method color(List $l, Str $name --> Seq) { $l.map: { %!color_lookup{$name} ~ $_ ~ %!color_lookup<reset>} }
multi method color(Str $string, Str $name --> Str) { %!color_lookup{$name} ~ $string ~ %!color_lookup<reset> }

#class
}


