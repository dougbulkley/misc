#!/usr/bin/perl
chomp (@ARGV);
open (OUTFILE, ">mass_users.xml");
print OUTFILE <<TOP;
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE Waveset PUBLIC 'waveset.dtd' 'waveset.dtd'>
<Waveset>
TOP

for ($i=0; $i < @ARGV[0]; $i++) {
   print OUTFILE " <User name=\'tuser${i}\' password=\'VhXrkGkfDKw=\'\>\n";
   print OUTFILE <<CONTINUE;
   <MemberObjectGroups>
    <ObjectRef type='ObjectGroup' name='LotOfUsers'/>
  </MemberObjectGroups>
 </User>
CONTINUE
}

print OUTFILE "</Waveset\>\n";
close (OUTFILE);
