Update:
-------
wordpresser is dead :( This was written for iOS 4, I was just playing with blocks and block syntax, and it doesn't play well with ARC anymore. I won't be fixing issues under this anymore. Sorry :(

I am working on something with Swift though, watch out for that.

wordpresser
===========

wordpresser is a "framework" project to build iOS apps on top of self-hosted WordPress blogs.

![Posts list](http://i.imgur.com/P3nlx.png "Posts list")

![Right-swipe menu](http://i.imgur.com/1QQ42.png "Right-swipe menu")

![Post viewer](http://i.imgur.com/WLL2q.png "Post viewer")

Features:
---------
* View latest posts from your blog
* Access the menu by just right-swiping
* Fully customizable
* Layout autoadjusts for iPods/iPhones/iPads
* Works on all orientations

Requirements:
-------------
* SELF-HOSTED Wordpress blog
* JSON API plugin for Wordpress [(http://wordpress.org/extend/plugins/json-api/)
](http://wordpress.org/extend/plugins/json-api/)
* XCode :)

Usage:
------
* Modify GSSettings.h constants to the values you want (blog title, link, etc)
* Modify GSMenuData.m's menuData mutable dictionary to contain a dictionary of the pages you want your menu to link to
* Customize Default.png
* Customize images in the "Images" folder
* Build and run

Dependencies:
--------
This project uses [JSONKit](https://github.com/johnezang/JSONKit), Copyright (c) 2011, John Engelhart. For the JSONKit license, refer to the sources in the JSONKit subdirectory.

License:
--------
    Copyright (c) 2012, Moises Anthony Aranas
 
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
 
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
    TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

