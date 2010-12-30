<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja" dir="ltr">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>twitter 検索収集</title>
		<meta http-equiv="Content-Style-type" content="text/css" />
		<meta http-equiv="content-script-type" content="text/javascript">
		<meta name="keywords" content="twitter,検索,収集" />
		<meta name="description" content="twitter上のツイートを特定のキーワードで5分おきに収集、蓄積していきます。<{if $smarty.get.word ne 'all'}><{$smarty.get.word|escape}><{/if}>" />
		<meta name="viewport" content="width=device-width; initial-scale=1.0;">
		<link rel="stylesheet" href="css/default.css" type="text/css" />
		<link rel="stylesheet" href="css/contents.css" type="text/css" />
		<link rel="shortcut icon" href="favicon.ico">
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/link.js"></script>
<script type="text/javascript"><!--
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-19816266-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
//-->
</script>
	</head>
	<body>
		<div class="header">
			<div class="title_logo">
				<a href="/"><img src="/images/logo.png" alt="Twitter検索収集" title="HOME" /></a>
			</div>
			<form action="<{$SCRIPT_NAME}>" method="get" id="main_form">
			キーワード : 
			<select name="word" id="select_word" >
<{foreach from=$word_list item=val}>
				<option value="<{$val|escape}>" <{if $val eq $smarty.get.word}>selected="selected"<{/if}>><{$val|escape}></option>
<{/foreach}>
			</select>
			Language : 
			<select name="lang" id="select_lang" >
<{foreach from=$lang_list item=val}>
				<option value="<{$val|escape}>" <{if $val eq $smarty.get.lang}>selected="selected"<{/if}>><{$arr_lang[$val]|escape}></option>
<{/foreach}>
			</select>
			<div class="search">
				<table class="search_tbl">
					<tr>
						<th>検索ワード :</th> 
						<td>
							<input type="text" value="<{$smarty.get.search_text|escape}>" name="search_text" style="width:120px;" />
						</td>
						<th>ユーザー :</td>
						<td colspan="2">
							<input type="text" value="<{$smarty.get.search_user|escape}>"  name="search_user" style="width:120px;" />
						</td>
					</tr>
					<tr>
						<th>From 日付：</th>
						<td><input name="from_date_day" type="text" id="from_date_day" size="15" value="<{$smarty.get.from_date_day|escape}>"/></td>
						<th>To 日付：</th>
						<td><input name="to_date_day" type="text" id="to_date_day" size="15" value="<{$smarty.get.to_date_day|escape}>" /></td>
						<td colspan="3">例：日付 2010/1/1</td>
					</tr>
					<tr>
						<th>From 時間：</th>
						<td><input name="from_date_time" type="text" id="from_date_time" size="15" value="<{$smarty.get.from_date_time|escape}>"/></td>
						<th>To 時間：</th>
						<td><input name="to_date_time" type="text" id="to_date_time" size="15" value="<{$smarty.get.to_date_time|escape}>" /></td>
						<td colspan="3">例：時間 10:00</td>
					</tr>
				</table>
				<input type="submit" id="search_btn" value=" 検索 " />
			</div>
			<a href="http://twitter.com/home?status=<{$twit_text|escape:url}>" target="_blank">このサイトをtwitterでつぶやく</a>
		</div>
		<div class="main">
			<input type="button" value=" リロード " onclick="javascript:location.reload()" /><br />
			<div style="display:block;margin:20px 0 0 0;"><{$num|number_format|escape}>ツイート<br />
			<{$page_count}>ページ中 
			<input type="text" name="page_input" value="" maxlength="10" size="5" />ページへ
			<input type="hidden" name="page" id="page_hide" value=""  />
			<input type="submit" value="移動" />
			</div>
			<select name="order" id="order">
				<option value="ASK">古い順</option>
				<option value="DESC" <{if $smarty.get.order eq "DESC"}>selected="selected"<{/if}>>新しい順</option>
			</select><br />
<{section name=page_link start=$link_from loop=$link_to step=1}>
<{if $smarty.section.page_link.first}>
<{if $smarty.get.page eq 0}>
			最初へ&nbsp;前へ
<{else}>
			<a href="<{$SCRIPT_NAME}>?page=0&<{$pager}>">最初へ</a>&nbsp;
			<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page-1}>&<{$pager}>">前へ</a>
<{/if}>
<{else}>
<{/if}>
			<span class="page_navi">&nbsp;
<{if $smarty.get.page eq $smarty.section.page_link.index}>
				<a><{$smarty.section.page_link.index+1}></a>
<{else}>
				<a href="<{$SCRIPT_NAME}>?page=<{$smarty.section.page_link.index}>&<{$pager}>"><{$smarty.section.page_link.index+1}></a>
<{/if}>
			</span>
<{if $smarty.section.page_link.last}>
<{if $smarty.get.page eq $page_count-1}>
			&nbsp;次へ&nbsp;最後へ
<{else}>
			&nbsp;<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page+1}>&<{$pager}>">次へ</a>&nbsp;
			<a href="<{$SCRIPT_NAME}>?page=<{$page_count-1}>&<{$pager}>">最後へ</a>
