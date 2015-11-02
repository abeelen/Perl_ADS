#!/usr/bin/perl -w 

# process_list.pl to retrieve the bibtex entry/pdf of a list of publication
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

if (@ARGV != 1)   { 
    print STDERR "Usage Error : 1 arguuments needed\n";
    print STDERR "    process_list.pl astroph\#\n";
    exit;
} 

print STDERR "Processing $ARGV[0]...\n";

open(INPUT,"<$ARGV[0]") or die "Error : Unable to open $ARGV[0]\n";

while(<INPUT>){
    chomp;
    if (!/^!/) { # Manage comments
	s/A&A/"A&A"/;
	s/Ap&SS/"Ap&SS"/;
	system("get_biblio.pl $_");
	sleep 1;
    }
}

