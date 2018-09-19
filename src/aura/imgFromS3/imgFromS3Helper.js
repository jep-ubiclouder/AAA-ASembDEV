({
    setURL: function(cnv) {
    this.superAfterRender();
        console.log('hello from helper');
        var ctx = cnv.getContext('2d');
        ctx.moveTo(0, 0);
        ctx.lineTo(200, 10);
        ctx.stroke();
    }
})