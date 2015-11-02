#!/usr/bin/perl -w 

# get_biblio.pl to retrieve the bibtex entry/pdf of a publication 
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

use strict;

if ($#ARGV != 0 and $#ARGV != 2)   { 
    print STDERR "Usage Error : 1 or 3 arguments needed\n";
    print STDERR "    get_biblio.pl astroph\#\n";
    print STDERR "or  get_biblio.pl Journal Volume Page\n";
    exit;
} 


print STDERR "Processing @ARGV\n";

my $bibcode;

if (@ARGV == 1) {
# We've got an astro-ph query
    $bibcode = `get_astroph.pl "$ARGV[0]"` ;
}

if (@ARGV == 3) {
# We've got an Journal/Volume/Page query
    $bibcode = `get_bibcode.pl "$ARGV[0]" "$ARGV[1]" "$ARGV[2]"`;
}

if ($bibcode and $bibcode !~ /Error/gs) {
# Retrieving the bibtex/pdf entry for this paper

    print STDERR " - retrieved bibcode ($bibcode)\n";
    my $bibtex = `get_bibtex.pl "$bibcode"`;
    if ($bibtex and $bibtex !~ /Error/gs){
	print STDERR " - retrieved bibtex\n";
    } else {
	print STDERR "Error : Unable to retrieve bibtex\n";
    }

    my $out = system('get_bibpdf.pl',"$bibcode");
    if (-e "$bibcode.pdf" or -e $bibcode."_arXiv.pdf"){
	print STDERR " - retrieved pdf\n";
    } else {
	print STDERR "Error : Unable to retrieve the pdf file\n";
    }

    print STDOUT $bibtex,"\n";

} else {
    
    print STDERR "Error : Unable to retrieve bibcode for '@ARGV'\n";

}
