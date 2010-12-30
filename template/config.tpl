<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja" dir="ltr">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>twitter 検索収集</title>
		<meta http-equiv="Content-Style-type" content="text/css" />
		<meta http-equiv="content-script-type" content="text/javascript">
		<meta name="viewport" content="width=300">
		<link rel="stylesheet" href="css/default.css" type="text/css" />
		<link rel="stylesheet" href="css/contents.css" type="text/css" />
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/link.js"></script>
	</head>
	<body>
		<div class="main">
			<div class="title_logo">
				<a href="/"><img src="/images/logo.png" alt="HOME" /></a>
			</div>
			<form action="<{$SCRIPT_NAME}>" method="post">
			<div>登録されたキーワードを五分おきに取得</div>
			<table class="config_table">
				<thead>
					<tr>
						<th class="topL">キーワード</th>
					</tr>
				</thead>
				<tbody>
<{foreach from=$word_list key=key item=val}>
					<tr<{if $key%2 eq 0}> class="two"<{/if}>>
						<td class="text" colspan="3">
							<input type="text" maxlength="255" name="word[]" size="20" value="<{$val.word|escape}>" />
<{if $val.delay < 0}>
							cron実行待機中
<{elseif $val.delay ne ''}>
							更新まで<{$val.delay|escape}>秒
<{/if}>
						</td>
					</tr>
<{/foreach}>
				</tbody>
			</table>
			<input type="hidden" name="is_submit" value="1" />
			<input type="submit" name="word_change" value="変更" />
		</div>
	</body>
    <script type="text/javascript">
//<[[!CDATA
//]]>
    </script>
</html>
