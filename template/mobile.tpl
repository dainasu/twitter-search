<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja" dir="ltr">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>twitter 検索収集</title>
		<meta http-equiv="Content-Style-type" content="text/css" />
		<meta http-equiv="content-script-type" content="text/javascript">
		<meta name="keywords" content="twitter,検索,収集" />
		<meta name="description" content="twitter上のツイートを特定のキーワードで5分おきに収集、蓄積していきます。" />
		<meta name="viewport" content="width=device-width; initial-scale=1.0;">
		<link rel="stylesheet" href="css/mobile.css" type="text/css" />
		<link rel="shortcut icon" href="favicon.ico">
	</head>
	<body>
<{php}>
$GLOBALS['google']['client']='ca-mb-pub-6287779710840631';
$GLOBALS['google']['https']=read_global('HTTPS');
$GLOBALS['google']['ip']=read_global('REMOTE_ADDR');
$GLOBALS['google']['markup']='xhtml';
$GLOBALS['google']['output']='xhtml';
$GLOBALS['google']['ref']=read_global('HTTP_REFERER');
$GLOBALS['google']['slotname']='1389668402';
$GLOBALS['google']['url']=read_global('HTTP_HOST') . read_global('REQUEST_URI');
$GLOBALS['google']['useragent']=read_global('HTTP_USER_AGENT');
$google_dt = time();
google_set_screen_res();
google_set_muid();
google_set_via_and_accept();
function read_global($var) {
  return isset($_SERVER[$var]) ? $_SERVER[$var]: '';
}

function google_append_url(&$url, $param, $value) {
  $url .= '&' . $param . '=' . urlencode($value);
}

function google_append_globals(&$url, $param) {
  google_append_url($url, $param, $GLOBALS['google'][$param]);
}

function google_append_color(&$url, $param) {
  global $google_dt;
  $color_array = split(',', $GLOBALS['google'][$param]);
  google_append_url($url, $param,
                    $color_array[$google_dt % sizeof($color_array)]);
}

function google_set_screen_res() {
  $screen_res = read_global('HTTP_UA_PIXELS');
  if ($screen_res == '') {
    $screen_res = read_global('HTTP_X_UP_DEVCAP_SCREENPIXELS');
  }
  if ($screen_res == '') {
    $screen_res = read_global('HTTP_X_JPHONE_DISPLAY');
  }
  $res_array = split('[x,*]', $screen_res);
  if (sizeof($res_array) == 2) {
    $GLOBALS['google']['u_w']=$res_array[0];
    $GLOBALS['google']['u_h']=$res_array[1];
  }
}

function google_set_muid() {
  $muid = read_global('HTTP_X_DCMGUID');
  if ($muid != '') {
    $GLOBALS['google']['muid']=$muid;
     return;
  }
  $muid = read_global('HTTP_X_UP_SUBNO');
  if ($muid != '') {
    $GLOBALS['google']['muid']=$muid;
     return;
  }
  $muid = read_global('HTTP_X_JPHONE_UID');
  if ($muid != '') {
    $GLOBALS['google']['muid']=$muid;
     return;
  }
  $muid = read_global('HTTP_X_EM_UID');
  if ($muid != '') {
    $GLOBALS['google']['muid']=$muid;
     return;
  }
}

function google_set_via_and_accept() {
  $ua = read_global('HTTP_USER_AGENT');
  if ($ua == '') {
    $GLOBALS['google']['via']=read_global('HTTP_VIA');
    $GLOBALS['google']['accept']=read_global('HTTP_ACCEPT');
  }
}

function google_get_ad_url() {
  $google_ad_url = 'http://pagead2.googlesyndication.com/pagead/ads?';
  google_append_url($google_ad_url, 'dt',
                    round(1000 * array_sum(explode(' ', microtime()))));
  foreach ($GLOBALS['google'] as $param => $value) {
    if (strpos($param, 'color_') === 0) {
      google_append_color($google_ad_url, $param);
    } else if (strpos($param, 'url') === 0) {
      $google_scheme = ($GLOBALS['google']['https'] == 'on')
          ? 'https://' : 'http://';
      google_append_url($google_ad_url, $param,
                        $google_scheme . $GLOBALS['google'][$param]);
    } else {
      google_append_globals($google_ad_url, $param);
    }
  }
  return $google_ad_url;
}

