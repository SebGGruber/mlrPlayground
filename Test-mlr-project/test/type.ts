// 資料
var countriesData = [
    { name:"Ireland",  income:53000, life: 78, pop:6378, color: "black"},
    { name:"Norway",   income:73000, life: 87, pop:5084, color: "blue" },
    { name:"Tanzania", income:27000, life: 50, pop:3407, color: "grey" }
 ];
// 建立svg網頁物件
 var svg = d3.select("#hook").append("svg")
       .attr("width", 120)
       .attr("height", 120)
       .style("background-color", "#D0D0D0");
// 從資料建立關聯的svg網頁元素
   svg.selectAll("circle")                  // 建立還不存在的圓形樣板
     .data(countriesData)                   // 綁定資料
   .enter()                                 // 對每個資料......
     .append("circle")                      // 綁定資料列中的......資料到圓形
       .attr("id", function(d) { return d.name })            // 圓形的id為國家名
       .attr("cx", function(d) { return d.income / 1000  })  // 圓形的x坐標位置為收入
       .attr("cy", function(d) { return d.life })            // 圓形的y坐標位置為預期收入
       .attr("r",  function(d) { return d.pop / 1000 *2 })   // 圓形的半徑為國家人口數
       .attr("fill", function(d) { return d.color });        // 給表示不同國家的圓形不同顏色