<?php
require_once 'tool.php';
class clean extends tool
{
	function main()
	{
		mysql_query("DELETE FROM search_log WHERE word BINARY NOT IN (SELECT word FROM check_word)");
		#mysql_query("DELETE FROM time_line WHERE BINARY word NOT IN (SELECT word FROM check_word)");
		mysql_query("OPTIMIZE TABLE search_log ");
		mysql_query("OPTIMIZE TABLE time_line ");
	}
}
$index = new clean();
$index->main();
?>
