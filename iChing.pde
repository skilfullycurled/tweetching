class IChing {
    
    Oracle oracle;
    
    ArrayList <Dot> dots;
    Hand left;
    Hand right;
    Hand selected;
    Hand counted;
    Hand remainder;

    Dot watcher;
    int cycle;
    int round;
    int end;
    
    
    boolean watched;
    boolean shuffling;
    boolean divided;
    boolean counting;
    boolean first;
    boolean lefthand;
    boolean complete;

    IChing(){
        
        this.dots = new ArrayList<Dot>();
        this.left = new Hand(white, black);
        this.right = new Hand(drkgray, black);
        this.selected = new Hand(gold, black);
        this.remainder = new Hand(white, red);
        this.counted = new Hand(white, drkgld);
        
        this.cycle = 1;
        this.round = 1;
        this.end = 6;
        this.complete = false;

        this.watched = false;
        this.shuffling = false;
        this.divided = false;
        this.counting = false;
        this.first = true;
        this.lefthand = false;
        
    }
    //SO HACKY.  SORRY.
    void setup(int cols, int rows, int hexwidth, String[] sw){
        this.oracle = new Oracle();
        this.oracle.parser.stopwords = sw;
        this.oracle.hex = new Hexagram(cols/2 * 50, rows * 50);
        for(int i = 0; i < cols; i++){
           for( int j = 0; j < rows; j++){
               Dot dot = new Dot(i * 50 + 125 + this.oracle.hex.w, j * 50 + 50, 50);
               this.dots.add(dot);
           }
        }
        
        println();
        println("BRING A QUESTION TO MIND THAT IS NOT A YES OR NO QUESTION");
        println("FOR EXAMPLE: SHOW ME AN IMAGE OF DOING ___________");
        println("WHEN YOU ARE FINISHED, CLICK ON ANY DOT TO BEGIN");
        println();
    }
    
    void draw(){

        this.selected.draw();
        this.counted.draw();
        this.remainder.draw();
        this.left.draw();
        this.right.draw();
        this.oracle.hex.draw();

        for(Dot dot : this.dots){
            
            if(dot.left){
                dot.draw(white, black);
            } else if(dot.right){
                dot.draw(drkgray, black);
            }
        }
        
        if(watched){
            watcher.draw(red, black);
        }

    }
    
    void divide(){
        
        this.shuffling = false;

        for(Dot dot: this.dots){
            
            if(dot.left){
                this.left.add(dot);
            } else if(dot.right){
                this.right.add(dot);
            } else {
                println("Something's gone wrong...");
            }
        }
        this.divided = true;
        this.dots.clear();
        this.counting = true;
        //println("Round: " + str(this.round) + " " + "Cycle:" + str(this.cycle));
        println("CLICK ON ANY WHITE DOT TO BEGIN COUNTING");
        println("THEN CLICK ON THE REST OF THE WHITE DOTS IN GROUPS OF FOUR");
    }
    
    void count(int mx, int my, Hand hand){
        
        for(Dot dot : hand){
            if(dot.clicked(mx, my)){
                if(this.first){
                    this.remainder.add(dot);
                    this.first = false;
                } else {
                    this.selected.add(dot);
                }
                
                hand.remove(dot);
                break; //OUT OF FOR LOOP
            }
        }

        if(selected.size() == 4){
            this.counted.addAll(selected);
            this.selected.clear();
            this.check(hand);
        }
    }
    
    void check(Hand hand){

        if(hand.size() <= 4){

            if(!lefthand){
               println("NOW CLICK ON ANY OF THE GREY DOTS IN GROUPS OF FOUR");
            }
            
            this.remainder.addAll(hand);
            hand.clear();
            lefthand = !lefthand;
        }
        
        if(this.left.isEmpty() && this.right.isEmpty()){
            this.nextRound();
         } else {
             //println("NOW CLICK ON ANY OF THE GREY DOTS IN GROUPS OF FOUR");
         }
    }
    
    void nextRound(){
        if(!boolean(cycle%3)){
            println();
            println("ROUND " + str(this.round) + " COMPLETE");
            println();
            println("COUNT: " + str(this.counted.size()) + " REMAINDER: " + str(this.remainder.size()));
            int line = int(this.counted.size()/4);
            this.oracle.hex.addLine(line);
            this.dots.addAll(remainder);
            this.remainder.clear();
            
            if(this.round == this.end){
                this.end();
            } else {
                println("BEGIN NEXT ROUND");
                this.cycle = 1;
                this.round++;
            }
            
        } else {
            
            this.cycle++;
        }
                
        this.dots.addAll(this.counted);

        for(Dot dot : this.dots){
            dot.reset();            
        }
        
        this.counted.clear();
        this.divided = false;
        this.counting = false;
        this.first = true; 

        if(!this.complete){
            println();
            println("ROUND: " + str(this.round) + " " + "CYCLE: " + str(this.cycle));
            println("PRESS SPACEBAR TO BEGIN SHUFFLING");
        }
    }
    
    void end(){
        println("PROCESS COMPLETE");
        println();
        this.complete = true;
        this.remainder.clear(); //hacky, should put elsewhere
        println("PRESS SPACEBAR TO RECEIVE DIVINATION");    
    }

    void shuffle(){
        for(Dot dot :  this.dots){
            dot.flip();
        }
    }
    
    void setWatcher(int mx, int my){
        for (Dot dot : this.dots){
            if(dot.clicked(mx, my)){
                dot.watcher = true;
                this.watcher = dot;
                this.dots.remove(dot);
                this.watched = true;
                break;
            }
        }
        println("WATCHER SELECTED");
        println();
        println("ROUND: " + str(this.round) + " " + "CYCLE: " + str(this.cycle));
        println("PRESS SPACE BAR TO SHUFFLE DOTS");
    }
}
