class Dot {
    
    int x, y, d;
    boolean left, right, watcher, selected, remainder;
    String text;
    
    Dot(int xpos, int ypos, int diameter){
        
        this.x = xpos;
        this.y = ypos;
        this.d = diameter;
        this.left = random(1) > 0.5;
        this.right = !this.left;
        this.watcher = false;
        this.selected = false;
        this.remainder= false;
    }
    
    void draw(color fill, color stroke){

        stroke(stroke);
        fill(fill);
        ellipse(this.x, this.y, this.d, this.d);
    }
    
    void flip(){
        if(random(1) > 0.5){
            this.left = !this.left;
            this.right = !this.right;
        }
    }
    
    void reset(){
        this.left = random(1) > 0.5;
        this.right = !this.left;
    }
    
    boolean clicked(int mx, int my) {
        
      float disX = this.x - mx;
      float disY = this.y - my;
      
      if (sqrt(sq(disX) + sq(disY)) < this.d/2 ) {
        return true;
      } else {
        return false;
      }
   }

}
