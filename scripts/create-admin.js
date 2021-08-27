//
// Lighthouse script to create an administrator
//

function usage() {
    print("create-admin [options] <adminname>");
    print("options:");
    print("  -v                        Verbose mode (default false)");
    print("  -p password               Password for new admin");
    print("  -e email                  Email address for new admin");
    print("  -o orgname                Organization new admin object lives in");
    print("  -c \"org1,org2,org 3\"      Organization(s) new admin manages");
    print("  -r \"cap1,cap2,org 3\"      Capability(s) of new admin");
    print("  -f admin       (optional) Admin to forward approvals to. Default is None");
    print("  -u userform    (optional) Name of form used by new admin");
    quit();
}

var user = "Configurator";
var pass = "configurator";
var verbose = false;
var userform = "";
var org = "";
var corgs = new java.util.ArrayList;
var admin = "";
var adminpass = "";
var email = "";
var cap = new java.util.ArrayList;
var forwardadmin = "None";

if (arguments.length < 11) 
  usage();
for (var i = 0 ; i < arguments.length ; i++) {
  var arg = arguments[i];
  if (arg == "-v")
    verbose = true;
  else if (arg == "-p") {
    i++;
    if (i < arguments.length)
      adminpass = arguments[i];
    else
      usage();
  }
  else if (arg == "-e") {
    i++;
    if (i < arguments.length)
      email = arguments[i];
    else
      usage();
  }
  else if (arg == "-o") {
    i++;
    if (i < arguments.length)
      org = arguments[i];
    else
      usage();
  }
  else if (arg == "-c") {
    i++;
    if (i < arguments.length) {
      var tmp_array = arguments[i].split(",");
      var idx = 0;
      while (idx < tmp_array.length) {
        corgs.add (tmp_array[idx]);
        idx++;
      }
    }
    else
      usage();
  }
  else if (arg == "-r") {
    i++;
    if (i < arguments.length) {
      var tmp_array = arguments[i].split(",");
      var idx = 0;
      while (idx < tmp_array.length) {
        cap.add (tmp_array[idx]);
	idx++;
      }
    }
    else
      usage();
  }
  else if (arg == "-f") {
    i++;
    if (i < arguments.length)
      forwardadmin = arguments[i];
    else
      usage();      
  }
  else if (arg == "-u") {
    i++;
    if (i < arguments.length)
      userform = arguments[i];
    else
      usage();
  }
  else if (admin == "") {
    admin = arg;
  }
  else
    usage();
}

if (admin == null)
  usage();

if (verbose)
  print("Creating new administrator");

importPackage(Packages.com.waveset.object);
importPackage(Packages.com.waveset.security.authn);
importPackage(Packages.com.waveset.session);
importPackage(Packages.com.waveset.util);

if (verbose)
    print("Logging in...");

var epass = new EncryptedData(pass);
var session = SessionFactory.getSession(user, epass);

if (verbose)
    print("Waveset session established");

var eAPass = new EncryptedData(adminpass);

if (verbose)
    print("admin= "+admin);
    print("email= "+email);
    print("passwd= "+adminpass); 
    print("org= "+org);
    print("controlorgs= "+corgs); 
    print("capabilities= "+cap); 
    print("forwardTo= "+forwardadmin);
    print("userform= "+userform);

AdminUtil.create_admin(session,admin,eAPass,email,org,corgs,cap,forwardadmin,userform);

quit();
