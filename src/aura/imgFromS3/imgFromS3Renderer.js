({
	// Your renderer method overrides go here
	afterRender :function(cmp,helper){
	        var canvas = cmp.find('myCanvas').getElement();
        console.log('canvas', canvas);
        var ctx = canvas.getContext("2d");
        ctx.moveTo(0, 0);
        ctx.lineTo(200, 10);
        ctx.stroke();
	}
})