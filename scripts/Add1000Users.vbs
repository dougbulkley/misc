Set objRootDSE = GetObject("LDAP://rootDSE")
Set objOU = GetObject("LDAP://ou=temp,ou=testUsers," & _
                             objRootDSE.Get("defaultNamingContext"))
For i = 1 To 1001
    Set objUser = objOU.Create("User", "cn=TestUser" & i)
    objUser.Put "sAMAccountName", "TestUser" & i
    objUser.Put "givenName", "Test"
    objUser.Put "sn", "User" & i
    objUser.Put "displayName", "Test User" & i
    objUser.Put "userPassword", "SuperSecretPassword1"
    objUser.Put "userAccountControl", "514"
    objUser.SetInfo
Next
WScript.Echo "1000 Users created."