$google_ad_handle = @fopen(google_get_ad_url(), 'r');
if ($google_ad_handle) {
  while (!feof($google_ad_handle)) {
    echo fread($google_ad_handle, 8192);
  }
  fclose($google_ad_handle);
}
<{/php}>
		<form action="<{$SCRIPT_NAME}>" method="get" id="main_form">
			<div class="header">
				<div class="title_logo">
					<a href="/"><img src="/images/logo.png" width="100%" alt="Twitter検索収集" title="HOME" /></a>
				</div>
				<div>キーワード</div>
				<div> 
					<select name="word" id="select_word" >
	<{foreach from=$word_list item=val}>
						<option value="<{$val|escape}>" <{if $val eq $smarty.get.word}>selected="selected"<{/if}>><{$val|escape}></option>
	<{/foreach}>
					</select>
				</div>
				<div>Language</div>
				<div>
					<select name="lang" id="select_lang" >
	<{foreach from=$lang_list item=val}>
						<option value="<{$val|escape}>" <{if $val eq $smarty.get.lang}>selected="selected"<{/if}>><{$arr_lang[$val]|escape}></option>
	<{/foreach}>
					</select>
				</div>
				<div>並び順</div>
				<div>
					<select name="order" id="order">
						<option value="">古い順</option>
						<option value="DESC" <{if $smarty.get.order eq "DESC"}>selected="selected"<{/if}>>新しい順</option>
					</select><br />
				</div>
				<input type="submit" id="search_btn" value=" 変更 " />
			</div>
			<div class="main">
				<div style="display:block;margin:20px 0 0 0;"><{$num|number_format|escape}>ツイート中<{$smarty.get.page+1|escape}>ページ目</div>
				<div>
					<input type="text" name="page_jump" value="" size="5" maxlength="12" format="12N" istyle="4" mode="numeric" />ページへ
					<input type="submit" id="search_btn" value=" 移動 " />
				</div>
<{*//  ページャー *}>
<{if $smarty.get.page eq 0}>
				最初へ&nbsp;前へ
<{else}>
				<a href="<{$SCRIPT_NAME}>?page=0&<{$pager}>">最初へ</a>&nbsp;
				<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page-1}>&<{$pager}>">前へ</a>
<{/if}>
<{if $smarty.get.page eq $page_count-1}>
				&nbsp;次へ&nbsp;最後へ
<{else}>
				&nbsp;<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page+1}>&<{$pager}>">次へ</a>&nbsp;
				<a href="<{$SCRIPT_NAME}>?page=<{$page_count-1}>&<{$pager}>">最後へ</a>
<{/if}>
<{*  ページャー //*}>
<{if $num > 0}>
<{foreach from=$time_line key=key item=val}>
				<div class="line_<{$key%2}>" >
					<div class="user_name">
						<img width="32" height="32" src="<{$val.image}>" class="user_icon" />
						<a href="http://twitter.com/<{$val.user|escape}>" target="_blank"><{$val.user|escape}></a>
					</div>
					<div class="text">
						<{$val.text}>
					</div>
					<div class="date">
						<{$val.date|escape}>
					</div>
				</div>
<{/foreach}>
<{*//  ページャー *}>
<{if $smarty.get.page eq 0}>
				最初へ&nbsp;前へ
<{else}>
				<a href="<{$SCRIPT_NAME}>?page=0&<{$pager}>">最初へ</a>&nbsp;
				<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page-1}>&<{$pager}>">前へ</a>
<{/if}>
<{if $smarty.get.page eq $page_count-1}>
				&nbsp;次へ&nbsp;最後へ
<{else}>
				&nbsp;<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page+1}>&<{$pager}>">次へ</a>&nbsp;
				<a href="<{$SCRIPT_NAME}>?page=<{$page_count-1}>&<{$pager}>">最後へ</a>
<{/if}>
<{*  ページャー //*}>
<{/if}>
<{foreach from=$word_list item=val}>
				<a class="hidden_option" href="<{$SCRIPT_NAME}>?word=<{$val|escape:url}>&lang=all"><{$val|escape:escape}></a>
<{/foreach}>
				<div class="search">
					<div class="search_header">検索ワード</div> 
					<div class="search_input" >
						<input type="text" value="<{$smarty.get.search_text|escape}>" name="search_text" style="width:120px;" />
					</div>
					<div class="search_header">ユーザー</div>
					<div class="search_input" >
						<input type="text" value="<{$smarty.get.search_user|escape}>"  name="search_user" style="width:120px;" />
					</div>
					<br />
					<div class="search_header">
						From 日付 (例：2010/1/1)
					</div>
					<div class="search_input" >
						<input name="from_date_day" type="text" id="from_date_day" size="15" value="<{$smarty.get.from_date_day|escape}>"/>
					</div>
					<div class="search_header">
						From 時間 (例：10:00)
					</div>
					<div class="search_input" >
						<input name="from_date_time" type="text" id="from_date_time" size="15" value="<{$smarty.get.from_date_time|escape}>"/>
					</div>
					<div class="search_header">To 日付</div>
					<div class="search_input" >
						<input name="to_date_day" type="text" id="to_date_day" size="15" value="<{$smarty.get.to_date_day|escape}>" />
					</div>
					<div class="search_header">To 時間</div>
					<div class="search_input" >
						<input name="to_date_time" type="text" id="to_date_time" size="15" value="<{$smarty.get.to_date_time|escape}>" />
					</div>
					<input type="submit" id="search_btn" value=" 検索 " />
				</div>
				<div class="mail"><a href="mailto:wind-moon@ezweb.ne.jp?subject=%e5%95%8f%e3%81%84%e5%90%88%e3%82%8f%e3%81%9b">管理人にメール</a></div>
			</div>
			<div class="adv">
			</div>
		</form>
	</body>
</html>
