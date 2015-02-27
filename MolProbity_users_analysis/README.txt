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

The second column appears to be molprobity session IDs.  Recent log entries correlate with directories in the user data space (/Library/WebServer/Documents/moltbx/public_html/data or [molprobity]/public_html/data).  

The third column appears to be UNIX epoch timestamps.  Note: molprobity is thus sensitive to the 2038 problem (?).

The first three problems are rigorous and in all lines.

The fourth column appears to be a “message source” - this is the source of whatever the log file is about to report, in this case something called aac-rama (probably all atom contact geometry script, ramachandran anaylsis subunit).

All remaining columns are logging messages.

===user_paths.log===
I assume the first three columns are the same as molprobity.log.

Lines look like:

143.54.184.85:vrqossbp29v2bqbmj0gbts1lvqm18mnf:1425065943:job_progress.php

The last column appears to be pages served.  Most are job_progress.php.


