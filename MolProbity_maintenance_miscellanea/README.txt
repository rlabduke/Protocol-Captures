The purpose of this document is to collect MolProbity maintenance miscellanea.  There are two major issues the server has: hung/stuck jobs, and disk use.  Disk use is often related to hung jobs for reasons I don't understand (infinite virtual memory?)

====Disk use====

Determine disk use / space remaining on a UNIX-compatible system (Macs, Linux) with:

df -h


For example: 

14:11:43 molprobity ~/> df -h
Filesystem      Size   Used  Avail Capacity  iused     ifree %iused  Mounted on
/dev/disk0s2   931Gi  210Gi  720Gi    23% 55240275 188740467   23%   /
devfs          184Ki  184Ki    0Bi   100%      636         0  100%   /dev
map -hosts       0Bi    0Bi    0Bi   100%        0         0  100%   /net
map auto_home    0Bi    0Bi    0Bi   100%        0         0  100%   /home

The latter three lines are irrelevant.  The first line is the main disk (notice its size is about a terabyte – it is the disk that matters.).  It's at 23%.

For the current (Feb 2015) hardware, the MolProbity server should sit at 23% disk use.  More than that, something is probably wrong.  (Creep to 24 or 25% is not an issue, but most of the time it will jump to 40% or more.)

===Causes of high disk use===

1) stuck jobs (see later section)
2) random huge PDBs (???) (see next section)

==/private/var/tmp==
There is a directory on the current server /private/var/tmp.  It seems to have fragments of user-uploaded PDBs.  Occasionally something goes wrong and it will have truly enormous files – once it had a 600 GB PDB on the 1 TB disk.  Just dump out crap from here as needed, I've only been sniping out individual huge files.  I assume these are from network errors during file upload.

====Stuck jobs====

There are a handful of places that MolProbity will hang – jobs will just sit at 100% processor doing nothing.  Usually either aac_geom.py or the upload script (name?) hang.  Don't ask me why.  Sometimes Reduce hangs too.

If a job is running more than an hour, it's probably hung, and can be killed.  Find the job with:

ps auxr | head

(timestamp note: Mon Mar 16 11:13:13 EDT 2015)
USER             PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
_www           62068  99.0  0.3  2469396  28476   ??  R     4:13PM 1137:31.83 php -f /Library/WebServer/Documents/moltbx/jobs/aacgeom.php tu5edi63hrl47b3t32hckr4n2ghl1rvp
_www           14631  97.6  0.2  2461444  19936   ??  S    11:12AM   0:01.43 php -f /Library/WebServer/Documents/moltbx/jobs/addmodel.php 48gbfpvo5jei7k6ecp23ke6a9bq73tci
root              49  72.1  5.3  4048328 447784   ??  Rs   29Jan15 6314:02.82 /System/Library/Frameworks/CoreServices.framework/Frameworks/Metadata.framework/Support/mds
_www           12005   1.1  0.5  2656936  40892   ??  S    11:02AM   0:02.05 /usr/sbin/httpd -D FOREGROUND -f /Library/Server/Web/Config/apache2/httpd_server_app.conf -D WEBSERVICE_ON
root              20   0.1  0.0  2599452   2180   ??  Ss   29Jan15  89:02.05 /usr/sbin/notifyd
root               1   0.1  0.0  2582488   4120   ??  Ss   29Jan15 233:20.77 /sbin/launchd
_www           14071   0.0  0.1  2559656   6936   ??  S    11:12AM   0:00.02 /usr/sbin/httpd -D FOREGROUND -f /Library/Server/Web/Config/apache2/httpd_server_app.conf -D WEBSERVICE_ON
_www           13912   0.0  0.1  2587560   7476   ??  S    11:12AM   0:00.12 /usr/sbin/httpd -D FOREGROUND -f /Library/Server/Web/Config/apache2/httpd_server_app.conf -D WEBSERVICE_ON
root           13900   0.0  0.0  2482672   2140   ??  Ss   11:12AM   0:00.01 /usr/libexec/taskgated -s

Look at the second job (14631).  It's a php job, says "moltbx/jobs/addmodel.php", with a molprobity job id hash.  Clearly a user job.  Started at 11:12, with a timestamp of 11:13 for the sample, this job is fine.  Note that addmodel.php is one of the scripts that hangs a lot.

Look at the third job (49).  Owned by root, started a month ago, running "/System.../CoreServices.framework...", it's probably important.  Leave it alone.

Look at the first job (62068).  It's a php job, aacgeom.py, molprobity job id present - one of the user jobs.  Started yesterday afternoon, accumulated 1137 minutes of clock time.  It's hung.  Kill it.

Basically, If a job has 99%+ in the “CPU” column and started more than a few hours ago / has many hours racked in the time column, and looks like a MolProbity server process (not a system process [is one of our scripts...]), then look at that PID column, and type:

sudo kill [PID]

You need root access, obviously.  

Killing stuck jobs will free up a processor (there are 8 on MolProbity) and occasionally free up stuck disk space.
