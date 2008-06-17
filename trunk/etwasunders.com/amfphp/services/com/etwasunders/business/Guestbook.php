<?php

	require_once(dirname(__FILE__) . "/classes/ServiceBase.php");
	require_once(dirname(__FILE__) . "/../model/GuestbookVO.php");
	require_once(dirname(__FILE__) . "/../../../org/goverla/utils/common/FramedListResult.php");
	
	class Guestbook extends ServiceBase {
		
		function addComment($item) {
			if ($item["user"] != null && $item["text"] != null) {
				$timestamp = time();
				$values = array(
					"USER" => $this->GetNull($this->clearString($item["user"])),
					"EMAIL" => $this->GetNull($this->clearString($item["email"])),
					"TEXT" => $this->GetNull($this->clearString($item["text"])),
					"IP" => $_SERVER["REMOTE_ADDR"],
					"TIMESTAMP" => $timestamp
				);
				$this->cn->Execute("INSERT INTO guestbook VALUES (0, ?, ?, ?, ?, ?)", $values);
			}
		}
		
		function getEntries($position, $itemsCount, $dirty) {
			$result = new FramedListResult();
			$frame = array();
			$rst = $this->cn->Execute("SELECT * FROM guestbook ORDER BY TIMESTAMP DESC LIMIT $position, $itemsCount");
			while (!$rst->EOF) {
				$entry = new GuestbookVO();
				$entry->id = $rst->fields["ID"];
				$entry->user = $rst->fields["USER"];
				$entry->email = $rst->fields["EMAIL"];
				$entry->text = $this->processText($rst->fields["ID"], $rst->fields["TEXT"], $dirty, 814);
				$entry->date = date("d.m.Y H:i", $rst->fields["TIMESTAMP"]);
				$entry->timestamp = $rst->fields["TIMESTAMP"];
				$frame[] = $entry;
				$rst->MoveNext();
			}
			
			$rst = $this->cn->Execute("SELECT COUNT(*) FROM guestbook");
			$count = $rst->fields[0];
			
			$result->totalCount = $count;
			$result->frame = $frame;
			
			return $result;
		}
		
	}

?>