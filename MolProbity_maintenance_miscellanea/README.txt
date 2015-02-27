The purpose of this document is to collect MolProbity maintenance miscellanea.

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

If a job is running more than an hour, it's probably hung, and can be killed.  Find the job 

ps auxr | head

[[NOTE: try to find a hung job example to paste in here]]

14:25:25 molprobity /private/var/tmp> ps auxr | head -n6
USER             PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
root             139   0.1  0.3  2560264  24724   ??  S    29Jan15  57:21.80 /usr/bin/ruby /Applications/Server.app/Contents/ServerRoot/usr/libexec/webdavsharing/webdavsharing_mapper
root            7932   0.0  0.0  2433048    688 s002  R+    2:25PM   0:00.00 ps auxr
sml58           7931   0.0  0.0  2432748    536 s000  S+    2:25PM   0:00.00 sleep 10
_www            7098   0.0  0.1  2527144   8124   ??  S     2:22PM   0:00.09 /usr/sbin/httpd -D FOREGROUND -f /Library/Server/Web/Config/apache2/httpd_server_app.conf -D WEBSERVICE_ON
_www            7055   0.0  0.1  2564008   7624   ??  S     2:21PM   0:00.22 /usr/sbin/httpd -D FOREGROUND -f /Library/Server/Web/Config/apache2/httpd_server_app.conf -D WEBSERVICE_ON

If a job has 99%+ in the “CPU” column and started more than a few hours ago / has many hours racked in the time column, and looks like a MolProbity server process (not a system process [is one of our scripts...]), then look at that PID column, and type:

sudo kill [PID]

You need root access, obviously.  

Killing stuck jobs will free up a processor (there are 8 on MolProbity) and occasionally free up stuck disk space.


