class Parser {
    
    RiLexicon lexicon;
    String[] stopwords;
    StringList nouns;
    StringList verbs;

    Parser(){
        this.lexicon = new RiLexicon();
        this.stopwords = new String[0];
        this.nouns = new StringList();
        this.verbs = new StringList();
    }
    
    StringList[] parse(List <Status> tweets){
        
        StringList text = this.extractText(tweets);
        StringList cleaned = this.cleanTweets(text);
        StringList onlyVBs = this.filterPOS(cleaned);
        StringList nostops = this.removeStopWords(onlyVBs);
        StringList legitWords = this.realWords(nostops);
        //StringList stems = this.getStems(legitWords); //performs better without
        StringList[] sepperated = this.sepperateNounsAndVerbs(legitWords);
        return sepperated;
    }
    
    StringList extractText(List <Status> tweets){
        
        StringList tweetText = new StringList();

        for(Status tweet : tweets){
        
            boolean retweet = tweet.isRetweet();
            
            if(!retweet){
                String text = tweet.getText();
                tweetText.append(text);
            }
        }
        return tweetText;
    }

    StringList cleanTweets(StringList tweetText){
        
        StringList cleaned = new StringList();
        String[] patterns = {"https?.*?( |$)", //urls
                             "@.*?( |$)", //usermention
                             "#.*?( |$)", //hashtag
                             "[^\\x00-\\x7f-\\x80-\\xad]", //emoticons
                             ".*[0-9].*", //contains numbers e.g. 2legit2quit
                             "[^aeiou]+$"}; //does not contain vowels e.g. brb 
    
        for(String text : tweetText){
            for(String pattern : patterns){
                text = text.replaceAll(pattern, "");
            }
            text = RiTa.stripPunctuation(text).toLowerCase();
            cleaned.append(text);
        }
        return cleaned;
    }
    
    StringList filterPOS(StringList cleanedText){
        
        StringList filtered = new StringList();
        
        for(String text : cleanedText){
            
            String[] tokens = RiTa.tokenize(text);
            String[] tokensPOS = RiTa.getPosTags(tokens, true);
            StringList keep = new StringList();
            
            for(int i = 0; i < tokensPOS.length; i++){
                if(tokensPOS[i] == "n" || tokensPOS[i] == "v"){
                    keep.append(tokens[i]);
                }
            }
            filtered.append(join(keep.array(), " "));
        }
        return filtered;
    }
    
    StringList removeStopWords(StringList verbsAndNouns){
        
        StringList noStopWords = new StringList();
        
        for(String words : verbsAndNouns) {
            
            for(String stopword : this.stopwords){ 
                words = words.replaceAll(stopword, "");
            }
            
            String[] remaining = words.split(" ");
            
            for(int i = 0; i < remaining.length; i++){
                if(remaining[i].length() < 4 || remaining[i].length() > 9){
                    remaining[i] = "";
                }
            }
            noStopWords.append(join(remaining, " "));
        }
        return noStopWords;
    }
    
    StringList realWords(StringList leftovers){
        
        StringList actualWords = new StringList();
        
        for(String words : leftovers){
            String[] tokens = RiTa.tokenize(words);
            if(tokens.length > 0){
                for(String token : tokens){
                    if(this.lexicon.containsWord(token)){   
                        actualWords.append(token);
                    }
                }
            }
        }
        return actualWords;
    }
    
    StringList getStems(StringList words){
        
        String[] fullwords = words.array();
        
        for(int i = 0; i < fullwords.length; i++){
            fullwords[i] = RiTa.stem(fullwords[i], RiTa.PLING);        
        }
        return new StringList(fullwords);
    }
    
    StringList[] sepperateNounsAndVerbs(StringList words){
        
        StringList[] both = new StringList[2];
        StringList nouns = new StringList();
        StringList verbs = new StringList();
        
        for(String word : words){
            
            if(this.lexicon.isVerb(word)){
                verbs.append(word);
            }
            
            if(this.lexicon.isNoun(word)){     
                nouns.append(word);
            }
        }
        both[0] = nouns;
        both[1] = verbs;
        return both;
    }
}
