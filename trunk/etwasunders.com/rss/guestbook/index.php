<?php
	require("../xml_writer_class.php");
	require("../rss_writer_class.php");
	require("../../amfphp/services/Guestbook.php");

	$rss_writer_object = new rss_writer_class();
	$rss_writer_object->specification = "2.0";
	$rss_writer_object->inputencoding = "utf-8";
	$rss_writer_object->about = "http://etwasunders.com/rss/guestbook";
	
	$properties = array();
	$properties["description"] = "Latest guestbook comments of our band - etwasunders.com";
	$properties["link"] = "http://etwasunders.com/#guestbook";
	$properties["title"] = "Etwas Unders - Guestbook comments";
	$rss_writer_object->addchannel($properties);
	
	$guestbook = new Guestbook();
	$items = $guestbook->getEntries(0, 30, true);
	foreach ($items->frame as $item) {
	 	$properties = array();
	 	$properties["guid"] = "http://etwasunders.com/#guestbook/" . $item->id;
	 	$properties["pubDate"] = date("r", $item->timestamp);
	 	$properties["author"] = $item->user;
		$properties["description"] = $item->text;
		$properties["link"] = "http://etwasunders.com/#guestbook";
		$properties["title"] = "Comment (" . $item->date . ")";
		$rss_writer_object->additem($properties);
	}
	
	if ($rss_writer_object->writerss($output)) {
		Header("Content-Type: text/xml; charset='" . $rss_writer_object->outputencoding . "'");
		Header("Content-Length: " . strval(strlen($output)));
		echo $output;
	} else {
		Header("Content-Type: text/plain");
		echo ("Error: " . $rss_writer_object->error);
	}
	
?>