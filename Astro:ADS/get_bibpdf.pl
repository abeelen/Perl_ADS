#!/usr/bin/perl -w 

# get_bibpdf.pl to retrieve a pdf file of a published entry in ads
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

use strict;

use LWP::UserAgent;
use Astro::ADS::Query;

if (@ARGV != 1)   { 
    print STDERR "Usage Error : 1 arguments needed\n";
    print STDERR " get_bibpdf.pl bibcode\n";
    exit;
} 

my $bibcode = $ARGV[0];
$bibcode =~ s/&amp;/%26/;

# Now get the bibtex entry

my $server_url = "http://cdsads.u-strasbg.fr";
my $preprint_url = "http://fr.arxiv.org";
my $pre_url = "/cgi-bin/nph-data_query";
my $url = "$server_url$pre_url?bibcode=$bibcode&link_type=ARTICLE";

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');


# get the PDF

my $request = HTTP::Request->new('GET', $url);
my $res = $ua->request($request);
if ( $res->is_success ) {
    if ($res->content !~ /<HTML>/ and $res->content !~ /<html>/) {    
	my $filename = "$bibcode.pdf";
	open(OUTPUT,">$filename") or die "Error openning $bibcode.pdf";
	print OUTPUT $res->content;
	close OUTPUT; 
    } else { 
	my $astroph;
	
	# Try PREPRINT type
	$url = "$server_url$pre_url?bibcode=$bibcode&link_type=PREPRINT";
	$request = HTTP::Request->new('GET', $url);
	$res = $ua->request($request);
	if ( $res->is_success ) {
	    if ($res->content =~ m/<TITLE>\[astro-ph\/(.*)\](.*)<\/TITLE>/gs) {
		$astroph = $1; 
	    } 
	} else {
	    # Try to look for title in astro-ph
	    
	    my $query = new Astro::ADS::Query("Bibcode" => $bibcode);
	    my $result  = $query->querydb();
	    my @papers  = $result->papers;
	    if (scalar(@papers) == 1){
		my $title = $papers[0]->title;
		$title =~ s/ /+/gs;

		$url = "$server_url/cgi-bin/nph-abs_connect?db_key=PRE&PRE=YES&group_sel=astro-ph&ttl_logic=AND&ttl_syn=YES&title=$title";
		$request = HTTP::Request->new('GET', $url);
		$res = $ua->request($request);
		if ( $res->is_success ) {
		    if ($res->content =~ m/<strong>1<\/strong>/gs) {
			$res->content =~ m/name="bibcode" value="(.*)">&nbsp;<a/;
			my $astroph_bibcode = $1;
			print STDERR "Warning : matched $bibcode to $astroph_bibcode\n";
			$url = "$server_url$pre_url?bibcode=$astroph_bibcode&link_type=PREPRINT";
			$request = HTTP::Request->new('GET', $url);
			$res = $ua->request($request);
			if ( $res->is_success ) {
			    if ($res->content =~ m/<TITLE>\[astro-ph\/(.*)\](.*)<\/TITLE>/gs) {
				$astroph = $1; 
			    }
			} else { print STDERR "Error : Unable to connect to astro-ph\n"; }  
		    } else { print STDERR "Error : No or multiple match in astro-ph\n"; } 
		} else { print STDERR "Error : Unable to connect to ADS\n"; }
	    } else { print STDERR "Error : Unable to retrieve the paper title in ADS\n"; }
	}
	
	if ($astroph) {
	    $url = "$preprint_url/pdf/astro-ph/$astroph";
	    $request = HTTP::Request->new('GET', $url);
	    $res = $ua->request($request);
	    while ($res->content =~ /<HTML>/){
		print STDERR ".";
		sleep 10;
		$request = HTTP::Request->new('GET', $url);
		$res = $ua->request($request);    
	    }
	    my $filename = $bibcode."_arXiv.pdf";
	    open(OUTPUT,">$filename") or die "Error openning".$bibcode."_arXiv.pdf";
	    print OUTPUT $res->content;
	    close OUTPUT;   
	}
    } 
} else { 
    print STDERR "Error : Unable to connect to ADS or ArXiv services\n"; 
}
