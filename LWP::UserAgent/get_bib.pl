#!/usr/bin/perl -w 

# get_bib.pl to retrieve bibcode entry of a published entry in ads
# Copyright (C) 2002 Alexandre Beelen
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
    print "Usage Error : 3 arguments needed\n";
    print " get_bib.pl Journal Volume Page\n";
    exit;
} 

# 
# Check for the existence of the article and retrieve his bibcode 
#

my $server_url = "http://cdsads.u-strasbg.fr";
#my $server_url = "http://adsabs.harvard.edu";
my $pre_url="/cgi-bin/nph-abs_connect";
my ($journal, $volume, $page ) = @ARGV;
$journal =~ s/&/%26/;
my $url = "$server_url$pre_url?bibstem=$journal&volume=$volume&page=$page";

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');
my $request = HTTP::Request->new('GET', $url);
my $res = $ua->request($request);

if ( $res->is_success ) {
    my $content = $res->content;
    $content=~/<strong>(.*)<\/strong> abstract/g;

    if($1 == 1) {
	$content=~/bibcode\" value=\"(.*)\">\&nbsp;</g;
	my $bibcode = $1;
#	select STDERR;
#	print "Got the bibcode : $bibcode\n";
#	select;
	$bibcode =~ s/&amp;/%26/;	my $pre_url = "/cgi-bin/nph-bib_query";
	my $url = "$server_url$pre_url?bibcode=$bibcode&data_type=BIBTEX&db_key=AST%26nocookieset=1";
	$request = HTTP::Request->new('GET', $url);
	my $res = $ua->request($request);
	if ( $res->is_success ) {
	    if ($res->content =~ m/\@(.*)\}/gs) {
		   print "\@$1 \}\n";
		}
	   
	} else {print "Unable to retrieve bibtex entry\n";}
    }else {print "Unable to retrieve beginning of an article at this Journal/Volume/Page\n";}

} else { print "Error connecting to ADS ($server_url)\n";} 
