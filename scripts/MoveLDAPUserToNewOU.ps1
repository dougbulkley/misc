# Sample powershell script to move/rename an object in an LDAP directory.
# Tested with PingDirectory, an OpenLDAP based LDAP server.
# Written and tested on 9/14/2023

# Load the assemblies.
[System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols")
[System.Reflection.Assembly]::LoadWithPartialName("System.Net")

# Connects on the specified host:port
$c = New-Object System.DirectoryServices.Protocols.LdapConnection `
     "localhost:1389"

# Set session options
$c.SessionOptions.SecureSocketLayer = $false;
$c.SessionOptions.ProtocolVersion = 3

# Pick Authentication type:
# Anonymous, Basic, Digest, DPA (Distributed Password Authentication),
# External, Kerberos, Msn, Negotiate, Ntlm, Sicily
$c.AuthType = [System.DirectoryServices.Protocols.AuthType]::Basic

# Gets username and password.
$user = Read-Host -Prompt "Username"
$pass = Read-Host -AsSecureString "Password"
$credentials = new-object "System.Net.NetworkCredential" -ArgumentList $user,$pass

# Bind with the network credentials. Depending on the type of server,
# the username will take different forms. Authentication type is controlled
# above with the AuthType
$c.Bind($credentials);

# We are going to move this object (LDIF Below)
#
# dn: uid=user.1,ou=People,dc=example,dc=com
# uid: user.1
# .....

# The old DN is
# dn: uid=user.1,ou=People,dc=example,dc=com
# The New DN is
# dn: uid=user.1,ou=Contractors,dc=example,dc=com
$r = (new-object "System.DirectoryServices.Protocols.ModifyDNRequest")

# I had to use 1 instead of true or else the script failed for some reason.
$r.DeleteOldRdn = 1;

$r.DistinguishedName = "uid=user.1,ou=People,dc=example,dc=com";

# Change the name if you want to, or set it to be the same
$r.NewName = "uid=user.1";

# Set the new container
$r.NewParentDistinguishedName = "ou=Contractors,dc=example,dc=com";   

# Actually process the request through the server
$re = $c.SendRequest($r);
if ($re.ResultCode -ne [System.directoryServices.Protocols.ResultCode]::Success)
{
    write-host "Failed!"
    write-host ("ResultCode: " + $re.ResultCode)
    write-host ("Message: " + $re.ErrorMessage)
}
