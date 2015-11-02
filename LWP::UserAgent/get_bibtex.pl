#!/usr/bin/perl -w 

# get_bibtex.pl to retrieve bibtex entry of a published entry in ads
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

if (@ARGV != 1)   { 
    print STDERR "Usage Error : 1 arguments needed\n";
    print STDERR " get_bibtex.pl bibcode\n";
    exit;
} 

my $bibcode = $ARGV[0];

# Now get the bibtex entry
$bibcode =~ s/&amp;/%26/;
my $server_url = "http://cdsads.u-strasbg.fr";
my $pre_url = "/cgi-bin/nph-bib_query";
my $url = "$server_url$pre_url?bibcode=$bibcode&data_type=BIBTEX";
my $request = HTTP::Request->new('GET', $url);

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');

my $res = $ua->request($request);
if ( $res->is_success ) {
    if ($res->content =~ m/\@(.*)\n}/gs) {
	print "\@$1\n}";
    } else {
	print STDERR "Error : Unable to retrieve bibtex for $bibcode\n";}
} else {
    print STDERR "Error : Unable to connect to ADS server\n";
}

