Perl ADS
========

These [perl][perl] scripts are used to access the [ADS][ADS] database in an easy way, directly from the shell prompt. They are useful to build a bibtex database, retrieve pdf files of a list of paper, or to make simple statistics. There is two sets of scripts : the first one, somehow older, is based on [LWP::UserAgent][LWPUA] to access directly [ADS][ADS] web pages. The second is a rewrite of the latter using the [Astro::ADS][AstroADS] library.
￼
Scripts using the [LWP::UserAgent][LWPUA] library
-------------------------------------------------

- ```get_author.pl``` : produce bibliography in the bibtex format from ADS, given an author name and start/stop year
- ```get_bib.pl``` : retrieve the bibtex entry of an article in ADS given its journal, volume and page.
- ```get_bibtex.pl``` : retrieve the bibtex entry of an article in ADS given its bibcode
￼

Scripts using the [Astro::ADS][AstroADS] library
------------------------------------------------

- ```adsastro.patch``` : patch for the Astro::ADS library to take the Journal/Volume/Page information as an entry
- ```get_biblio.pl``` : retrieve a specific bibtex entry and the pdf of a given astro-ph or ADS article
- ```process_list.pl``` : retrieve the pdf and bibtex entry of a list of mixed astro-ph and ADS (J/V/P) entries
- ```get_astroph.pl``` : get the bibcode of an article published in astro-ph, given its id number
- ```get_bibcode.pl``` : get the bibcode of an article published in ADS given its journal, volume and page
- ```get_bibpdf.pl```  : retrieve the pdf of a given bibcode



[perl]: https://www.perl.org/ "The Perl Programming Language"
[ADS]: http://adsabs.harvard.edu/ "The SAO/NASA Astrophysics Data System"
[LWPUA]:  http://search.cpan.org/~ether/libwww-perl-6.13/lib/LWP/UserAgent.pm "LWP::UserAgent - Web user agent class"
[AstroADS]: http://search.cpan.org/~duffee/Astro-ADS-1.26/ADS.pm "Astro::ADS - An object orientated interface to NASAs ADS database"
