<?php

	require_once(dirname(__FILE__) . "/../../../../../../adodb_lite/adodb.inc.php");
	require_once(dirname(__FILE__) . "/../../../../Settings.php");
	
	class ServiceBase {
		
		protected $cn;
		
		function ServiceBase() {
			$this->cn = ADONewConnection(Settings::$DSN);
			$this->cn->Execute("SET NAMES 'utf8'");
		}
		
		protected function getNull($value) {
			if ($value == "") {
				return NULL;
			} else {
				return $value;
			}
		}
		
		protected function clearString($str) {
			$str = str_replace(array('<', '>'), array('&lt;', '&gt;'), $str);
			return $str;
		}
		
		protected function processText($id, $text, $dirty, $utf8Index) {
			$result = "";
			if ($id < $utf8Index) {
				$result = stripslashes(iconv("WINDOWS-1251", "UTF-8", $text));
			} else {
				$result = stripslashes($text);
			}
			
			if (!$dirty) {
				$result = $this->processHTML($result);
			}
			
			return $result;
		}
		
		protected function processHTML($text) {
			$result = str_replace(array("<br>", "<br />", "<br/>", "<b>", "</b>", "<center>", "</center>"), 
				array("", "", "", "", "", "", ""), $text);
			if (eregi('<img src="([a-z0-9:/_.]*)".*>', $result, $regs)) {
				$url = $regs[1];
				if (stripos($url, "http") === false) {
					$url = "http://etwasunders.com/" . $url;
				}
				$result = ereg_replace('<img src="[a-z0-9:/_.]*".*>', '<a href="' . $url . '">[image]</a>', $result);
			}
			$result = ereg_replace("<a(.*)>(.*)</a>",
				"<a\\1><u><font color='#971206'>\\2</font></u></a>", $result);
	
			return $result;
		}
		
	}
	
?>