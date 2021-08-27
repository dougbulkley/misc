chomp (@ARGV);
open (OUTFILE, ">mass_org.xml");
print OUTFILE <<TOP;
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE Waveset PUBLIC 'waveset.dtd' 'waveset.dtd'>
<Waveset>
TOP

for ($i=0; $i < @ARGV[0]; $i++) {
   print OUTFILE " <ObjectGroup name=\'GE ORG ${i}\' displayName=\'GE ORG ${i}\'\>\n";
   print OUTFILE <<CONTINUE;
   <MemberObjectGroups>
    <ObjectRef type='ObjectGroup' name='LotsOfOrgs'/>
  </MemberObjectGroups>
 </ObjectGroup>
CONTINUE
}

print OUTFILE "</Waveset\>\n";
close (OUTFILE);
