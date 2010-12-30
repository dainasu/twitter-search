<?php
require_once('lib/smarty/Smarty.class.php');
require_once 'MDB2.php';
#header("Location: error.html");
#exit;
class base
{
	function __construct()
	{
		$this->smarty = new Smarty;

		$this->user_name = "kuon";
		$this->pass_word = "kureha@admin";
		session_start();

		$this->max_word = 30;
		// 内部変数
		$current_path = $_SERVER['DOCUMENT_ROOT'];
		$this->twit_text = "Twitter 検索収集 http://twit.dainasu.com/";

		// smarty 設定
		$this->smarty->cache_dir       = $current_path . "_cache";
		$this->smarty->compile_dir     = $current_path . "_template_c";
		$this->smarty->template_dir    = $current_path . "template";
		$this->smarty->left_delimiter  = "<{" ;
		$this->smarty->right_delimiter = "}>";

		// DB接続
		$db   = 'twitter_api';
		$host = 'localhost';
		$user = 'twitter_api';
		$pass = 'hjzqWVuFyRtNHvWz';
		#$dsn = 'mysql://{$user}:{$pass}@{$host}/{$db}';
		#$options = array(
			#'debug' => 2,
			#'result_buffering' => false,
		#);
#
		#$this->db =& MDB2::factory($dsn, $options);
		#if (PEAR::isError($this->db))
		#{
			#die($this->db->getMessage());
		#}

		if(!mysql_connect($host,$user,$pass))
		{
			die("DB接続エラー" .  mysql_error());
		}
		if(!mysql_select_db($db))
		{
			die("DB接続エラー" .  mysql_error());
		}
		if(mysql_query("SET NAMES utf8"))
		{
		}

		// 共通設定
		$this->page_sep = 25;
		$this->mobile_sep = 10;
		$this->ua_set();

		$arr_lang = array(
				"all"  => "全て",
				"ab"   => "Abkhazian",
				"aa"   => "Afar",
				"af"   => "Afrikaans",
				"q"    => "Albanian",
				"am"   => "Amharic",
				"ar"   => "Arabic",
				"hy"   => "Armenian",
				"as"   => "Assamese",
				"ay"   => "Aymara",
				"az"   => "Azerbaijani",
				"ba"   => "Bashkir",
				"eu"   => "Basque",
				"bn"   => "Bengali",
				"bh"   => "Bihari",
				"bi"   => "Bislama",
				"be"   => "Breton",
				"bg"   => "Bulgarian",
				"my"   => "Burmese",
				"be"   => "Byelorussian",
				"ca"   => "Catalan",
				"zh"   => "Chinese",
				"co"   => "Corsican",
				"hr"   => "Croatian",
				"cs"   => "Czech",
				"da"   => "Danish",
				"nl"   => "Dutch",
				"dz"   => "Dzongkha",
				"en"   => "English",
				"eo"   => "Esperanto",
				"et"   => "Estonian",
				"fo"   => "Faroese",
				"fj"   => "Fijian",
				"fi"   => "Finnish",
				"fr"   => "French",
				"fy"   => "Frisian",
				"gl"   => "Gallegan",
				"ka"   => "Georgian",
				"de"   => "German",
				"el"   => "Greek, Modern",
				"kl"   => "Greenlandic",
				"gn"   => "Guarani",
				"gu"   => "Gujarati",
				"ha"   => "Hausa",
				"he"   => "Hebrew",
				"hi"   => "Hindi",
				"hu"   => "Hungarian",
				"is"   => "Icelandic",
				"id"   => "Indonesian",
				"ia"   => "Interlingua (International Auxiliary language Association)",
				"iu"   => "Inuktitut",
				"ik"   => "Inupiak",
				"ga"   => "Irish",
				"it"   => "Italian",
				"ja"   => "Japanese",
				"jv/jw"=> "Javanese",
				"kn"   => "Kannada",
				"ks"   => "Kashmiri",
				"kk"   => "Kazakh",
				"km"   => "Khmer",
				"rw"   => "Kinyarwanda",
				"ky"   => "Kirghiz",
				"ko"   => "Korean",
				"ku"   => "Kurdish",
				"oc"   => "Langue d'Oc (post 1500)",
				"lo"   => "Lao",
				"la"   => "Latin",
				"lv"   => "Latvian",
				"ln"   => "Lingala",
				"lt"   => "Lithuanian",
				"mk"   => "Macedonian",
				"mg"   => "Malagasy",
				"ms"   => "Malay",
				"ml"   => "Maltese",
				"mi"   => "Maori",
				"mr"   => "Marathi",
				"mo"   => "Moldavian",
				"mn"   => "Mongolian",
				"na"   => "Nauru",
				"ne"   => "Nepali",
				"no"   => "Norwegian",
				"or"   => "Oriya",
				"om"   => "Oromo",
				"pa"   => "Panjabi",
				"fa"   => "Persian",
				"pl"   => "Polish",
				"pt"   => "Portuguese",
				"ps"   => "Pushto",
				"qu"   => "Quechua",
				"rm"   => "Rhaeto-Romance",
				"ro"   => "Romanian",
				"rn"   => "Rundi",
				"ru"   => "Russian",
				"sm"   => "Samoan",
				"sg"   => "Sango",
				"sa"   => "Sanskrit",
				"sr"   => "Serbian",
				"sh"   => "Serbo-Croatian",
				"sn"   => "Shona",
				"sd"   => "Sindhi",
				"si"   => "Singhalese",
				"ss"   => "Siswant",
				"sk"   => "Slovak",
				"sl"   => "Slovenian",
				"so"   => "Somali",
				"st"   => "Sotho, Southern",
				"es"   => "Spanish",
				"su"   => "Sudanese",
				"sw"   => "Swahili",
				"sv"   => "Swedish",
				"tl"   => "Tagalog",
				"tg"   => "Tajik",
				"ta"   => "Tamil",
				"tt"   => "Tatar",
				"te"   => "Telugu",
				"th"   => "Thai",
				"bo"   => "Tibetan",
				"ti"   => "Tigrinya",
				"to"   => "Tonga (Nyasa)",
				"ts"   => "Tsonga",
				"tn"   => "Tswana",
				"tr"   => "Turkish",
				"tk"   => "Turkmen",
				"tw"   => "Twi",
				"ug"   => "Uighur",
				"uk"   => "Ukrainian",
				"ur"   => "Urdu",
				"uz"   => "Uzbek",
				"vi"   => "Vietnamese",
				"vo"   => "Volapük",
				"cy"   => "Welsh",
				"wo"   => "Wolof",
				"xh"   => "Xhosa",
				"yi"   => "Yiddish",
				"yo"   => "Yoruba",
				"za"   => "Zhuang",
				"zu"   => "Zulu",
				""     => "不明"
		);
		$this->assignVal('arr_lang' , $arr_lang);
		//終了時に実行される関数を設定
		register_shutdown_function(array(&$this , 'end_of_func'));
		
		$file_name = basename($_SERVER['SCRIPT_NAME']);

		$this->template_name = preg_replace('/\.[^\.]+$/', '', $file_name) . ".tpl";
		$this->file_name = $file_name;
	}
	
	// アサイン関数
	function assignVal($key , $val)
	{
		$this->smarty->assign($key , $val);
	}
	
	// 終了時に呼ばれる関数として定義
	function end_of_func()
	{
		// 持続的ではない接続は勝手に閉じられるが念のため
		#$this->db->disconnect();
		mysql_close();
	}
	
	
	function array_trim($array)
	{
		if(is_array($array))
		{
			foreach($array as &$val)
			{
				$var = $this->array_trim($val);
			}
			$ret = $array;
		}
		else
		{
			$ret = trim($array);
		}
		return $ret;
	}

	function ua_set()
	{
		$this->ua = $_SERVER['HTTP_USER_AGENT'];
		if(preg_match("/^DoCoMo/i", $this->ua))
		{
			$this->term_type = "dc";
		}
		else if(preg_match("/^(J\-PHONE|Vodafone|MOT\-[CV]|SoftBank)/i", $this->ua))
		{
			$this->term_type = "sb";
		}
		else if(preg_match("/^KDDI\-/i", $this->ua) || preg_match("/UP\.Browser/i", $this->ua))
		{
			$this->term_type = "au";
		}
		else
		{
			$this->term_type = "pc";
		}
	}
}
?>
