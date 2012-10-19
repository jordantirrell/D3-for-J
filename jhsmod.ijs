NB. modification of jhs class
NB. allows loading of js/css scripts

coclass 'd3'
coinsert 'jhs'

3 : 0''
if. _1 = 4!:0<'CSSSRC' do. CSSSRC=:'' end.
if. _1 = 4!:0<'JSSRC' do. JSSRC=:'' end.
)

JSSRCCORE=: 0 : 0
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript" src="https://www.google.com/uds/api/visualization/1.0/51041bd2ad97f9e73a69836dc7bd4676/format+en,default,corechart.I.js"></script>
)

jssrc=: 3 : 0 NB. takes in a list of js files
 a=. ;(<'<script src="') , each (<;._2 y) ,&.> (<'"></script>',LF)
JSSRCCORE,a
)

csssrc=: 3 : 0 NB. takes in a list of css files
 ;(<'<link rel="stylesheet" type="text/css" href="') , each (<;._2 y) ,&.> (<'"/>',LF)
)

NB. Cache-Control: no-cache

NB. html template <XXX>
NB. TITLE
NB. CSS   - styles
NB. JS    - javascript
NB. BODY  - body
hrtemplate=: toCRLF 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Connection: close

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
<CSSSRC>
<JSSRC>
<CSS>
<JS>
</head>
<BODY>
</html>
)

NB. build html response from page globals CSS JS HBS
NB. CSS or JS undefined allwed
NB.* jhr*title jhr names;values - names to replace with values
NB.* *send html response built from HBS CSS JS names values
jhr=: 4 : 0
if. _1=nc <'CSS' do. CSS=: '' end.
if. _1=nc <'JS'  do. JS=: '' end.
if. _1=nc <'JSSRC' do. JSSRC=: '' end.
if. _1=nc <'CSSSRC' do. CSSRC=: '' end.
tmpl=. hrtemplate
if. SETCOOKIE do.
 SETCOOKIE_jhs_=: 0
 tmpl=. tmpl rplc (CRLF,CRLF);CRLF,'Set-Cookie: ',cookie,CRLF,CRLF
end.
htmlresponse tmpl hrplc 'TITLE CSSSRC JSSRC CSS JS BODY';x;(csssrc CSSSRC);(jssrc JSSRC);(css CSS);(js JS);(jhbs HBS)hrplc y
)

