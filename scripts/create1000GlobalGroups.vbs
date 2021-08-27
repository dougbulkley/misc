Set objRootDSE = GetObject("LDAP://rootDSE")
Set objOU = GetObject("LDAP://ou=DougTest2,ou=SupportAccounts," & _
                             objRootDSE.Get("defaultNamingContext"))
For i = 1 To 100
    Set objGroup = objOU.Create("Group", "cn=DougTest2Group" & i)
    objGroup.Put "sAMAccountName", "DougTest2Group" & i
    objGroup.Put "member", "CN=testuser88,OU=InternalAccounts,DC=support,DC=example,DC=com"
    objGroup.SetInfo
Next
WScript.Echo "100 Global Groups created."