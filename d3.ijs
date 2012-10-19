NB. Use D3 in J!
NB. Written by Justin Tirrell
NB. Edited  by Jordan Tirrell

coclass 'd3'
coinsert 'jhs'

PATH=: jpath'~addons/graphics/d3/'

HPATH=: '~root' , (}.~[:<./i.&'\/') PATH NB. use ~root in HPATH (html path) for JS/CSS

load@:(PATH&,);._2 ]0 :0
jhsmod.ijs
d3heatmap.ijs
d3boxplot.ijs
d3treeview.ijs
)

readnoun=: (3!:2)@((1!:1)&((]`<)@.((32&>)@(3!:0))))
writenoun=: ([: (3!:1) [) ((1!:2) ((]`<)@.((32&>)@(3!:0)))) ]

wopenloc=: 3 : 'jjs ''window.open("http://'',(gethv_jhs_ ''Host:''),''/'',(>y),''","_blank");'' '

d3heatmap_z_=: wopenloc_d3_ @: conew & 'd3heatmap'
d3boxplot_z_=: wopenloc_d3_ @: conew & 'd3boxplot'
d3treeview_z_=: wopenloc_d3_ @: conew & 'd3treeview'
d3treeview_dir_z_=: d3treeview@:treefmtfromdir_d3treeview_

NB. DOES NOT SANITIZE DATA
jdbtojson =: 3 : 0 NB. convert query to json string
colcount=.":#{."1 y
cols =. }.,;JASEP_jhs_,&.> {."1 y
dat=.  (#~LF&~:) '[',']',~}:;('},',~'{',}:)&.>;@(<@":"0@i.@#([,':"','",',~])&.>])&.><"1|:":&.>>(boxopen"_1)&.>{:"1 y
colcount,JASEP,cols,JASEP,dat
)

jdbtojasep =: 3 : 0  NB. converts query data into jasep format ... deprecated, use jdbtojson instead
colnames=.{."1 y
tdata=.{:"1 y
i=.0
dat=. ''
while. i < (0{$y) do. 
  if. i=0 do. dat=. (i{colnames), ":&.>@boxopen"_1 > i { tdata  NB. numbers have to be passed to ajax as strings
  else. dat=. dat,. (i{colnames), ":&.>@boxopen"_1 > i { tdata end.
  i=.>:i
  end.
datshape=.$,.dat
smoutput '$data: ', ":datshape
dat=. > , dat
dat=. (":"0 datshape),dat
dat=. }. ; <@(JASEP,":)"_1 ]dat
)