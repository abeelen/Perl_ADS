#!/usr/bin/perl -w 

# get_author.pl to retrieve bibtex entry of an author in ads
# Copyright (C) 2004 Alexandre Beelen
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#

use LWP::UserAgent;
use strict;

if (@ARGV != 3)   { 
    print "Usage Error : You must use 3 arguments\n";
    print " get_author.pl Name Year_start Year_end\n";
    exit;
} 

# 
# Check for the existence of the article and retrieve his bibcode 
#

my $server_url = "http://cdsads.u-strasbg.fr";
#my $server_url = "http://adsabs.harvard.edu";
my $pre_url="/cgi-bin/nph-abs_connect";
my ($author, $start_year, $end_year) = @ARGV;

my $url = "$server_url$pre_url?author=$author&start_year=$start_year&end_year=$end_year";

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');
my $request = HTTP::Request->new('GET', $url);
my $res = $ua->request($request);

if ( $res->is_success ) {
    my $content = $res->content;
    $content=~/<strong>(.*)<\/strong> abstract/g;

    if($1 >= 1) {

	my @content2 = split /\n/, $content;
	for (@content2) {
	    if ( /bibcode\" value=\"(.*)\">\&nbsp;/) {
		my $bibcode =$1;
		$bibcode =~ s/&amp;/%26/;
		my $pre_url = "/cgi-bin/nph-bib_query";
		my $url = "$server_url$pre_url?bibcode=$bibcode&data_type=BIBTEX&db_key=AST%26nocookieset=1";
		$request = HTTP::Request->new('GET', $url);
		my $res = $ua->request($request);
		if ( $res->is_success ) {
		    if ($res->content =~ m/\@(.*)\}/gs) {
			print "\@$1 \}\n";
		    }    
		} else {print "Unable to retrieve bibtex entry: $bibcode\n";}
	    }
	}
    } else {print "Unable to retrieve entry for name and dates\n";}
    
} else { print "Error connecting to ADS ($server_url)\n";} 
