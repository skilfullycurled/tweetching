class Hand extends ArrayList<Dot>{
    
    color fill;
    color stroke;
    
    Hand(color fill, color stroke){
        this.fill = fill;
        this.stroke = stroke;
    }
    
    void draw(){
        
        for(Dot stalk : this){
            stalk.draw(fill, stroke);
        }
    }
}
