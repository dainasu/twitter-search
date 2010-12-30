<?php
require_once('base.php');
class config extends base
{
	var $db = null;


	function main()
	{
		if(@$_SESSION['is_login'] != "")
		{
			$word_list = array();
			$time = strtotime(date('Y-m-d H:i:s'));
			if(isset($_POST['is_submit']))
			{
				mysql_query("TRUNCATE check_word");
				foreach($_POST['word'] as $val)
				{
					$i_word = trim(strtoupper($val));
					if(!$i_word)
					{
						continue;
					}
					$i_word = mysql_real_escape_string($i_word);
					$sql = "INSERT IGNORE INTO check_word (word) VALUES ('{$i_word}')";
					mysql_query($sql);
				}
				// 更新処理
				header('location: ' . $this->file_name);
				exit;
			}
			$sql = "SELECT * FROM check_word";
			$result = mysql_query($sql);
			if($result)
			{
				while($row = mysql_fetch_assoc($result))
				{
					$word = mysql_real_escape_string($row['word']);
					$sql = "SELECT * FROM search_log WHERE word = '{$word}'";
					$req = mysql_query($sql);
					$time_row = mysql_fetch_assoc($req);
					$delay = 240 - ($time - @$time_row['update_date']);
					$word_list[] = array('word' => $row['word'], 'delay' => $delay);
				}
			}
			for($i = 0;$i < $this->max_word;$i++)
			{
				if(!isset($word_list[$i]))
				{
					$word_list[$i] = array('word' => '' , 'delay' => '');
				}
			}
			$_GET['word'] = @$_POST['word'] ? $_POST['word'] : @$_GET['word'];
			$_GET['word'] = $_GET['word'] ? $_GET['word'] : $word_list[0];
			$_GET['page'] = preg_match('/^[0-9]+$/' , @$_GET['page']) ? $_GET['page'] : 0;
			$this->smarty->assign('word_list' , $word_list);

			$this->smarty->display($this->template_name);
		}
		else
		{
			if(@$_POST['is_submit'] != "")
			{
				if((@$_POST['user_name'] == $this->user_name)&&(@$_POST['pass_word'] == $this->pass_word))
				{
					// ログイン成功
					$_SESSION['is_login'] = 'true';
					header("Location: " . $_SERVER['PHP_SELF']);
					exit;
				}
				else
				{
					$this->smarty->assign('err_mes' , "IDもしくはパスが違います。");
				}
			}
			$this->smarty->display('login.tpl');
		}
	} 

}
$index = new config();
$index->main();

?>
