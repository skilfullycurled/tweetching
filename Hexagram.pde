class Hexagram extends ArrayList<String>{
    
    int w;
    int h;
    int place;
    int fill;
    String[] lines;
    int[][] hexgrid;
    String text;
    boolean retrieved;
    Barcode barcode;
    
    Hexagram(int _w, int _h){
        
        this.w = _w;
        this.h = _h;
        this.place = 0;
        this.barcode = new Barcode(46, 28, 313, 242);
        this.fill = 100;
        this.retrieved = false;
        
        this.lines = new String[6];
        for(int i = 0; i < 6; i++){
            this.add("");
        }
        
        this.hexgrid = new int[8][8];
        int count = 1;
        for(int i = 0; i < 8; i++){
            for(int j = 0; j < 8; j++){
                hexgrid[i][j] = count;
                count ++;   
            }
        }
    }
    
    void draw(){
        noFill();

        if(this.retrieved){
            textSize(90);
            fill(0);
            textAlign(CENTER);
            text("#" + this.text, 600, 175);
            this.barcode.draw();
            
        } else {
            
            fill(this.fill);
            text(this.get(0), 45, 270);
            text(this.get(1), 45, 230 -1);
            text(this.get(2), 45, 190-2);
            text(this.get(3), 45, 150-3);
            text(this.get(4), 45, 110-4);
            text(this.get(5), 45, 65);
        }

    }
    
    void addLine(int num){
        String[] b = binary(num).split("");
        String line = join(subset(b, b.length - 6), " ");
        this.set(place, line);
        
        if(num == 7 || num == 6){
            this.lines[place] = "1";
        } else {
            this.lines[place] = "0";
        }
        
        println("LINE: " + str(num) + " (COUNT/4) BINARY: " + line);
        println();
        this.place++;
    }
    
    int getHexNumber(){
        
        String upper = join(subset(this.lines, 3, 3), "");
        String lower = join(subset(this.lines, 0, 3), "");
        
        int row = unbinary(lower);
        int col = unbinary(upper);

        return hexgrid[row][col];
 
    }
    
    void create(String text, String codetype, String imgtype, String rot, String dots, String hexcolor){
        this.text = text;
        this.barcode.retrieve(text.replace(" ", "+"), codetype, imgtype, rot, dots, hexcolor);
        this.retrieved = true;
    }
}
