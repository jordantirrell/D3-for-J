coclass 'd3heatmap'
coinsert 'd3'

require 'regex'

create=: 3 : 0
 DATA=: y
 ''
)

jev_get=: 3 : 0
 JS =: JS hrplc 'JPATH';HPATH
 ('Map Visualization: ',>coname'') jhr ''
)

HBS =: 0 : 0
'showmap' jhb 'Show Map'
'colorsel' jhselect ('Blues';'Greens';'Oranges';'Reds';'Greys');1;0
html
)

html =: 0 : 0
  <div id="map"></div>
)


makesampledata =: 3 : 0
readnoun PATH,'mapvisexample.ijn'
)

ev_showmap_click=: 3 : 0 NB. J verb run when a traffic type is selected
 max=. ": >./ > {: 1{ DATA NB. max data val as string
 data =. ( >@{. ('{',,&'}')@:}.@:;@:(((',"',,&'":')&.>)@:[ ,&.> <@":"0@] ) >@{: )@:({:"1) DATA  NB. format data
 uscount =. (fread PATH,'us-counties.json')
 usstates =. (fread PATH,'us-states.json')
 color =. getv 'colorsel'
 jhrajax max,JASEP,data,JASEP,uscount,JASEP,usstates,JASEP,color  NB. Send max value(for log scale), data, svg jsons, selected color
)

JSSRC=: 0 : 0
d3.v2.min.js
)
JSSRC=: ;(<HPATH) , each (<;._2 JSSRC) ,&.> (<LF)


JS=: 0 : 0

function ev_showmap_click_ajax(ts) { //ajax call for traffic type 
var max = ts[0]; //maximum data value
var dat = eval( '(' + ts[1] + ')' );      //convert string into json object for data
var uscount = eval( '(' + ts[2] + ')' );  //convert string into json object for counties svg
var usstates = eval( '(' + ts[3] + ')' ); //convert string into json object for states svg
var color = ts[4];                        //set color

var width = 1280, height = 800;

var path = d3.geo.path()
    .projection(d3.geo.albersUsa()
      .scale(1400)
      .translate([680, 360]));

var svg = d3.select(document.getElementById("map")).append("svg:svg")
    .attr("class", color)
    .attr("width", width)
    .attr("height", height);

var counties = svg.append("svg:g")
    .attr("id", "counties");

var states = svg.append("svg:g")
    .attr("id", "states");

var dc = function(data, json) {                      //set svg and data for counties
  var pad = d3.format("05d"),
      logscale = d3.scale.log().domain([1,max]).rangeRound([1,9]);
    counties.selectAll("path")
        .data(json.features)
      .enter().append("svg:path")
        .attr("class", function(d) { 
             if(data[ pad(d.id) ]==undefined ) { data[ pad(d.id) ] = "0"; return "q0-9"}
             else {return "q" + logscale(data[ pad(d.id) ]) + "-9"; } })
        .attr("d", path)
      .append("svg:title")
        .text(function(d) { return d.properties.name + ": " + data[ pad(d.id) ]; });
}(dat, uscount);

var ds = function(json) {                            //set svg for states
  states.selectAll("path")
      .data(json.features)
    .enter().append("svg:path")
      .attr("d", path);
}(usstates);

d3.select("select").on("change", function() {
  d3.selectAll("svg").attr("class", this.value);
});

};


function ev_showmap_click() { //gets called when Show Map button is clicked
  jdoajax(["colorsel"],"");
}

)


CSS =: 0 : 0

#counties path {
  stroke: #fff;
  stroke-width: .25px;
}

#states path {
  fill: none;
  stroke: #fff;
  stroke-width: 1.0px;
}

body {
  overflow: hidden;
  margin: 0;
  font-size: 14px;
  font-family: "Helvetica Neue", Helvetica;
  background-color: beige;
}

#chart, #header, #footer {
  position: absolute;
  top: 0;
}

#header, #footer {
  z-index: 1;
  display: block;
  font-size: 36px;
  font-weight: 300;
  text-shadow: 0 1px 0 #fff;
}

