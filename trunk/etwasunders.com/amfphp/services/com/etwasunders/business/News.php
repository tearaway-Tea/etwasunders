<?php

	require_once("classes/ServiceBase.php");
	require_once("../model/NewsVO.php");
	require_once("../../../org/goverla/utils/common/FramedListResult.php");
	
	class News extends ServiceBase {
		
		function addNews($item) {
			if ($item["user"] != null && $item["text"] != null) {
				$timestamp = time();
				$values = array(
					"USER" => $this->GetNull($this->clearString($item["user"])),
					"EMAIL" => $this->GetNull($this->clearString($item["email"])),
					"TEXT" => $this->GetNull($this->clearString($item["text"])),
					"IP" => $_SERVER["REMOTE_ADDR"],
					"TIMESTAMP" => $timestamp
				);
				$this->cn->Execute("INSERT INTO news VALUES (0, ?, ?, ?, ?, ?)", $values);
			}
		}
		
		function getEntries($position, $itemsCount, $dirty) {
			$result = new FramedListResult();
			$frame = array();
			$rst = $this->cn->Execute("SELECT * FROM news WHERE ISCONST = 0 AND ISNOTPUBLISH = 0 ORDER BY TIMESTAMP DESC LIMIT $position, $itemsCount");
			while (!$rst->EOF) {
				$entry = new NewsVO();
				$entry->id = $rst->fields["ID"];
				$entry->constant = $rst->fields["ISCONST"];
				$entry->notpublish = $rst->fields["ISNOTPUBLISH"];
				$entry->user = $rst->fields["USER"];
				$entry->text = $this->processText($rst->fields["ID"], $rst->fields["TEXT"], $dirty, 105);
				$entry->date = date("d.m.Y", $rst->fields["TIMESTAMP"]);
				$entry->timestamp = $rst->fields["TIMESTAMP"];
				$frame[] = $entry;
				$rst->MoveNext();
			}
			
			$rst = $this->cn->Execute("SELECT COUNT(*) FROM news WHERE ISCONST = 0 AND ISNOTPUBLISH = 0");
			$count = $rst->fields[0];
			
			$result->totalCount = $count;
			$result->frame = $frame;
			
			return $result;
		}
		
	}

?>
