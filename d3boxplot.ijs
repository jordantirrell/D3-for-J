coclass 'd3boxplot'
coinsert 'd3'

require 'convert/json stats'

create=: 3 : 0
 DATA=: y
 ''
)

jev_get=: 3 : 0
 JS =: JS hrplc 'JPATH';HPATH
 ('Box Plot: ',>coname'') jhr ''
)

HBS =: 0 : 0
'showbox' jhb 'Show Box Plot'
html
)

html =: 0 : 0
  <div id="boxplot"></div>
)

JSSRC=: 0 : 0
d3.v2.min.js
)
JSSRC=: ;(<HPATH) , each (<;._2 JSSRC) ,&.> (<LF)


makesampledata =: 3 : 0
|:('Categories';<<"0 >: ? 100 $ 10),.('Data';(? 100 $ 100))
)


fqind =: 3 : '<:<.0.5+0.25*#y'  NB. calculating quartiles
tqind =: 3 : '<:<.0.5+0.75*#y'
fq =: 3 : '(fqind { ]) /:~ y'
tq =: 3 : '(tqind { ]) /:~ y'

ev_showbox_click =: 3 : 0 
 data =. enc_json_json_<"1 (~.> 0{ {:"1 DATA) ,. ><"0 each (min, fq, median, tq, max) each (I. each <"1(~. -:"0/ ]) > 0{ {:"1 DATA) {each (1{ {:"1 DATA)
 jhrajax data
)


JS=: 0 : 0

function ev_showbox_click_ajax(ts) { //ajax call for traffic type 

var d = eval( '(' + ts[0] + ')' );      //convert string into json object for data
title = "";                             //Blank plot title

var data = []; //Put data into better format (with masked indexes)
for (var i=0; i<d.length; i++) {
  data[i]={lab: d[i][0], min: d[i][1], fq: d[i][2], med: d[i][3], tq: d[i][4], max: d[i][5]};
}

var barwidth = 30;
var ybotpad = 30;
var ytoppad = 30;
var xpad = 70;
var barspacing = 60;
var ticklen = 5;
var ytickcount = 11;
var width = (barwidth + barspacing) * data.length + xpad;
var height = 400;

// create the parent div
var newdiv = document.getElementById('boxplot');
newdiv.setAttribute('class', 'file');
newdiv.setAttribute('name', 'd3');

gmax = d3.max(data, function(datum) { return datum.max; });
gmin = d3.min(data, function(datum) { return datum.min; });
var x = d3.scale.linear().domain([0, data.length]).range([xpad, width]);
var y = d3.scale.linear().domain([gmin, gmax]).rangeRound([0, height]);

// add the svg to the DOM
var chart = d3.select(newdiv)
  .append("svg:svg")
  .attr("width", width)
  .attr("height", height+ybotpad+ytoppad);

var titleelement = chart.append("svg:text")
  .attr("x", .5*width)
  .attr("y", 0)
  .attr("dx", 0)
  .attr("text-anchor", "middle")
  .attr("style", "font-size: 18; font-family: Helvetica, sans-serif")
  .text(title)
  .attr("transform", "translate(0, 20)");

// set up the x axis
var xAxis = chart.append("svg:g");
xAxis.selectAll("xAxis.axis")
  .data(data)
  .enter().append("svg:line")
  .attr("x1", xpad-barspacing)
  .attr("y1", height + ytoppad + 5)
  .attr("x2", width)
  .attr("y2", height + ytoppad + 5)
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
xAxis.selectAll("xAxis.ticks")
  .data(data)
  .enter().append("svg:line")
  .attr("x1", function(datum, index) { return x(index) + .5*barwidth; })
  .attr("y1", height + ytoppad + 5)
  .attr("x2", function(datum, index) { return x(index) + .5*barwidth;})
  .attr("y2", height + ytoppad + 5 + ticklen)
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
xAxis.selectAll("text.xAxis")
  .data(data)
  .enter().append("svg:text")
  .attr("x", function(datum, index) { return x(index) + (barwidth/2); })
  .attr("y", height + ytoppad + 5)
  //.attr("dx", -barwidth/2)
  .attr("text-anchor", "middle")
  .attr("style", "font-size: 14; font-family: Helvetica, sans-serif")
  .attr("stroke-width", 0)
  .text(function(datum) { return datum.lab;})
  .attr("transform", "translate(0, 18)");

//set up rectangles with first/third quartile labels
var boxes = chart.append("svg:g");
boxes.selectAll("rect")
  .data(data)
  .enter().append("svg:rect")
  .attr("x", function(datum, index) { return x(index) })
  .attr("y", function(datum) { return height + ytoppad - y(datum.tq) })
  .attr("height", function(datum) { return y(datum.tq)-y(datum.fq) })
  .attr("width", barwidth)
  .style("fill", "none")
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
boxes.selectAll("labl.fq")
  .data(data)
  .enter().append("svg:text")
  .attr("x", function(datum, index) { return x(index)-2 ;})
  .attr("y", function(datum) { return height + ytoppad - y(datum.fq) })
  //.attr("dx", barwidth+2)
  .attr("text-anchor", "end")
  .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
  .attr("stroke-width", 0)
  .text(function(datum) {return datum.fq;})
  .attr("transform", "translate(0, 3)");
boxes.selectAll("labl.tq")
  .data(data)
  .enter().append("svg:text")
  .attr("x", function(datum, index) { return x(index)-2 ;})
  .attr("y", function(datum) { return height + ytoppad - y(datum.tq) })
  //.attr("dx", barwidth+2)
  .attr("text-anchor", "end")
  .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
  .attr("stroke-width", 0)
  .text(function(datum) {return datum.tq;})
  .attr("transform", "translate(0, 3)");

// set up median line with label
var median = chart.append("svg:g");
median.selectAll("line.med")
  .data(data)
  .enter().append("svg:line")
  .attr("x1", function(datum, index) { return x(index)})
  .attr("y1", function(datum) {return height + ytoppad - y(datum.med)})
  .attr("x2", function(datum, index) { return x(index)+barwidth})
  .attr("y2", function(datum) {return height + ytoppad - y(datum.med)})
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
median.selectAll("labl.med")
  .data(data)
  .enter().append("svg:text")
  .attr("x", function(datum, index) { return x(index)-2})
  .attr("y", function(datum) {return height + ytoppad - y(datum.med) })
  //.attr("dx", -2)
  .attr("text-anchor", "end")
  .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
  .text(function(datum) {return datum.med;})
  .attr("transform", "translate(0, 3)");

// set up minimum lines with label
var minimum = chart.append("svg:g");
minimum.selectAll("line.min")
  .data(data)
  .enter()
  .append("svg:line")
  .attr("x1", function(datum, index) { return x(index);})
  .attr("y1", function(datum) {return height + ytoppad - y(datum.min)})
  .attr("x2", function(datum, index) { return x(index)+barwidth;})
  .attr("y2", function(datum) {return height + ytoppad - y(datum.min)})
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
minimum.selectAll("line.vmin")
  .data(data)
  .enter()
  .append("svg:line")
  .attr("x1", function(datum, index) { return x(index)+.5*barwidth;})
  .attr("y1", function(datum) {return height + ytoppad - y(datum.fq)})
  .attr("x2", function(datum, index) { return x(index)+.5*barwidth;})
  .attr("y2", function(datum) {return height + ytoppad - y(datum.min)})
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
minimum.selectAll("labl.min")
  .data(data)
  .enter()
  .append("svg:text")
  .attr("x", function(datum, index) { return x(index)-2 })
  .attr("y", function(datum) {return height + ytoppad - y(datum.min) })
  //.attr("dx", -2)
  .attr("text-anchor", "end")
  .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
  .attr("stroke-width", 0)
  .text(function(datum) {return datum.min;})
  .attr("transform", "translate(0, 3)");

// set up maximum lines with label
var maximum = chart.append("svg:g");
maximum.selectAll("line.max")
  .data(data)
  .enter()
  .append("svg:line")
  .attr("x1", function(datum, index) { return x(index);})
  .attr("y1", function(datum) {return height + ytoppad - y(datum.max)})
  .attr("x2", function(datum, index) { return x(index)+barwidth;})
  .attr("y2", function(datum) {return height + ytoppad - y(datum.max)})
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
maximum.selectAll("line.vmax")
  .data(data)
  .enter()
  .append("svg:line")
  .attr("x1", function(datum, index) { return x(index)+.5*barwidth;})
  .attr("y1", function(datum) {return height + ytoppad - y(datum.tq)})
  .attr("x2", function(datum, index) { return x(index)+.5*barwidth;})
  .attr("y2", function(datum) {return height + ytoppad - y(datum.max)})
  .style("stroke", "black")
  .attr("stroke-width", 1.5);
maximum.selectAll("labl.max")
  .data(data)
  .enter()
  .append("svg:text")
  .attr("x", function(datum, index) { return x(index)-2})
  .attr("y", function(datum) {return height + ytoppad - y(datum.max)})
  //.attr("dx", -2)
  .attr("text-anchor", "end")
  .attr("style", "font-size: 12; font-family: Helvetica, sans-serif")
  .attr("stroke-width", 0)
  .text(function(datum) {return datum.max;})
  .attr("transform", "translate(0, 3)");
  
}

function ev_showbox_click() { //gets called when button is clicked
  jdoajax([],"");
}


)

CSS =: 0 : 0

body {
  overflow: hidden;
  margin: 0;
  font-size: 14px;
  font-family: "Helvetica Neue", Helvetica;
  background-color: beige;
}

)