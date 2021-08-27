#!/usr/bin/perl
# Obtain bug information for use in Support Wizard callc enter
# exit 0 upon success
# exit 1 if defect number wasn't submitted to this program
# exit 2 if defect info was not found
# exit 3 if connection to database failed

use strict;
use DBI qw(:sql_types);

my $bug_num=$ARGV[0];

my $user=$ARGV[1];

my $pass=$ARGV[2];

if ($bug_num eq "") {
     print "\nUsage: find_bug.pl \"bug number to search for\"\n";
     exit(1);
}

my $dbh = DBI->connect('DBI:mysql:host=fiji;database=bugs',
                       $user,
                       $pass,
                      ) || exit(3);

# Start get bug information
my $sql = qq{SELECT rep_platform, op_sys, component, version, bug_status,
             priority, resolution, bug_severity, target_milestone,
             assigned_to, short_desc FROM bugs WHERE bug_id = ?};

my $sth = $dbh->prepare($sql);

$sth->bind_param(1, $bug_num, SQL_VARCHAR);

$sth->execute();

my ($platform, $os, $comp, $ver, $status, $pri, $res, $sev, $target,
    $assigned, $summary);
$sth->bind_columns(undef, \$platform, \$os, \$comp, \$ver, \$status,
                   \$pri, \$res, \$sev, \$target, \$assigned, \$summary);

while ($sth->fetch()) {

# Check to see if defect number was valid
# Could also have had a database problem
if (($summary eq "") || ($comp eq "")) {
     exit (2);
}

     print "DEFECT#: $bug_num
OS: $os
PLATFORM: $platform
COMPONENT: $comp
VERSION: $ver
STATUS: $status
PRIORITY: $pri
RESOLUTION: $res
SEVERITY: $sev
TARGET: $target
ASSIGNED TO: $assigned
SUMMARY: \"$summary\"";
}

$sth->finish();
# End get bug information


# Start get bug description
my $sql = qq{SELECT thetext FROM longdescs WHERE bug_id = ?};

my $sth = $dbh->prepare($sql);

$sth->bind_param(1, $bug_num, SQL_VARCHAR);

$sth->execute();

my ($description);
$sth->bind_columns(undef, \$description);

print "\n\nDESCRIPTION:\n";

while ($sth->fetch()) {
     print "$description\n";
}

$sth->finish();
# End get bug description


$dbh->disconnect();

exit (0);
