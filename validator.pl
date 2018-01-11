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
            }
        }
        print $FHOUT "\n$dir";
        print $FHOUT "\n".$_.": ".$matches{$_} foreach(keys %matches);
    }
}

close($FHOUT);
