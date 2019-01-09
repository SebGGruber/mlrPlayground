// // //javascript
// // var dataset = [80,100,56,120,180,30,40,120,160];

// // var svgWidth = 500,svgHeight = 300, barPadding = 5;
// // var barWidth = (svgWidth / dataset.length);

// // var svg = d3.select('svg')
// //     .attr("width",svgWidth)
// //     .attr("height",svgHeight);

// // var barChart = svg.selectAll("rect")
// //     .data(dataset)
// //     .enter()
// //     .append("rect")
// //     .attr("y",function(d){
// //         return svgHeight - d
// //     })
// //     .attr("height",function(d){
// //         return d;
// //     })
// //     .attr("width",barWidth - barPadding)
// //     .attr("transform",function(d,i){
// //         var translate = [barWidth * i, 0];
// //         return "translate("+ translate +")";
// //     });

// // 資料
// var countriesData = [
//     { name:"Ireland",  income:53000, life: 78, pop:6378, color: "black"},
//     { name:"Norway",   income:73000, life: 87, pop:5084, color: "blue" },
//     { name:"Tanzania", income:27000, life: 50, pop:3407, color: "grey" }
//  ];
// // 建立svg網頁物件
//  var svg = d3.select('svg')
//        .attr("width", 120)
//        .attr("height", 120)
//        .style("background-color", "#D0D0D0");
// // 從資料建立關聯的svg網頁元素
//    svg.selectAll("circle")                  // 建立還不存在的圓形樣板
//      .data(countriesData)                   // 綁定資料
//    .enter()                                 // 對每個資料......
//      .append("circle")                      // 綁定資料列中的......資料到圓形
//        .attr("id", function(d) { return d.name })            // 圓形的id為國家名
//        .attr("cx", function(d) { return d.income / 1000  })  // 圓形的x坐標位置為收入
//        .attr("cy", function(d) { return d.life })            // 圓形的y坐標位置為預期收入
//        .attr("r",  function(d) { return d.pop / 1000 *2 })   // 圓形的半徑為國家人口數
//        .attr("fill", function(d) { return d.color }); 



d3.json("japan.json", function (topodata) {//載入JSON檔案
    var features = topojson.feature(//從GeoJSON中取出日本地形
        topodata,
        topodata.objects["japan"]
    ).features;
    var path = d3.geo.path().projection(
        d3.geo.mercator()
            .center([138, 37])	//指定為日本經緯度位置
            .scale(6000) 		//放大至符合圖形大小
    );
    d3.select("svg")
        .selectAll("path")	// 建立還不存在的路徑物件樣板
        .data(features)		// 綁定日本地形資料
        .enter()		// 對所有的物件.....
        .append("path")		// 插入路徑物件
        .attr("d", path);	// 路徑物件的路徑依照日本經緯度位置填入地形資料
});

//需先引入Shapefile庫
shapefile.open("japan.shp")		//載入日本的Shapefile檔案
    .then(source => source.read()
        .then(function log(result) {	//若Shapefile載入完畢
            if (result.done) return;
            console.log(result.value);	//印出載入到的地理資訊
            //下同
        }))
    .catch(error => console.error(error.stack));