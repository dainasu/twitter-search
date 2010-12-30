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
			<div>管理者ログイン</div>
			<table class="login_tbl">
				<tr>
					<th>ログインID :</td> 
					<td>
						<input type="text" name="user_name" maxlength="20" value="" style="ime-mode: disabled;"/>
					</td>
				</tr>
				<tr>
					<th>パスワード :</td> 
					<td>
						<input type="password" name="pass_word" maxlength="32" value="" />
					</td>
				</tr>
			</table>
			<div class="error"><{$err_mes|escape}></div>
			<input type="hidden" name="is_submit" value="true" />
			<input type="submit" name="login_btn" value="変更" />
		</div>
	</body>
    <script type="text/javascript">
//<[[!CDATA
//]]>
    </script>
</html>
