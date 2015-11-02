#!/usr/bin/perl -w 

# get_bibcode.pl to retrieve the bibcode entry of a published entry in ads
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

if (@ARGV != 3)   { 
    print STDERR "Usage Error : 3 arguments needed\n";
    print STDERR " get_bibcode.pl Journal Volume Page\n";
    exit;
} 

my ($journal, $volume, $page ) = @ARGV;

# Get the bibcode via Astro::ADS::Query
my $query = new Astro::ADS::Query("JournalVolumePage" => 
				  [ $journal, $volume, $page ]);

my $result  = $query->querydb();
my @papers  = $result->papers;

scalar(@papers) != 0 or die "Error : no article with this title in ADS";

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
    print STDERR "Error : multiple results on $journal, $volume, $page\n";
}
