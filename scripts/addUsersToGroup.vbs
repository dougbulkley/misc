Const ADS_PROPERTY_APPEND = 3
Set objRootDSE = GetObject("LDAP://rootDSE")
Set objGroup = GetObject("LDAP://cn=Group Z,ou=Groups," & _
                             objRootDSE.Get("defaultNamingContext"))
For i = 40001 To 60000
    strDN = "CN=TestUser" & i & ",OU=60KUsers,DC=support,DC=example,DC=com"
    objGroup.PutEx ADS_PROPERTY_APPEND, "member", Array(strDN)
    objGroup.SetInfo
Next
WScript.Echo "20k Users added to Global group."