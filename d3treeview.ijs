coclass 'd3treeview'
coinsert 'd3'

require 'regex'

treefmtfromdir=: ($:@:;&'<dir>') ` ( (3&{.) ` ( ] , <@$:@(2&{.)@cut"1 @: (,"1 '/',"1 dir) &.> @: {. ) @. ((<'<dir>')={:) "1  ) @. L.

create=: 3 : 0
 DATA=: y
 ''
)

jev_get=: 3 : 0
 JS =: JS hrplc 'JPATH';HPATH
 ('Tree View: ',>coname'') jhr ''
)

HBS =: 0 : 0
'showtree' jhb 'Show Tree'
html
)

html =: 0 : 0
  <div id="tree"></div>
)

JSSRC=: 0 : 0
d3.v2.min.js
)
JSSRC=: ;(<HPATH) , each (<;._2 JSSRC) ,&.> (<LF)


ev_showtree_click=: 3 : 0
  NB. dat =. fread PATH,'visualizations/sampledata/flare.json'
  jhrajax }:enc_obj DATA NB.remove trailing comma
)

makesampledata =: 3 : 0
   subs2=.<('subchild1';(<'attr1');'');(<'subchild2';(<'chattr1');'')
   subs3=.<('subchild1';('attr1';'attr2');'');('subchild2';(<'chattr1');'');(<'subchild3';('chattr1';'chattr2');'')
   subs4=.<('subchild1';('attr1';'attr2';'attr3');'');('subchild2';(<'chattr1');'');('subchild3';('chattr1';'chattr2');'');(<'subchild4';('chattr1';'chattr2';'chattr3');'')
   c1=.('child1';(<'chattr1');subs2)
   c2=.('child2';('chattr1';'chattr2');subs3)
   c3=.('child3';('chattr1';'chattr2';'chattr3');subs4)
   ('parent';('pattr1';'pattr2';'pattr3');(<c1;c2;<c3))
)


enc_obj =: 3 : 0
  d=.y
  if. ''&-:&> 2{ d do.
    result =. '{"name": "', (":>0{d) , '", "attr": [' , (}:}:,'"',"1 (>>1{d),"1'", ') , '], ' , '"size": 0},'
  else. 
     result =. '{"name": "', (":>0{d) , '", "attr": [' , (}:}:,'"',"1 (>>1{d),"1'", ') , '], ' , '"children": [' , (}:,>enc_obj each >2{d) , ']},'
  end.
  (#~' '&~:) result NB. remove spaces
)
    


JS=: 0 : 0

function ev_showtree_click_ajax (ts) { // runs on button click

var dat = eval( '(' + ts[0] + ')' ); //convert string into json object for tree data svg

var m = [20, 120, 20, 120],
    w = 1280 - m[1] - m[3],
    h = 800 - m[0] - m[2],
    i = 0,
    root;
var tree = d3.layout.tree()
    .size([h, w]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

var vis = d3.select(document.getElementById("tree")).append("svg:svg")
    .attr("width", w + m[1] + m[3])
    .attr("height", h + m[0] + m[2])
  .append("svg:g")
    .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

var df = function(json) {
  root = json;
  root.x0 = h / 2;
  root.y0 = 0;

  function toggleAll(d) {
    if (d.children) {
      d.children.forEach(toggleAll);
      toggle(d);
    }
  }

  // Initialize the display to show a few nodes.
  root.children.forEach(toggleAll);
  //toggle(root.children[1]);
  //toggle(root.children[1].children[2]);

  update(root);
}(dat);

function update(source) {
  var duration = d3.event && d3.event.altKey ? 5000 : 500;

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse();

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 180; });

  // Update the nodes…
  var node = vis.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("svg:g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", function(d) { toggle(d); update(d); });

  nodeEnter.append("svg:circle")
      .attr("r", 1e-6)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; })
      .append("svg:title")                                                                      //On mouseover, view attr array with ',' replaced with \n
        .text(function(d) { return d.attr.toString().replace(/,/g , "\n") });

  nodeEnter.append("svg:text")
      .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
      .attr("dy", ".35em")
      .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.name; })
      .style("fill-opacity", 1e-6);

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

  nodeUpdate.select("circle")
      .attr("r", 4.5)
      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

  nodeUpdate.select("text")
      .style("fill-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

  nodeExit.select("circle")
      .attr("r", 1e-6);

  nodeExit.select("text")
      .style("fill-opacity", 1e-6);

  // Update the links…
  var link = vis.selectAll("path.link")
      .data(tree.links(nodes), function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("svg:path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      })
    .transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

// Toggle children.
function toggle(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
}

}


function ev_showtree_click() { //gets called when button is clicked
  jdoajax([],"");
}


)


CSS =: 0 : 0
.node circle {
  cursor: pointer;
  fill: #fff;
  stroke: steelblue;
  stroke-width: 1.5px;
}

.node text {
  font-size: 11px;
}

path.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
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

)