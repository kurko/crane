What?
====

Uplift is a Ruby gem for sending files through FTP without the hassle of clicking directory by directory
and sendind file by file. It gets the bore out of your path :-)

Why?
====

We have projects in servers that, for particular reasons, can't access Github or a git repo, so
Capistrano can't be used for deploying.

Most of them are small clients that demand basic designs, no
dynamic programming, usually on shared hosting. After tiny changes, HTML, CSS and image
files are sent via FTP. This is very boring.

How?
====

Uplift analyses files in the current directory by date. Let's say you type:

<pre>
	$ uplift push today
</pre>

Uplift will send all files changed *today* to the server. Automatically.

Better yet, try this:

<pre>
	$ uplift push 1h
</pre>

This will send all files modified in the last hour.

How to start
====

Get into your project root directory and type:

<pre>
	$ uplift init
</pre>

This will inquire you about FTP informations. This configuration will be saved in a file
called .uplift in the same folder.

License
====

MIT. Do whatever you want. Want a suggestion? Fork and collaborate.
