class Barcode {
    
    int x, y, w, h;
    PImage img;

    Barcode(int _x, int _y, int _w, int _h){
        
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;        
    }
    
    void draw() {
       
       clip(this.x, this.y, 266, this.h);
       image(this.img, this.x, this.y, this.w, this.h);
    }
    
    void retrieve(String text, String codetype, String imgtype, String rot, String dots, String hexcolor){
        
        String data = "&data=" + text;
        String code = "&code=" + codetype;
        String imagetype = "&imagetype=" + imgtype;
        String rotation = "&rotation=" + rot;
        String dpi = "&dpi=" + dots;
        String strpcolor = "&color=" + hexcolor;
        
        String url = "http://barcode.tec-it.com/barcode.ashx?";
        String qsone = "translate-esc=off&unit=Px&bgcolor=FFFFFF&qunit=Mm&quiet=0&modulewidth=5&download=true";
        String qstwo = data + code + dpi + imagetype + rotation + strpcolor;
        String querystring = qsone + qstwo;
        //println(url + querystring);
        this.img = loadImage(url + querystring, imgtype);        
    }
}
