import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;


import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

class Oracle {
    
    //SOME DAY MAKE THIS A DICT SO ONE CAN PASS ANY SET OF TOKENS
    String CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET;
    
    ConfigurationBuilder cb;
    Twitter twitter;
    List <Status> tweets;
    Parser parser;
    Hexagram hex;
    StringList nouns;
    StringList verbs;
    StringList hexagrams;

    Oracle(){
        
        this.CONSUMER_KEY = "";
        this.CONSUMER_SECRET = "";
        this.ACCESS_TOKEN =  "";
        this.ACCESS_TOKEN_SECRET = "";
        
        cb = new ConfigurationBuilder();
        cb.setOAuthConsumerKey(CONSUMER_KEY);
        cb.setOAuthConsumerSecret(CONSUMER_SECRET);
        cb.setOAuthAccessToken(ACCESS_TOKEN);
        cb.setOAuthAccessTokenSecret(ACCESS_TOKEN_SECRET);
        
        TwitterFactory tf = new TwitterFactory(cb.build());
        this.twitter = tf.getInstance();
        this.tweets = new ArrayList<Status>();
        this.parser = new Parser();
        
        this.nouns = new StringList();
        this.verbs = new StringList();
        this.hexagrams = new StringList(); 


    }
        
    void searchTwitter() {
                    
        try {
            
            Query query = new Query("a");
            query.setCount(64);
            query.setLang("en");

            QueryResult result = this.twitter.search(query);
    
            this.tweets = result.getTweets();
  
        } catch (TwitterException te) {
            System.out.println("Failed to search tweets: " + te.getMessage());
            System.exit(-1);
        }    
    }
    
    void divine(){
        println();
        println("QUERYING THE ORACLE");
        this.searchTwitter();
        println("PARSING RESULTS");
        StringList[] nounsAndVerbs = this.parser.parse(this.tweets);
        
        this.nouns = nounsAndVerbs[0];
        this.nouns.shuffle();

        this.verbs = nounsAndVerbs[1];
        this.verbs.shuffle();

        this.hexagrams.append(this.nouns);
        this.hexagrams.append(this.verbs);
        this.hexagrams.shuffle();

        println("RETRIEVING HEXAGRAM");
        int hexnum = this.hex.getHexNumber();
        String judgement = this.hexagrams.get(hexnum);
        
        boolean isNoun = lex.isNoun(judgement);
        boolean isVerb = lex.isVerb(judgement);
        boolean isBoth = isNoun && isVerb;
        
        if(isBoth){
            if(random(1) < 0.5) {isNoun = false;} else {isVerb = false;}
        }
        
       if(isVerb){
            judgement = RiTa.getPresentParticiple(RiTa.stem(judgement));
       } else if(isNoun){
            judgement = "the " + judgement;
       }

        this.hex.create(judgement, "Code128", "png", "90", "500", "BDB76B");
        println();
        println("DIVINATION: " + judgement);
    }
}
