#!/usr/bin/perl -w 

# get_astroph.pl to retrieve the bibcode entry of a published entry in astro-ph
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
use Astro::ADS::Query;

if (@ARGV != 1)   { 
    print "Usage Error : 1 arguments needed\n";
    print " get_astroph.pl astro-ph\#\n";
    exit;
} 

my $astroph = $ARGV[0];
$astroph =~ s/astro-ph\///;

my $server_url = "http://fr.arxiv.org";
my $pre_url = "/abs/astro-ph/";
my $url = "$server_url$pre_url?$astroph";
my $request = HTTP::Request->new('GET', $url);

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');

my $res = $ua->request($request);
if ( $res->is_success ) {
    
    # Retrieve the article title
    if ($res->content =~ m/<TITLE>\[astro-ph\/$astroph\] (.*)<\/TITLE>/gs) {
	my $title = $1;
	$title =~ s/\n //gs;
	
	# Get the bibcode via Astro::ADS::Query
	my $query = new Astro::ADS::Query("Title" => $title);
	
	my $result  = $query->querydb();
	my @papers  = $result->papers;
	
	scalar(@papers) != 0 or die "Error : no article with this title in ADS\n";
	
	if (scalar(@papers) == 1){
	    print $papers[0]->bibcode();
	} 
	if (scalar(@papers) == 2){
	    if ($papers[0]->bibcode() =~ m/L\./){
		print $papers[1]->bibcode();
	    } else {
		print $papers[0]->bibcode();
	    }
	    print STDERR "Warning : Assume it is not a letter\n";
	}
	if (scalar(@papers) > 2) {
	    print STDERR "Error : multiple results on this title\n";
	}
    }
    
    
} else {
    print STDERR "Unable to connect to astro-ph server\n";
}
