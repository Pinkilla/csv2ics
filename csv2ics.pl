#!/usr/bin/perl
#
# This script generate calendar events (ics format) from csv file.
#
# The csv file must have this form
# "Name for date","Day start ","Time start","Day end","Time end"
# 
# PiT, Pierre Bettens <pb(à)namok.be>
# 2012 september
# version 0.1.1
#
# TODO
# fix bug1
#
# BUGS
# 1. If dates are 2012 01 01 2012 01 03 then the event google create is 1 to 2
# and not to 3 !
#
# Copyright (C) <2012>  <Pit>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use strict ; 
use Text::CSV;

#
# Configuration
#
my $ics_header = << 'HEADER' ; 
BEGIN:VCALENDAR
VERSION:2.0
X-WR-TIMEZONE:Europe/Brussel
HEADER

my $ics_footer = << 'FOOT' ; 
END:VCALENDAR
FOOT


#
# Doing job
#
print $ics_header ; 

open (my $fh, "<:encoding(latin1)", $ARGV[0]) or die "Open file: $!";
my $csv = Text::CSV->new();
while ( <$fh> ) {
	#
	# "Name for date","Day start ","Time start","Day end","Time end"
	# Skip first line
	next if ($. == 1);
	if ($csv->parse($_)) {
		my @fields = $csv->fields();
		print "\nBEGIN:VEVENT\n";
		print "SUMMARY:$fields[0]\n";
		
		# Décomposition de la date (départ)
		my @split = split("/", $fields[1]);
		my $dtstart = $split[2] . $split[1] . $split[0];
		@split = split(":", $fields[2]);
		if (@split) {
			$dtstart .= "T" . $split[0] . $split[1] . "00";
		}
#		print "DTSTAMP:$dtstart"."T000000Z\n";
		print "DTSTART:$dtstart\n";

		# Décomposition de la date (fin)
		@split = split("/", $fields[3]);
		my $dtend = $split[2] . $split[1] . $split[0];
		@split = split(":", $fields[4]);
		if (@split) {
			$dtend .= "T" . $split[0] . $split[1] . "00";
		}
		print "DTEND:$dtend\n";

		print "END:VEVENT\n";
	} else {
		print "Failed to parse $csv->error_input()";
	}
}

print $ics_footer ; 







