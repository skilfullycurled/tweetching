import rita.*;
RiLexicon lex = new RiLexicon();

//COLORS
color white = color(255);
color black = color(0);
color drkgray = color(211);
color red = color(255, 0, 0);
color gold = color(255,215,0);
color drkgld = color(189,183,107);

IChing iChing;
int cols = 10;
int rows = 5;
int hexsize = 300;
String[] stopwords; 

int SPACE = 32;

boolean debug = false;

void setup(){
    size(900, 300);
    //size(cols * 50 + 100 + hexsize, rows * 50 + 50);
    //sadly, I cannot clealy instantiate this outside of setup
    stopwords = split(loadStrings("stopwords.txt")[0], ',');
    
    iChing = new IChing();
    iChing.setup(cols, rows, hexsize, stopwords);
    
    if(debug){
        noLoop();
        iChing.oracle.divine();
    }

    frameRate(4);
    textSize(50);
}


void draw(){
    
    background(white);
    
    if(iChing.shuffling){
        iChing.shuffle();
    }
    
    iChing.draw();
}

void keyReleased(){
    
    if(iChing.watched && !iChing.divided){
    
        if(keyCode == SPACE){
            
            if(iChing.complete){
                
                iChing.oracle.divine();
                
            } else if(iChing.shuffling){
                iChing.divide();
                frameRate(60);
            } else {
                frameRate(4);
                iChing.shuffling = true;
                println("PRESS SPACEBAR TO END SHUFFLING");
            }                       
        }
    }
}

void mouseReleased(){
    
    if(!iChing.watched){
                
        iChing.setWatcher(mouseX, mouseY);
                
    } else if(iChing.divided){
        
        if(!iChing.left.isEmpty()) {
            iChing.count(mouseX, mouseY, iChing.left);
        } else if(!iChing.right.isEmpty()){
            iChing.count(mouseX, mouseY, iChing.right);
        } 
    }
}