#header.inverted, #footer.inverted {
  color: #fff;
  text-shadow: 0 1px 4px #000;
}

#header {
  top: 80px;
  left: 140px;
  width: 1000px;
}

#footer {
  top: 680px;
  right: 140px;
  text-align: right;
}

rect {
  fill: none;
  pointer-events: all;
}

pre {
  font-size: 18px;
}

line {
  stroke: #000;
  stroke-width: 1.5px;
}

.string, .regexp {
  color: #f39;
}

.keyword {
  color: #00c;
}

.comment {
  color: #777;
  font-style: oblique;
}

.number {
  color: #369;
}

.class, .special {
  color: #1181B8;
}

a:link, a:visited {
  color: #000;
  text-decoration: none;
}

a:hover {
  color: #666;
}

.hint {
  position: absolute;
  right: 0;
  width: 1280px;
  font-size: 12px;
  color: #999;
}



.Blues .q0-9{fill:rgb(255,255,255)}
.Blues .q1-9{fill:rgb(247,251,255)}
.Blues .q2-9{fill:rgb(222,235,247)}
.Blues .q3-9{fill:rgb(198,219,239)}
.Blues .q4-9{fill:rgb(158,202,225)}
.Blues .q5-9{fill:rgb(107,174,214)}
.Blues .q6-9{fill:rgb(66,146,198)}
.Blues .q7-9{fill:rgb(33,113,181)}
.Blues .q8-9{fill:rgb(8,81,156)}
.Blues .q9-9{fill:rgb(8,48,107)}

.Greens .q0-9{fill:rgb(255,255,255)}
.Greens .q1-9{fill:rgb(247,252,245)}
.Greens .q2-9{fill:rgb(229,245,224)}
.Greens .q3-9{fill:rgb(199,233,192)}
.Greens .q4-9{fill:rgb(161,217,155)}
.Greens .q5-9{fill:rgb(116,196,118)}
.Greens .q6-9{fill:rgb(65,171,93)}
.Greens .q7-9{fill:rgb(35,139,69)}
.Greens .q8-9{fill:rgb(0,109,44)}
.Greens .q9-9{fill:rgb(0,68,27)}

.Greys .q0-9{fill:rgb(255,255,255)}
.Greys .q1-9{fill:rgb(240,240,240)}
.Greys .q2-9{fill:rgb(217,217,217)}
.Greys .q3-9{fill:rgb(189,189,189)}
.Greys .q4-9{fill:rgb(150,150,150)}
.Greys .q5-9{fill:rgb(115,115,115)}
.Greys .q6-9{fill:rgb(82,82,82)}
.Greys .q7-9{fill:rgb(37,37,37)}
.Greys .q8-9{fill:rgb(0,0,0)}

.Oranges .q0-9{fill:rgb(255,255,255)}
.Oranges .q1-9{fill:rgb(255,245,235)}
.Oranges .q2-9{fill:rgb(254,230,206)}
.Oranges .q3-9{fill:rgb(253,208,162)}
.Oranges .q4-9{fill:rgb(253,174,107)}
.Oranges .q5-9{fill:rgb(253,141,60)}
.Oranges .q6-9{fill:rgb(241,105,19)}
.Oranges .q7-9{fill:rgb(217,72,1)}
.Oranges .q8-9{fill:rgb(166,54,3)}
.Oranges .q9-9{fill:rgb(127,39,4)}

.Reds .q0-9{fill:rgb(255,255,255)}
.Reds .q1-9{fill:rgb(255,245,240)}
.Reds .q2-9{fill:rgb(254,224,210)}
.Reds .q3-9{fill:rgb(252,187,161)}
.Reds .q4-9{fill:rgb(252,146,114)}
.Reds .q5-9{fill:rgb(251,106,74)}
.Reds .q6-9{fill:rgb(239,59,44)}
.Reds .q7-9{fill:rgb(203,24,29)}
.Reds .q8-9{fill:rgb(165,15,21)}
.Reds .q9-9{fill:rgb(103,0,13)}




)