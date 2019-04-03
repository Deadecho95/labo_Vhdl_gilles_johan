#-------------------------------------------------------------------------------
# Copyright 2012 HES-SO Valais Wallis (www.hevs.ch)
#-------------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program IS distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>
# ------------------------------------------------------------------------------
# trimLibs
#   Comment regular libraries in an concatenated file
#   Help Parameter : <?>
#   Parameter : <Input File Name> <Output File Name>
# ------------------------------------------------------------------------------
#  Authors: 
#    cof: [François Corthay](francois.corthay@hevs.ch)
#    guo: [Oliver A. Gubler](oliver.gubler@hevs.ch)
#    zas: [Silvan Zahno]
#	 gal: [Laurent Gauch]
# ------------------------------------------------------------------------------
# Changelog:
#	2015-08-25 : guo
#	  + added unisim to the list of excluded libraries
#   2015-05-08 : guo
#     + added verbosity debug
#     * changed this header
#     * minor comment modifications
#  2013-08-13 : zas guo      
#     Handle error if environment variable not found, character'pos('$') -> ')
#     was found as env var, added exception
#   2013-06-13 : cof zas guo  
#     Remove comments from testline
#   2013-01-09 : cof  -- 
#     Bugfix: no carriage return on commented "use" statements
#     Bugfix: more precise targeting of "library" statement
#     Bugfix: "Library" test after "use" test
#   2012-04-27 : zas
#     Bugfix: on feature added in version 2011-06-10
#   2012-02-02 : zas  
#     Write the output into a new file with the name defined in the 
#     $DESIGN_NAME variable
#   2012-01-23 : zas  
#     Replaces $env_var_name by the value of the found environemnt variable.
#     Mostly used to replace $SIMULATION_DIR for initialise bram's from a file 
#     placed in the Simulation Directory
#   2011-06-10 : zas
#     Replaces
#       library xxx;use xxx.yyy.all;
#     with                          
#       --library xxx;
#       use work.yyy.all;
#   2005...2011 : cof
#     Improvements
#   2005-01-29 : gal
#	  initlial release
# ------------------------------------------------------------------------------

$separator = '-' x 79;
$indent = ' ' x 2;
$hdlInFileSpec = $ARGV[0];
$hdlOutFileSpec = $ARGV[1] . '.vhd';

$verbose = 1;
$debug = 0;

#-------------------------------------------------------------------------------
# program I/O files
#
$tempFileSpec = $hdlOutFileSpec . '.tmp';

if ($verbose == 1) {
  print "\n$separator\n";
  print "Trimming library declarations from $hdlInFileSpec to $hdlOutFileSpec\n";
  print $indent, "temporary file spec: $tempFileSpec\n";
}

#-------------------------------------------------------------------------------
# read original file, edit and save to temporary file
#
my $line;

open(HDLFile, $hdlInFileSpec) || die "couldn't open $HDLFileSpec!";
open(tempFile, ">$tempFileSpec");
while (chop($line = <HDLFile>)) {
  
  # remove all comment for the test
  my $testline = $line;
  $testline =~ s/--.*//;
  
  # Replace 'use xxx.yyy' with 'use work.yyy', except if xxx is ieee or std or unisim
  if ($testline =~ m/use\s.*\.all\s*;/i) {
    if ( not($testline =~ m/\bieee\./i) and 
		 not($testline =~ m/\bstd\./i)  and 
		 not($testline =~ m/\bunisim\./i)) {
      # if there is any char before "use" except \s, insert new line \n
      if ( ($testline =~ m/[^\s]\s*use/i) ) {
        $line =~ s/use\s+.*?\./\nuse work./i;
        if ($debug == 1) {
          print "TEST0099: ", $testline, "\n"
        }
      }
      else {
        $line =~ s/use\s+.*?\./use work./i;
        if ($debug == 1) {
          print "TEST0105: ", $testline, "\n"
        }
      }
    }
  }
  
  # Comment libraries which aren't ieee or std or unisim
  if (($testline =~ m/\slibrary\s+/i) or ($testline =~ m/\Alibrary\s+/i)) {
    if ( not($testline =~ m/ieee/i) and 
		 not($testline =~ m/std/i) and 
		 not($testline =~ m/unisim/i)) {
      $line = '-- ' . $line;
    }
  }
  
  # Comment "FOR ALL : yyy USE ENTITY xxx.yyy;
  if ($testline =~ m/for\s+all\s+/i) {
    $line = '-- ' . $line;
  }
  
  # Search for $Env_Var_Names and replace them by the value of the env_var
  if ($testline =~ m/(\$[^\s\/.'"\\]+)/i) {
    $envvar = $1;
    $envvar =~ s/^.//;
    eval {
      $line =~ s/\$$envvar/$ENV{$envvar}/;
    };
    if ($@) {
      print ("WARNING: Environment Variable not found: $envvar \n")
    }
    
  }
  
  print tempFile ("$line\n");
}

close(tempFile);
close(HDLFile);

#-------------------------------------------------------------------------------
# delete original file and rename temporary file
#
unlink($hdlOutFileSpec);
rename($tempFileSpec, $hdlOutFileSpec);

if ($verbose == 1) {
  print "$separator\n";
}

#if ($verbose == 1) {
#  print $indent, "Hit any <CR> to continue";
#  $dummy = <STDIN>;
#}
