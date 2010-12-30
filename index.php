<?php

require_once('base.php');
class index extends base
{
	var $db = null;

	function main()
	{
		$sql = "SELECT * FROM check_word";
		$result = mysql_query($sql);
		$word_list = array("all");
		$my_page_num = $this->term_type == "pc" ? $this->page_sep : $this->mobile_sep;
		if($result)
		{
			while($row = mysql_fetch_assoc($result))
			{
				$arr_tmp = array();
				$tmp_word = explode(" OR ",$row["word"]);
				foreach($tmp_word as $tw)
				{
					$arr_tmp[] = trim(ltrim(trim($tw),'#'));
				}
				$arr_tmp = array_merge(array_unique($arr_tmp) );
				$word_list[] = implode(' OR ' , $arr_tmp);
			}
		}
		$_GET['order'] = isset($_GET['order']) ? $_GET['order'] : "DESC";
		$lang_list = array('all');
		$sql = "SELECT language FROM time_line WHERE language != '' GROUP BY language ORDER BY language";
		$result = mysql_query($sql);
		if($result)
		{
			while($row = mysql_fetch_assoc($result))
			{
				$lang_list[] = $row['language'];
			}
		}

		$_GET['word'] = isset($_GET['word']) ? $_GET['word'] : 'all';
		$_GET['lang'] = isset($_GET['lang']) ? $_GET['lang'] : 'all';

		$add_sql = "";
		$query_list = array();
		$pattern = array(
					'_'  => '\\_' ,
					'%'  => '\\%' ,
					'\\' => '\\\\' 
					);
		if(@$_GET['word'] != 'all')
		{
			$arr_word = array();
			$arr_tmp = array_unique(explode(' OR ', $_GET['word']));
			foreach($arr_tmp AS $val)
			{
				$arr_word[] = "text LIKE '%" . mysql_real_escape_string($val) . "%'";
			}
			$query_list[] = "(" . implode(' OR ' , $arr_word) . ")";
		}

		if(@$_GET['lang'] != 'all')
		{
			$lang = mysql_real_escape_string(@$_GET['lang']);
			$query_list[] = " language = '{$lang}' ";
		}

		if (@$_GET['search_text'] != "")
		{
			$arr_word = array();
			$arr_tmp = array_unique(explode(' ', $_GET['search_text']));
			foreach($arr_tmp AS $val)
			{
				$arr_word[] = "text LIKE '%" . mysql_real_escape_string($val) . "%'";
			}
			$query_list[] = "(" . implode(' AND ' , $arr_word) . ")";
			
		}
		if (@$_GET['search_user'] != "")
		{
			$q_text = mysql_real_escape_string($_GET['search_user']);
			$query_list[] = " user = '{$q_text}' ";
		}
		$from_date = "";
		$to_date   = "";
		$f_test = @$_GET['from_date_day'] ? $_GET['from_date_day'] . " " . @$_GET['from_date_time'] : "";
		$t_test = @$_GET['to_date_day']   ? @$_GET['to_date_day']   . " " . @$_GET['to_date_time']  : "";
		if(trim($f_test))
		{
			$from_date = strtotime($f_test) ? strtotime($f_test) : "";
		}
		if(trim($t_test))
		{
			$to_date   = strtotime($t_test) ? strtotime($t_test) : "";
		}
		if($from_date != "")
		{
			$query_list[] = " time >= {$from_date} ";
		}
		else
		{
			$_GET['from_date_day']  = "";
			$_GET['from_date_time'] = "";
		}
		if($to_date != "")
		{
			$query_list[] = " time <= {$to_date} ";
		}
		else
		{
			$_GET['to_date_day']  = "";
			$_GET['to_date_time'] = "";
		}
		$order = @$_GET['order'] == "DESC" ? "DESC" : "";

		$add_sql = implode(' AND ' ,$query_list);
		$add_sql = $add_sql ? " WHERE " . $add_sql : "";
		$list = array();

		// カウント クエリ実行
		$sql = "
            SELECT 
				COUNT(*) AS count
            FROM 
                time_line 
            {$add_sql} 
            ";
		$result = mysql_query($sql);
		$count_row = mysql_fetch_assoc($result);
		$num = $count_row['count'];
		$page_count = ceil($num / $my_page_num);
		$_GET['page'] = @$_GET['page_jump'] ? $_GET['page_jump'] - 1 : @$_GET['page'];
		unset($_GET['page_jump']);

		$_GET['page'] = preg_match('/^[0-9]+$/' , $_GET['page']) ? 
							($_GET['page'] > $page_count ? $page_count - 1 : $_GET['page']) : 0;
		$page = mysql_real_escape_string($_GET['page']) * $my_page_num;

		// データ取得 クエリ実行
		$sql = "
            SELECT 
                image ,
                user ,
                text ,
                time 
            FROM 
                time_line 
            {$add_sql} 
            ORDER BY 
                time {$order}
            LIMIT 
                {$page}, {$my_page_num}
            ";
		$result = mysql_query($sql);
		if($result)
		{
			while($row = mysql_fetch_assoc($result))
			{
				$row['date']    = date('Y-m-d H:i:s',$row['time']);
				$row['text']    = preg_replace('/(http:\/\/[\x21-\x7e]+)/i',"<a href='$1' target='_blank'>$1</a>",$row['text']);
				// ユーザーIDをリンクに
				$row['text']    = preg_replace_callback('/(<a [^>]+.[^<]+<\/a>)|@([_a-z0-9]+)/i', function ($match){
					return $match[1] ? $match[1] : "<a href='http://twitter.com/#!/{$match[2]}' target='_blank'>@" . $match[2] . "</a>";
				} ,$row['text']);
				// ハッシュタグをリンクに
				$row['text']    = preg_replace_callback('/(<a [^>]+.[^<]+<\/a>)|(#[a-z0-9]+)/i', function ($match){
					return $match[1] ? $match[1] : "<a href='http://twitter.com/search?q=" . urlencode($match[2]) . "'target='_blank'>" . $match[2] . "</a>";
				}, $row['text']);

				$list[] = $row;
			}
		}

		$word_split = explode('OR' , $_GET['word']);
		$tag = trim(array_shift($word_split));
		$tag = preg_replace('/^#/' , '' , $tag);
		$this->assignVal('word_list' , $word_list);
		$this->assignVal('tag' , $tag);
		$this->assignVal('time_line' , $list);
		$this->assignVal('num' , $num);
		$this->assignVal('page_count' , $page_count);
		$this->assignVal('sep_count' , ceil($page_count/$my_page_num));
		$this->assignVal('page_sep' , $my_page_num);
		$this->assignVal('lang_list' , $lang_list);
		if(preg_match('/android/i' , $this->ua))
		{
			$this->assignVal('is_android' , 'true');
		}
		$pager = array();
		foreach($_GET as $key => $get)
		{
			if($key == "page" || $get == "")
			{
				continue;
			}
			$pager[] = "{$key}=" . urlencode($get);
		}
		$this->assignVal('pager' , implode('&' , $pager));

		$link_from = $_GET['page'] - 5 < 1 ? 0 : $_GET['page'] - 4;
		$bonus = $_GET['page'] - 4 < 1 ? ($_GET['page'] - 4) * -1 : 0;
		$link_to   = $_GET['page'] + 5 + $bonus > $page_count ? $page_count : $_GET['page'] + 5 + $bonus;
		$this->assignVal('link_from' , $link_from);
		$this->assignVal('link_to'   , $link_to);
		$this->assignVal('twit_text'   , $this->twit_text);

		$template = "";
		if($this->term_type != "pc")
		{
			$template = "mobile.tpl";
		}
		else
		{
			$template = $this->template_name;
		}
		$this->smarty->display($template);
	}

}
$index = new index();
$index->main();

?>
