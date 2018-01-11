#!/usr/bin/perl
use strict;
use warnings;
if(scalar @ARGV <= 0) {
    print "This script counts results.tab using the filepath to dirs, and generates a output file:\nperl validator.pl /home/wendelhlc/validator/validation saida.txt\n";
    exit;
}
my $filepathToDirs = $ARGV[0];
my $output = $ARGV[1];

opendir(my $DIR, $filepathToDirs);
my @dirs = ();
while(my $dir = readdir($DIR)) {
    push @dirs, $dir;
}
shift @dirs;
shift @dirs;
closedir($DIR);

my $header = "Model";
my $body = "";
my %models = ();
open(my $FHOUT, ">", $output);
foreach my $dir (@dirs) {
    if($dir ne "." && $dir ne ".." && -d $filepathToDirs."/".$dir) {
        open(my $FILEHANDLER, "<", $filepathToDirs."/".$dir."/results.tab");
        my %matches = ();
        my $content = do { local $/; <$FILEHANDLER> };
        close($FILEHANDLER);
        for my $match($content =~ /([a-zA-Z]+)+_.+/g) {
            if(exists $matches{$match}) {
                $matches{$match}++;
            } else {
                $matches{$match} = 1 if (length $match > 1);
                $models{$match} = 1 if (!exists $models{$match} && length $match > 1);
            }
        }
        for my $key (sort keys %models ) {
            $matches{$key} = "0" if(!exists $matches{$key} );
        }
        $body .=  "\n$dir";
        $body .= "\t".$matches{$_} foreach(sort keys %matches);
        $body .= "\n";
    }
}

$header .= "\t$_" foreach(sort keys %models);

print $FHOUT $header . $body;
close($FHOUT);
exit;
