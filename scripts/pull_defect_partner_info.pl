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

# Load module for database interaction
use DBI qw(:sql_types);

# Load posix module for strftime function
use POSIX qw (strftime);

# Load mail related modules for mailing attachment
use MIME::Parser;
use Mail::Send;

# Get current time and date for html filename 
$datestamp = strftime "%b_%e_%H%M%S_%Y", localtime;

# Create html output file name
$attachmentname = "PartnerDefectReport_$datestamp.html";
$htmlfile = ">PartnerDefectReport_$datestamp.html";

# Setup necessary mail information
$entity = MIME::Entity->build (
    To         => 'idm-defect-reports@sharespace.sun.com',
    Data       => "",
    'X-Mailer' => 'My X-Mailer',
    );

# Open the htmlfile for writing
open (HTMLFILE, $htmlfile) || die ("ERROR: Can't open \"$htmlfile\"");

# Force a buffer flush after every write and print
$| = 1;

# Create html header
print HTMLFILE "<html>
<head>
<title>Partner Defect Summary Report - $datestamp</title>
</head>
<body bgcolor=\"EAE8DB\">\n\n";

# Start creation of table to hold results
print HTMLFILE "<table border=\"1\" width=\"100%\">
<tr>
<td><strong>DEFECT</strong></td>
<td><strong>DESCRIPTION</strong></td>
<td><strong>STATUS</strong></td>
<td><strong>TARGET RELEASE</strong></td>
</tr>";
 
# Connect to the database
my $dbh = DBI->connect('DBI:mysql:host=fiji;database=bugs',
                       'buginfo',
                       'buginfo',
                      ) || print STDERR "<fond color=red>Bugzilla db connection failure</font>";

my $sql = qq{SELECT  bug_status, target_milestone, short_desc, bug_id
             FROM bugs WHERE bug_status = "NEW" OR bug_status = "ASSIGNED"};

my $sth = $dbh->prepare($sql);

$sth->execute();

my ($status, $target, $summary, $bugid);

$sth->bind_columns(undef, \$status, \$target, \$summary, \$bugid);

while ($sth->fetch()) {

    $summary =~ s/([<>])/\\/g;

    if ($summary =~ m/^eng:/i) {
    }
    else {
        print HTMLFILE "<tr>
        <td>$bugid</td><td>$summary</td><td>$status</td><td>$target</td>
        </tr>";
    }
}

$sth->finish();

$dbh->disconnect();

# Generate html code to close testcase results table and html document
print HTMLFILE "</table>
</body>
</html>";

close (HTMLFILE);

# Add attachment to mail
$entity->attach(Path      =>   $attachmentname,
                Type      =>   "text/plain",
                Encoding  =>   "quoted-printable");

# Send email with attachment
$sender = new Mail::Send;
foreach ($entity->head->tags) {
    $sender->set($_, map {chomp $_; $_} $entity->head->get($_));
}
$fh = $sender->open('sendmail');
$entity->print_body($fh);
$fh->close;

# Bye
exit(0);
