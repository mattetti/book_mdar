# CocoaMySQL dump
# Version 0.7b5
# http://cocoamysql.sourceforge.net
#
# Host: localhost (MySQL 5.0.51-log)
# Database: golb
# Generation Time: 2008-04-18 17:34:56 +0100
# ************************************************************

# Dump of table comments
# ------------------------------------------------------------

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `body` text,
  `body_html` text,
  `post_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;



# Dump of table posts
# ------------------------------------------------------------

CREATE TABLE `posts` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `slug` varchar(225) default NULL,
  `body` text,
  `body_html` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;



