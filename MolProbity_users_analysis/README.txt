For the Feb. 2015 MolProbity grant renewal, Steven Lewis collated user statistics for the MolProbity website(s).  This document describes how those analyses were performed.

====MolProbity logs====

In a MolProbity install, there is a directory feedback (at the molprobity root directory).  (On the main server, /Library/WebServer/Documents/moltbx/feedback).  This directory contains:

1) Files of type email_v6RVmn, (last 6 is a hash), which are user bug/feedback emails
2) molprobity.log
3) user.log

I do not know from where these files are generated. It's probably not magic, but I haven't bothered looking either.

===molprobity.log===
This is a log of MolProbity actions, in the structural sense – files uploaded, users welcomed, analyses performed.  2057518 lines/actions as of this writing.

Lines look like this: 
128.210.75.192:et3ar9qi2p043jlaothinbbgq059nl7u:1425065222:aacgeom-rama:Doing Ramachandran analysis

I assume the columns are meant to be : delimited (colon delimited).

I assume the first column is an IPv4 IP address.

The second column appears to be molprobity session/job IDs (JIDs).  Recent log entries correlate with directories in the user data space (/Library/WebServer/Documents/moltbx/public_html/data or [molprobity]/public_html/data).  

The third column appears to be UNIX epoch timestamps.  Note: molprobity is thus sensitive to the 2038 problem (?).

The first three problems are rigorous and in all lines.

The fourth column appears to be a “message source” - this is the source of whatever the log file is about to report, in this case something called aac-rama (probably all atom contact geometry script, ramachandran anaylsis subunit).

All remaining columns are logging messages.

===user_paths.log===
I assume the first three columns are the same as molprobity.log.

Lines look like:

143.54.184.85:vrqossbp29v2bqbmj0gbts1lvqm18mnf:1425065943:job_progress.php

The last column appears to be pages served.  Most are job_progress.php.

===A note on data integrity===
The hardware has 8 processors, and is happily multithreaded.  There is one logfile.  This leads to resource conflicts where two separate processes write to the logfile at once.  This will garble the log files and lead to nonsense/broken/empty lines.

===Analyzing the data====
What do we want to know?  That determines how to analyze it.  These data can be interacted with either via awk/grep/sort/uniq/wc (in the shell), or maybe someone smarter could make a real database solution.  I'll show shell command lines, but learning the awk/grep etc toolset is beyond the scope of this document.

To get at the number of PDBs uploaded/fetched, grep for “pdb-fetch” or “pdb-upload”.  This returns whole lines, so you also have timestamps, IPs, and JIDs.  

grep "pdb-fetch" $logfile > $logfile.fetches
grep "pdb-upload" $logfile > $logfile.uploads

From these sublogs you can assemble data like “IP addresses that actually uploaded a file”, since that is our proxy for “user that did something”.

To get at “time slices”, only the parts of a log that occur in a certain time frame, use awk:

awk -F: '$3>1388552400' molprobity.log | awk -F: '$3<1420088400' | grep -e '^$' -v > molprobity.log.2014

Here  1388552400 and  1420088400 are the start and end of 2014 in POSIX time.  The -F: flag tells awk to delimit on :.  $3 is the third column.  The grep filters out empty lines.  This leaves us with the 2014 slice of the logfile.

To get at IP addresses:

awk -F: '{print $1}' $logfile | sort | uniq > $logfile.ips

Here, awk prints only the first column (the IP addresses).  sort and uniq get us a list of unique IP addresses.  Note that the two logfiles will have slightly different lists of IP addresses.  I assume this is due to the logfile garbling problem mentioned above.

Cmdlist is supplied for examples fo these commands.  I think you could just run the file to get a bunch of interesting data slices, but I suggest picking command lines out to run individually.

====Geocorrelating IP addresses====
I Googled until I found https://ipinfo.io/.  It has a sample script that suggests:

curl ipinfo.io/99.57.71.82:

15:13:11 somarriba ~/TERABYTE/rlab/mplogs/2014_both_didwork> curl ipinfo.io/99.57.71.82
{
  "ip": "99.57.71.82",
  "hostname": "99-57-71-82.lightspeed.livnmi.sbcglobal.net",
  "city": "Oxford",
  "region": "Michigan",
  "country": "US",
  "loc": "42.8382,-83.2004",
  "org": "AS7018 AT&T Services, Inc.",
  "postal": "48370"
}

So, this server has a simple command-line interaction that returns geolocation data.  I dumped all our interesting IP addresses into a file, prepended each IP with the “curl ipinfo.io/” bits, and ran the script piped to a file.

Processing this data is again mostly grep.  Grep for “region”, then sort/uniq, then manually process to get US states.  Grep for “country”, then sort/uniq, then interpret against a list of two-letter country codes (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements) to get a list of countries.