<{/if}>
<{else}>
<{/if}>
<{/section}>
<{if $num > 0}>
			<table class="table_class">
				<thead>
					<tr>
						<th class="topL">ユーザー</th>
						<th>テキスト</th>
						<th class="topR">日時</th>
					</tr>
				</thead>
				<tbody>
<{foreach from=$time_line key=key item=val}>
					<tr<{if $key%2 eq 0}> class="two"<{/if}>>
						<td style="white-space:nowrap;"><a href="http://twitter.com/<{$val.user|escape}>" target="_blank"><img width="24" height="24" src="<{$val.image}>" />@<{$val.user|escape}></a></td>
						<td class="text"><{$val.text}></td>
						<td style="white-space:nowrap;"><{$val.date|escape}></td>
					</tr>
<{/foreach}>
				</tbody>
			</table>
<{section name=page_link start=$link_from loop=$link_to step=1}>
<{if $smarty.section.page_link.first}>
<{if $smarty.get.page eq 0}>
			最初へ&nbsp;前へ
<{else}>
			<a href="<{$SCRIPT_NAME}>?page=0&<{$pager}>">最初へ</a>&nbsp;
			<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page-1}>&<{$pager}>">前へ</a>
<{/if}>
<{else}>
<{/if}>
			<span class="page_navi">&nbsp;
<{if $smarty.get.page eq $smarty.section.page_link.index}>
				<a><{$smarty.section.page_link.index+1}></a>
<{else}>
				<a href="<{$SCRIPT_NAME}>?page=<{$smarty.section.page_link.index}>&<{$pager}>"><{$smarty.section.page_link.index+1}></a>
<{/if}>
			</span>
<{if $smarty.section.page_link.last}>
<{if $smarty.get.page eq $page_count-1}>
			&nbsp;次へ&nbsp;最後へ
<{else}>
			&nbsp;<a href="<{$SCRIPT_NAME}>?page=<{$smarty.get.page+1}>&<{$pager}>">次へ</a>&nbsp;
			<a href="<{$SCRIPT_NAME}>?page=<{$page_count-1}>&<{$pager}>">最後へ</a>
<{/if}>
<{else}>
<{/if}>
<{/section}>
<{/if}>
<{foreach from=$word_list item=val}>
				<a class="hidden_option" href="<{$SCRIPT_NAME}>?word=<{$val|escape:url}>&lang=all"><{$val|escape:escape}></a>
<{/foreach}>
			<div class="mail"><a href="mailto:wind-moon@ezweb.ne.jp?subject=%e5%95%8f%e3%81%84%e5%90%88%e3%82%8f%e3%81%9b">管理人にメール</a></div>
		</div>
		<div class="adv">
<!-- google 2 -->
<script type="text/javascript"><!--
google_ad_client = "pub-6287779710840631";
google_ad_slot = "8957324629";
google_ad_width = 160;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
<br />

<!-- google 1 -->
<script type="text/javascript"><!--
google_ad_client = "ca-pub-6287779710840631";
google_ad_slot = "5209127748";
google_ad_width = 160;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"> </script>
<br />

<!-- amazon 1 -->
<iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=dainasu-22&o=9&p=14&l=st1&mode=electronics-jp&search=<{$tag|escape:url}>&fc1=000000&lt1=&lc1=3366FF&bg1=FFFFFF&f=ifr" marginwidth="0" marginheight="0" width="160" height="600" border="0" frameborder="0" style="border:none;" scrolling="no"></iframe>
<br />

<!-- amazon 2 -->
<{if $is_android ne 'true'}>
<script type="text/javascript"><!--
amazon_ad_tag = "dainasu-22"; 
amazon_ad_width = "160"; 
amazon_ad_height = "600"; 
amazon_ad_link_target = "new"; 
amazon_ad_border = "hide";
//-->
</script>
<script type="text/javascript" src="http://www.assoc-amazon.jp/s/ads.js"></script>
<br />
<{/if}>
		</div>

<script type="text/javascript">
//<[[!CDATA
/*@cc_on _d=document;eval('var document=_d')@*/
$(function(){
	$("#main_form").submit(function(){
		$('input').each(function(){
			if(this.type == "submit" || this.type == "button" || this.value == "") {
				this.disabled = true;
			}
			if(this.name == "page_input") {
				$('#page_hide').val(this.value-1);
				this.disabled = true;
			}
		});
		$('select').each(function(){
			if(this.value == "") {
				this.disabled = true;
			}
		});
	});
	$('#change_btn').click(function(){
		$('#search_text').val('');
		$('#search_user').val('');
		$('#main_form').submit();
	});
	$('#select_word').change(function(){
		$('#main_form').submit();
	});
	$('#select_lang').change(function(){
		$('#main_form').submit();
	});
	$('#order').change(function(){
		$('#main_form').submit();
	});
	$('#reset_btn').click(function(){
		$('input').each(function(){
			if(this.type ="text")
			{
				$(this).val("");
			}
		});
	});
});
//]]>
</script>
	</body>
</html>
