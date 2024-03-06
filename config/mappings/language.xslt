<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:template name="language">
    <xsl:param name="value" />
    <xsl:choose>
      <xsl:when test="$value = 'ab' or $value = 'abk' or $value = 'abk'">Abkhazian</xsl:when>
      <xsl:when test="$value = 'aa' or $value = 'aar' or $value = 'aar'">Afar</xsl:when>
      <xsl:when test="$value = 'af' or $value = 'afr' or $value = 'afr'">Afrikaans</xsl:when>
      <xsl:when test="$value = 'ak' or $value = 'aka' or $value = 'aka'">Akan</xsl:when>
      <xsl:when test="$value = 'sq' or $value = 'sqi' or $value = 'alb'">Albanian</xsl:when>
      <xsl:when test="$value = 'am' or $value = 'amh' or $value = 'amh'">Amharic</xsl:when>
      <xsl:when test="$value = 'ar' or $value = 'ara' or $value = 'ara'">Arabic</xsl:when>
      <xsl:when test="$value = 'an' or $value = 'arg' or $value = 'arg'">Aragonese</xsl:when>
      <xsl:when test="$value = 'hy' or $value = 'hye' or $value = 'arm'">Armenian</xsl:when>
      <xsl:when test="$value = 'as' or $value = 'asm' or $value = 'asm'">Assamese</xsl:when>
      <xsl:when test="$value = 'av' or $value = 'ava' or $value = 'ava'">Avaric</xsl:when>
      <xsl:when test="$value = 'ae' or $value = 'ave' or $value = 'ave'">Avestan</xsl:when>
      <xsl:when test="$value = 'ay' or $value = 'aym' or $value = 'aym'">Aymara</xsl:when>
      <xsl:when test="$value = 'az' or $value = 'aze' or $value = 'aze'">Azerbaijani</xsl:when>
      <xsl:when test="$value = 'bm' or $value = 'bam' or $value = 'bam'">Bambara</xsl:when>
      <xsl:when test="$value = 'ba' or $value = 'bak' or $value = 'bak'">Bashkir</xsl:when>
      <xsl:when test="$value = 'eu' or $value = 'eus' or $value = 'baq'">Basque</xsl:when>
      <xsl:when test="$value = 'be' or $value = 'bel' or $value = 'bel'">Belarusian</xsl:when>
      <xsl:when test="$value = 'bn' or $value = 'ben' or $value = 'ben'">Bengali</xsl:when>
      <xsl:when test="$value = 'bi' or $value = 'bis' or $value = 'bis'">Bislama</xsl:when>
      <xsl:when test="$value = 'bs' or $value = 'bos' or $value = 'bos'">Bosnian</xsl:when>
      <xsl:when test="$value = 'br' or $value = 'bre' or $value = 'bre'">Breton</xsl:when>
      <xsl:when test="$value = 'bg' or $value = 'bul' or $value = 'bul'">Bulgarian</xsl:when>
      <xsl:when test="$value = 'my' or $value = 'mya' or $value = 'bur'">Burmese</xsl:when>
      <xsl:when test="$value = 'ca' or $value = 'cat' or $value = 'cat'">Catalan, Valencian</xsl:when>
      <xsl:when test="$value = 'ch' or $value = 'cha' or $value = 'cha'">Chamorro</xsl:when>
      <xsl:when test="$value = 'ce' or $value = 'che' or $value = 'che'">Chechen</xsl:when>
      <xsl:when test="$value = 'ny' or $value = 'nya' or $value = 'nya'">Chichewa, Chewa, Nyanja</xsl:when>
      <xsl:when test="$value = 'zh' or $value = 'zho' or $value = 'chi'">Chinese</xsl:when>
      <xsl:when test="$value = 'cu' or $value = 'chu' or $value = 'chu'">Church Slavonic, Old Slavonic, Old Church Slavonic</xsl:when>
      <xsl:when test="$value = 'cv' or $value = 'chv' or $value = 'chv'">Chuvash</xsl:when>
      <xsl:when test="$value = 'kw' or $value = 'cor' or $value = 'cor'">Cornish</xsl:when>
      <xsl:when test="$value = 'co' or $value = 'cos' or $value = 'cos'">Corsican</xsl:when>
      <xsl:when test="$value = 'cr' or $value = 'cre' or $value = 'cre'">Cree</xsl:when>
      <xsl:when test="$value = 'hr' or $value = 'hrv' or $value = 'hrv'">Croatian</xsl:when>
      <xsl:when test="$value = 'cs' or $value = 'ces' or $value = 'cze'">Czech</xsl:when>
      <xsl:when test="$value = 'da' or $value = 'dan' or $value = 'dan'">Danish</xsl:when>
      <xsl:when test="$value = 'dv' or $value = 'div' or $value = 'div'">Divehi, Dhivehi, Maldivian</xsl:when>
      <xsl:when test="$value = 'nl' or $value = 'nld' or $value = 'dut'">Dutch, Flemish</xsl:when>
      <xsl:when test="$value = 'dz' or $value = 'dzo' or $value = 'dzo'">Dzongkha</xsl:when>
      <xsl:when test="$value = 'en' or $value = 'eng' or $value = 'eng'">English</xsl:when>
      <xsl:when test="$value = 'eo' or $value = 'epo' or $value = 'epo'">Esperanto</xsl:when>
      <xsl:when test="$value = 'et' or $value = 'est' or $value = 'est'">Estonian</xsl:when>
      <xsl:when test="$value = 'ee' or $value = 'ewe' or $value = 'ewe'">Ewe</xsl:when>
      <xsl:when test="$value = 'fo' or $value = 'fao' or $value = 'fao'">Faroese</xsl:when>
      <xsl:when test="$value = 'fj' or $value = 'fij' or $value = 'fij'">Fijian</xsl:when>
      <xsl:when test="$value = 'fi' or $value = 'fin' or $value = 'fin'">Finnish</xsl:when>
      <xsl:when test="$value = 'fr' or $value = 'fra' or $value = 'fre'">French</xsl:when>
      <xsl:when test="$value = 'fy' or $value = 'fry' or $value = 'fry'">Western Frisian</xsl:when>
      <xsl:when test="$value = 'ff' or $value = 'ful' or $value = 'ful'">Fulah</xsl:when>
      <xsl:when test="$value = 'gd' or $value = 'gla' or $value = 'gla'">Gaelic, Scottish Gaelic</xsl:when>
      <xsl:when test="$value = 'gl' or $value = 'glg' or $value = 'glg'">Galician</xsl:when>
      <xsl:when test="$value = 'lg' or $value = 'lug' or $value = 'lug'">Ganda</xsl:when>
      <xsl:when test="$value = 'ka' or $value = 'kat' or $value = 'geo'">Georgian</xsl:when>
      <xsl:when test="$value = 'de' or $value = 'deu' or $value = 'ger'">German</xsl:when>
      <xsl:when test="$value = 'el' or $value = 'ell' or $value = 'gre'">Greek</xsl:when>
      <xsl:when test="$value = 'kl' or $value = 'kal' or $value = 'kal'">Kalaallisut, Greenlandic</xsl:when>
      <xsl:when test="$value = 'gn' or $value = 'grn' or $value = 'grn'">Guarani</xsl:when>
      <xsl:when test="$value = 'gu' or $value = 'guj' or $value = 'guj'">Gujarati</xsl:when>
      <xsl:when test="$value = 'ht' or $value = 'hat' or $value = 'hat'">Haitian, Haitian Creole</xsl:when>
      <xsl:when test="$value = 'ha' or $value = 'hau' or $value = 'hau'">Hausa</xsl:when>
      <xsl:when test="$value = 'he' or $value = 'heb' or $value = 'heb'">Hebrew</xsl:when>
      <xsl:when test="$value = 'hz' or $value = 'her' or $value = 'her'">Herero</xsl:when>
      <xsl:when test="$value = 'hi' or $value = 'hin' or $value = 'hin'">Hindi</xsl:when>
      <xsl:when test="$value = 'ho' or $value = 'hmo' or $value = 'hmo'">Hiri Motu</xsl:when>
      <xsl:when test="$value = 'hu' or $value = 'hun' or $value = 'hun'">Hungarian</xsl:when>
      <xsl:when test="$value = 'is' or $value = 'isl' or $value = 'ice'">Icelandic</xsl:when>
      <xsl:when test="$value = 'io' or $value = 'ido' or $value = 'ido'">Ido</xsl:when>
      <xsl:when test="$value = 'ig' or $value = 'ibo' or $value = 'ibo'">Igbo</xsl:when>
      <xsl:when test="$value = 'id' or $value = 'ind' or $value = 'ind'">Indonesian</xsl:when>
      <xsl:when test="$value = 'ia' or $value = 'ina' or $value = 'ina'">Interlingua (International Auxiliary Language Association)</xsl:when>
      <xsl:when test="$value = 'ie' or $value = 'ile' or $value = 'ile'">Interlingue, Occidental</xsl:when>
      <xsl:when test="$value = 'iu' or $value = 'iku' or $value = 'iku'">Inuktitut</xsl:when>
      <xsl:when test="$value = 'ik' or $value = 'ipk' or $value = 'ipk'">Inupiaq</xsl:when>
      <xsl:when test="$value = 'ga' or $value = 'gle' or $value = 'gle'">Irish</xsl:when>
      <xsl:when test="$value = 'it' or $value = 'ita' or $value = 'ita'">Italian</xsl:when>
      <xsl:when test="$value = 'ja' or $value = 'jpn' or $value = 'jpn'">Japanese</xsl:when>
      <xsl:when test="$value = 'jv' or $value = 'jav' or $value = 'jav'">Javanese</xsl:when>
      <xsl:when test="$value = 'kn' or $value = 'kan' or $value = 'kan'">Kannada</xsl:when>
      <xsl:when test="$value = 'kr' or $value = 'kau' or $value = 'kau'">Kanuri</xsl:when>
      <xsl:when test="$value = 'ks' or $value = 'kas' or $value = 'kas'">Kashmiri</xsl:when>
      <xsl:when test="$value = 'kk' or $value = 'kaz' or $value = 'kaz'">Kazakh</xsl:when>
      <xsl:when test="$value = 'km' or $value = 'khm' or $value = 'khm'">Central Khmer</xsl:when>
      <xsl:when test="$value = 'ki' or $value = 'kik' or $value = 'kik'">Kikuyu, Gikuyu</xsl:when>
      <xsl:when test="$value = 'rw' or $value = 'kin' or $value = 'kin'">Kinyarwanda</xsl:when>
      <xsl:when test="$value = 'ky' or $value = 'kir' or $value = 'kir'">Kirghiz, Kyrgyz</xsl:when>
      <xsl:when test="$value = 'kv' or $value = 'kom' or $value = 'kom'">Komi</xsl:when>
      <xsl:when test="$value = 'kg' or $value = 'kon' or $value = 'kon'">Kongo</xsl:when>
      <xsl:when test="$value = 'ko' or $value = 'kor' or $value = 'kor'">Korean</xsl:when>
      <xsl:when test="$value = 'kj' or $value = 'kua' or $value = 'kua'">Kuanyama, Kwanyama</xsl:when>
      <xsl:when test="$value = 'ku' or $value = 'kur' or $value = 'kur'">Kurdish</xsl:when>
      <xsl:when test="$value = 'lo' or $value = 'lao' or $value = 'lao'">Lao</xsl:when>
      <xsl:when test="$value = 'la' or $value = 'lat' or $value = 'lat'">Latin</xsl:when>
      <xsl:when test="$value = 'lv' or $value = 'lav' or $value = 'lav'">Latvian</xsl:when>
      <xsl:when test="$value = 'li' or $value = 'lim' or $value = 'lim'">Limburgan, Limburger, Limburgish</xsl:when>
      <xsl:when test="$value = 'ln' or $value = 'lin' or $value = 'lin'">Lingala</xsl:when>
      <xsl:when test="$value = 'lt' or $value = 'lit' or $value = 'lit'">Lithuanian</xsl:when>
      <xsl:when test="$value = 'lu' or $value = 'lub' or $value = 'lub'">Luba-Katanga</xsl:when>
      <xsl:when test="$value = 'lb' or $value = 'ltz' or $value = 'ltz'">Luxembourgish, Letzeburgesch</xsl:when>
      <xsl:when test="$value = 'mk' or $value = 'mkd' or $value = 'mac'">Macedonian</xsl:when>
      <xsl:when test="$value = 'mg' or $value = 'mlg' or $value = 'mlg'">Malagasy</xsl:when>
      <xsl:when test="$value = 'ms' or $value = 'msa' or $value = 'may'">Malay</xsl:when>
      <xsl:when test="$value = 'ml' or $value = 'mal' or $value = 'mal'">Malayalam</xsl:when>
      <xsl:when test="$value = 'mt' or $value = 'mlt' or $value = 'mlt'">Maltese</xsl:when>
      <xsl:when test="$value = 'gv' or $value = 'glv' or $value = 'glv'">Manx</xsl:when>
      <xsl:when test="$value = 'mi' or $value = 'mri' or $value = 'mao'">Maori</xsl:when>
      <xsl:when test="$value = 'mr' or $value = 'mar' or $value = 'mar'">Marathi</xsl:when>
      <xsl:when test="$value = 'mh' or $value = 'mah' or $value = 'mah'">Marshallese</xsl:when>
      <xsl:when test="$value = 'mn' or $value = 'mon' or $value = 'mon'">Mongolian</xsl:when>
      <xsl:when test="$value = 'na' or $value = 'nau' or $value = 'nau'">Nauru</xsl:when>
      <xsl:when test="$value = 'nv' or $value = 'nav' or $value = 'nav'">Navajo, Navaho</xsl:when>
      <xsl:when test="$value = 'nd' or $value = 'nde' or $value = 'nde'">North Ndebele</xsl:when>
      <xsl:when test="$value = 'nr' or $value = 'nbl' or $value = 'nbl'">South Ndebele</xsl:when>
      <xsl:when test="$value = 'ng' or $value = 'ndo' or $value = 'ndo'">Ndonga</xsl:when>
      <xsl:when test="$value = 'ne' or $value = 'nep' or $value = 'nep'">Nepali</xsl:when>
      <xsl:when test="$value = 'no' or $value = 'nor' or $value = 'nor'">Norwegian</xsl:when>
      <xsl:when test="$value = 'nb' or $value = 'nob' or $value = 'nob'">Norwegian Bokmål</xsl:when>
      <xsl:when test="$value = 'nn' or $value = 'nno' or $value = 'nno'">Norwegian Nynorsk</xsl:when>
      <xsl:when test="$value = 'ii' or $value = 'iii' or $value = 'iii'">Sichuan Yi, Nuosu</xsl:when>
      <xsl:when test="$value = 'oc' or $value = 'oci' or $value = 'oci'">Occitan</xsl:when>
      <xsl:when test="$value = 'oj' or $value = 'oji' or $value = 'oji'">Ojibwa</xsl:when>
      <xsl:when test="$value = 'or' or $value = 'ori' or $value = 'ori'">Oriya</xsl:when>
      <xsl:when test="$value = 'om' or $value = 'orm' or $value = 'orm'">Oromo</xsl:when>
      <xsl:when test="$value = 'os' or $value = 'oss' or $value = 'oss'">Ossetian, Ossetic</xsl:when>
      <xsl:when test="$value = 'pi' or $value = 'pli' or $value = 'pli'">Pali</xsl:when>
      <xsl:when test="$value = 'ps' or $value = 'pus' or $value = 'pus'">Pashto, Pushto</xsl:when>
      <xsl:when test="$value = 'fa' or $value = 'fas' or $value = 'per'">Persian</xsl:when>
      <xsl:when test="$value = 'pl' or $value = 'pol' or $value = 'pol'">Polish</xsl:when>
      <xsl:when test="$value = 'pt' or $value = 'por' or $value = 'por'">Portuguese</xsl:when>
      <xsl:when test="$value = 'pa' or $value = 'pan' or $value = 'pan'">Punjabi, Panjabi</xsl:when>
      <xsl:when test="$value = 'qu' or $value = 'que' or $value = 'que'">Quechua</xsl:when>
      <xsl:when test="$value = 'ro' or $value = 'ron' or $value = 'rum'">Romanian, Moldavian, Moldovan</xsl:when>
      <xsl:when test="$value = 'rm' or $value = 'roh' or $value = 'roh'">Romansh</xsl:when>
      <xsl:when test="$value = 'rn' or $value = 'run' or $value = 'run'">Rundi</xsl:when>
      <xsl:when test="$value = 'ru' or $value = 'rus' or $value = 'rus'">Russian</xsl:when>
      <xsl:when test="$value = 'se' or $value = 'sme' or $value = 'sme'">Northern Sami</xsl:when>
      <xsl:when test="$value = 'sm' or $value = 'smo' or $value = 'smo'">Samoan</xsl:when>
      <xsl:when test="$value = 'sg' or $value = 'sag' or $value = 'sag'">Sango</xsl:when>
      <xsl:when test="$value = 'sa' or $value = 'san' or $value = 'san'">Sanskrit</xsl:when>
      <xsl:when test="$value = 'sc' or $value = 'srd' or $value = 'srd'">Sardinian</xsl:when>
      <xsl:when test="$value = 'sr' or $value = 'srp' or $value = 'srp'">Serbian</xsl:when>
      <xsl:when test="$value = 'sn' or $value = 'sna' or $value = 'sna'">Shona</xsl:when>
      <xsl:when test="$value = 'sd' or $value = 'snd' or $value = 'snd'">Sindhi</xsl:when>
      <xsl:when test="$value = 'si' or $value = 'sin' or $value = 'sin'">Sinhala, Sinhalese</xsl:when>
      <xsl:when test="$value = 'sk' or $value = 'slk' or $value = 'slo'">Slovak</xsl:when>
      <xsl:when test="$value = 'sl' or $value = 'slv' or $value = 'slv'">Slovenian</xsl:when>
      <xsl:when test="$value = 'so' or $value = 'som' or $value = 'som'">Somali</xsl:when>
      <xsl:when test="$value = 'st' or $value = 'sot' or $value = 'sot'">Southern Sotho</xsl:when>
      <xsl:when test="$value = 'es' or $value = 'spa' or $value = 'spa'">Spanish, Castilian</xsl:when>
      <xsl:when test="$value = 'su' or $value = 'sun' or $value = 'sun'">Sundanese</xsl:when>
      <xsl:when test="$value = 'sw' or $value = 'swa' or $value = 'swa'">Swahili</xsl:when>
      <xsl:when test="$value = 'ss' or $value = 'ssw' or $value = 'ssw'">Swati</xsl:when>
      <xsl:when test="$value = 'sv' or $value = 'swe' or $value = 'swe'">Swedish</xsl:when>
      <xsl:when test="$value = 'tl' or $value = 'tgl' or $value = 'tgl'">Tagalog</xsl:when>
      <xsl:when test="$value = 'ty' or $value = 'tah' or $value = 'tah'">Tahitian</xsl:when>
      <xsl:when test="$value = 'tg' or $value = 'tgk' or $value = 'tgk'">Tajik</xsl:when>
      <xsl:when test="$value = 'ta' or $value = 'tam' or $value = 'tam'">Tamil</xsl:when>
      <xsl:when test="$value = 'tt' or $value = 'tat' or $value = 'tat'">Tatar</xsl:when>
      <xsl:when test="$value = 'te' or $value = 'tel' or $value = 'tel'">Telugu</xsl:when>
      <xsl:when test="$value = 'th' or $value = 'tha' or $value = 'tha'">Thai</xsl:when>
      <xsl:when test="$value = 'bo' or $value = 'bod' or $value = 'tib'">Tibetan</xsl:when>
      <xsl:when test="$value = 'ti' or $value = 'tir' or $value = 'tir'">Tigrinya</xsl:when>
      <xsl:when test="$value = 'to' or $value = 'ton' or $value = 'ton'">Tonga (Tonga Islands)</xsl:when>
      <xsl:when test="$value = 'ts' or $value = 'tso' or $value = 'tso'">Tsonga</xsl:when>
      <xsl:when test="$value = 'tn' or $value = 'tsn' or $value = 'tsn'">Tswana</xsl:when>
      <xsl:when test="$value = 'tr' or $value = 'tur' or $value = 'tur'">Turkish</xsl:when>
      <xsl:when test="$value = 'tk' or $value = 'tuk' or $value = 'tuk'">Turkmen</xsl:when>
      <xsl:when test="$value = 'tw' or $value = 'twi' or $value = 'twi'">Twi</xsl:when>
      <xsl:when test="$value = 'ug' or $value = 'uig' or $value = 'uig'">Uighur, Uyghur</xsl:when>
      <xsl:when test="$value = 'uk' or $value = 'ukr' or $value = 'ukr'">Ukrainian</xsl:when>
      <xsl:when test="$value = 'ur' or $value = 'urd' or $value = 'urd'">Urdu</xsl:when>
      <xsl:when test="$value = 'uz' or $value = 'uzb' or $value = 'uzb'">Uzbek</xsl:when>
      <xsl:when test="$value = 've' or $value = 'ven' or $value = 'ven'">Venda</xsl:when>
      <xsl:when test="$value = 'vi' or $value = 'vie' or $value = 'vie'">Vietnamese</xsl:when>
      <xsl:when test="$value = 'vo' or $value = 'vol' or $value = 'vol'">Volapük</xsl:when>
      <xsl:when test="$value = 'wa' or $value = 'wln' or $value = 'wln'">Walloon</xsl:when>
      <xsl:when test="$value = 'cy' or $value = 'cym' or $value = 'wel'">Welsh</xsl:when>
      <xsl:when test="$value = 'wo' or $value = 'wol' or $value = 'wol'">Wolof</xsl:when>
      <xsl:when test="$value = 'xh' or $value = 'xho' or $value = 'xho'">Xhosa</xsl:when>
      <xsl:when test="$value = 'yi' or $value = 'yid' or $value = 'yid'">Yiddish</xsl:when>
      <xsl:when test="$value = 'yo' or $value = 'yor' or $value = 'yor'">Yoruba</xsl:when>
      <xsl:when test="$value = 'za' or $value = 'zha' or $value = 'zha'">Zhuang, Chuang</xsl:when>
      <xsl:when test="$value = 'zu' or $value = 'zul' or $value = 'zul'">Zulu</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
