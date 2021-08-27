#!/usr/bin/perl

######################################################################
# Synopsis: After script to run when working with tickets
#
# 1) Checks to see if user entered a number in the defect number
#    field. If so, attempt to find this defect in bugzilla. If exists
#    fill in appropriate field information. If it does not exist,
#    notify user via STDERR message to ticket page upon save.
#
# 2) Checks to see if ticket is moving to closed state. If so, set the
#    actual closed date field.
######################################################################

use DBI qw(:sql_types);

######################################################################
# OBTAIN TICKET DATA
######################################################################
# The name of the currently logged in user
$user_name = $ENV{'SW_USER'};

# The name of the current product
$product_name = $ENV{'SW_PRODUCT'};

# The names of each of ticket field or, if the
# script is being run when users are 
# created/modified the names of each user field
$field_names = $ENV{'SW_FIELDS'};

#####################################################################
# Step 1
#####################################################################
# Check if admin wishes to incorportate current defect information
# in this ticket. We do this by checking for an entry in the 
# defect_number field of the ticket form.

chomp $ENV{defect_number};

if (($ENV{defect_number} ne "") && ($ENV{defect_number} ne "None")) {

    my $bug_num=$ENV{defect_number};
 
    # Connect to the database
    my $dbh = DBI->connect('DBI:mysql:host=fiji;database=bugs',
                           'buginfo',
                           'buginfo',
                          ) || print STDERR "<fond color=red>Bugzilla db connection failure</font>";

    my $sql = qq{SELECT component, version, bug_status,
                 priority, resolution, bug_severity, target_milestone,
                 short_desc FROM bugs WHERE bug_id = ?};

    my $sth = $dbh->prepare($sql);

    $sth->bind_param(1, $bug_num, SQL_VARCHAR);

    $sth->execute();

    my ($comp, $ver, $status, $pri, $res, $sev, $target, $summary);

    $sth->bind_columns(undef, \$comp, \$ver, \$status,
                       \$pri, \$res, \$sev, \$target, \$summary);

    $sth->fetch();

    # Check to see if defect number was valid
    # Could also have had a database problem
    # If component is blank we assume nothing was returned.
    if ($comp eq "") {
        print STDERR "<font color=red>It appears you have entered an invalid defect number, or the defect does not exist</font>";
        exit(1); 
    }

    $sth->finish();

    $dbh->disconnect();

    $tmp_history = "COMPONENT:" . $comp . ", VERSION:" . $ver . 
                   ", STATUS:" . $status . ", PRIORITY:" . $pri .
                   ", RESOLUTION:" . $res . ", SEVERITY:" . $sev .
                   ", TARGET:" . $target .
                   ", SUMMARY:" . "\"" . $summary . "\"";

    # We got good defect information. Process it
    print STDOUT "defect_history:\n\t$tmp_history\n";
}
else {
     print STDOUT "defect_history:\n\t\n";
}

exit(0);

