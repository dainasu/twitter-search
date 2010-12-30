<?php
require_once 'tool.php';
class tbot extends tool
{
	function main($search)
	{
		$word = mysql_real_escape_string($search);
		$time = strtotime(date('Y-m-d H:i:s'));
		$sql = "SELECT * FROM search_log WHERE word = '{$word}'";
		$result = mysql_query($sql);
		if($result)
		{
			$row = mysql_fetch_assoc($result);
			$for_time =  $time - @$row['update_date'];
			if($for_time < $this->cache_time)
			{
				// ディレイ一分
				echo "cache " . $search . " = " . $for_time . "\n";
			}
			else
			{
				$this->twitter_search($search);
			}
		}
		else
		{
			echo "SELECT ERROR";
		}
	}

	function twitter_search($search)
	{
		$word = $search;
		$i_word    = mysql_real_escape_string($word);
		$time = strtotime(date('Y-m-d H:i:s'));
		$arr_twit = array();
		$arr_twit['next_page'] = '?page=1&rpp=100&q=' . urlencode(htmlspecialchars($word));
		$update_flag = false;

		while(1)
		{
			if(!$next = @$arr_twit['next_page'])
			{
				break;
			}
			$url = 'http://search.twitter.com/search.json' . $next;
			echo $url . "\n";
			$request = &new HTTP_Request();
			$request->setURL($url);
			#$request->addHeader('User-Agent' , 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)');
			$request->sendRequest();
			$code = $request->getResponseCode();
			if($code != 200)
			{	
				echo "\nerror : word=" . $word . ":code=" .$code ."\n";
				break;
			}
			$body = $request->getResponseBody();
			$json = json_decode($body);
			$arr_twit = $this->obj2arr($json);
			if(@$arr_twit['error'])
			{
				throw new Exception($arr_twit['error']);
				exit;
			}
			if(@$arr_twit['warning'])
			{
				throw new Exception($arr_twit['warning']);
				exit;
			}
			$dup = 0;
			foreach($arr_twit['results'] as $twit)
			{
				$i_user_id = mysql_real_escape_string(@$twit['from_user_id_str']);
				$i_image   = mysql_real_escape_string(@$twit['profile_image_url']);
				$i_user    = mysql_real_escape_string(@$twit['from_user']);
				$i_text    = mysql_real_escape_string(@$twit['text']);
				$i_lang    = mysql_real_escape_string(@$twit['iso_language_code']);
				$i_time    = strtotime($twit['created_at']);
				$sql = "SELECT 1 AS flag FROM time_line WHERE user_id = '{$i_user_id}' AND time = '{$i_time}'";
				$result = mysql_query($sql);
				$row = mysql_fetch_assoc($result);
				$dup = @$row['flag'] ? $dup + 1 : 0;
				if($dup > 10)
				{
					// 10回重複したら探査済みデータと判定
					$arr_twit['next_page'] = "";
					echo "\nbreak\n";
					break;
				}

				$sql =<<<_EOD_
INSERT INTO time_line 
(
    user_id
  , image
  , user
  , text
  , language
  , time
) 
VALUES 
(
     '{$i_user_id}'
  ,  '{$i_image}'
  ,  '{$i_user}'
  ,  '{$i_text}'
  ,  '{$i_lang}'
  ,  '{$i_time}'
)
_EOD_;
				mysql_query($sql);
				$update_flag = true;
			}
		}
		if($update_flag == true)
		{
			$sql = "REPLACE INTO search_log (word , update_date) VALUES ('{$i_word}' , {$time})";
			mysql_query($sql);
			echo "update = " . $word . "\n";
		}
	}

	function run()
	{
		$sql = "SELECT * FROM check_word";
		$result = mysql_query($sql);
		if($result)
		{
			while($row = mysql_fetch_assoc($result))
			{
				$this->main($row['word']);
			}
		}
		// API 制限ログ
		$url = "http://api.twitter.com/1/account/rate_limit_status.json";
		$request = &new HTTP_Request();
		$request->setURL($url);
		$request->addHeader('User-Agent' , 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)');
		$request->sendRequest();
		$body = $request->getResponseBody();
		$json = $this->obj2arr(json_decode($body));
		print_r($json);
	}

}
$index = new tbot();
$index->run();
?>
