#!/usr/bin/perl
# filename:          update_ise.vhd
# kind:              VHDL file
# first created:     27.05.2012
# created by:        Corthay Francois & Zahno Silvan & Oliver Gubler
################################################################################
# History:
# V2.0 : guo 2015-05-26 -- update to environment from HELS v.15.0526
# V0.1 : cof 27.05.2012 -- Initial release
################################################################################
# Description: 
# Update the File references in the .xise Xilinx Project file
################################################################################

$separator = '-' x 79;
$indent = ' ' x 2;
$iseFileSpec = $ARGV[0];
$baseDir = "$ENV{DESIGN_SCRATCH_DIR}";
$vhdlFileSpec = "$ENV{HDS_CONCAT_DIR}\\$ENV{DESIGN_NAME}.vhd";
$ucfFileSpec = "$ENV{HDS_CONCAT_DIR}\\$ENV{DESIGN_NAME}.ucf";

print "vhdlFileSpec: $vhdlFileSpec\n";
#print "edifFileSpec: $edifFileSpec\n";
print "ucfFileSpec: $ucfFileSpec\n";

$verbose = 1;

#-------------------------------------------------------------------------------
# program I/O files
#
$tempFileSpec = $iseFileSpec . '.tmp';

if ($verbose == 1) {
  print "\n$separator\n";
  print "Updating file specifications in $iseFileSpec\n";
  print $indent, "temporary file spec: $tempFileSpec\n";
}

#-------------------------------------------------------------------------------
# read original file, edit and save to temporary file
#
my $line;

open(ISEFile, $iseFileSpec) || die "couldn't open $iseFileSpec!";
open(tempFile, ">$tempFileSpec");
while (chop($line = <ISEFile>)) {
                                                            # replace VHDL files
  if ($line =~ m/FILE_VHDL/i) {
    $line =~ s/<file\s+xil_pn\:name=.*?".+?"/<file xil_pn:name="$vhdlFileSpec"/ig;
  }
                                                            # replace EDIF files
  if ($line =~ m/FILE_EDIF/i) {
    $line =~ s/<file\s+xil_pn\:name=.*?".+?"/<file xil_pn:name="$edifFileSpec"/ig;
  }
                                                             # replace UCF files
  if ($line =~ m/FILE_UCF/i) {
    $line =~ s/<file\s+xil_pn\:name=.*?".+?"/<file xil_pn:name="$ucfFileSpec"/ig;
  }
                                                      # Implementation Top files
  if ($line =~ m/\.vhd"/i) {
    $line =~ s/<property\s+xil_pn:name="Implementation\s+Top\s+File"\s+xil_pn\:value=".+?"/<property xil_pn:name="Implementation Top File" xil_pn:value="$vhdlFileSpec"/ig;
  }
  if ($line =~ m/\.edf"/i) {
    $line =~ s/<property\s+xil_pn:name="Implementation\s+Top\s+File"\s+xil_pn\:value=".+?"/<property xil_pn:name="Implementation Top File" xil_pn:value="$edifFileSpec"/ig;
  }
                                                           # replace UCF binding
  if ($line =~ m/\.ucf"/i) {
    $line =~ s/<binding\s+(.+)\s+xil_pn\:name=.*?".+?"/<binding $1 xil_pn:name="$ucfFileSpec"/ig;
  }
  
  print tempFile ("$line\n");
}

close(tempFile);
close(ISEFile);

#-------------------------------------------------------------------------------
# delete original file and rename temporary file
#
unlink($iseFileSpec);
rename($tempFileSpec, $iseFileSpec);

if ($verbose == 1) {
  print "$separator\n";
}
