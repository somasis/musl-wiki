# Environment Variables

[[_TOC_]]

# PATH

Used by execvp, execlp, and posix_spawnp as specified in POSIX.

# TZ

Specifies the local timezone to be used for functions which deal with local
time. The value of TZ can be either a [POSIX timezone specification] in the form
stdoffset[dst[offset][,start[/time],end[/time]]] or the name of a
zoneinfo-binary-format timezone file (the form used by glibc and almost all
other systems). The zoneinfo file is interpreted as an absolute pathname if it
begins with a slash, a relative pathname if it begins with a dot, and otherwise
is searched in /usr/share/zoneinfo, /share/zoneinfo, and /etc/zoneinfo. When
searching these paths, strings including any dots are rejected.

[POSIX timezone specification]: http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_03

# DATEMSK

Used by the getdate function as a pathname for the file containing date formats
to scan, per POSIX.

# PWD

Used by the nonstandard get_current_dir_name function; if it matches the actual
current directory, it is returned instead of using getcwd to obtain the
canonical pathname.

# LOGNAME

The getlogin function simply returns the value of the LOGNAME variable.

# LD_PRELOAD

Colon-separated list of shared libraries that will be preloaded by the dynamic
linker before processing the application's dependency list. Components can be
absolute or relative pathnames or filenames in the default library search path.

This variable is completely ignored in programs invoked setuid, setgid, or with
other elevated capabilities.

# LD_LIBRARY_PATH

Colon-separated list of pathnames that will be searched for shared libraries
requested without an explicit pathname. This path is searched prior to the
default path (which is specified in $(syslibdir)/../etc.ld-musl-$(ARCH).path
with built-in default fallback if this file is missing).

This variable is completely ignored in programs invoked setuid, setgid, or with
other elevated capabilities.

