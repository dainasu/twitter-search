<?php
require_once 'HTTP/Request.php';
class tool
{
	var $cache_time = '240';
	var $db = null;
	var $w_db = null;

	function __construct()
	{
		$host = "localhost";
		$db   = "twitter_api";
		$user = "twitter_api";
		$pass = 'hjzqWVuFyRtNHvWz';
		$this->db = mysql_connect($host, $user , $pass);
		if(!$this->db || !mysql_select_db($db))
		{
			echo "DB Connect Error";
			exit;
		}
		mysql_query("SET NAMES utf8",$this->db);  
	}

	function __destruct()
	{
		@mysql_close($this->db); 
	}

	function obj2arr($obj)   
	{
		if(is_object($obj) || is_array($obj))
		{
			$arr = (array) $obj;

			foreach ( $arr as &$a )
			{
			   $a = $this->obj2arr($a);
			}
		}
		else
		{
			return $obj;
		}

		return $arr;
	} 
}
?>
