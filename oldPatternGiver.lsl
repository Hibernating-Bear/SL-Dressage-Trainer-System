//Silent Dressage Random Pattern Giver
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
// and let the original author if you do make changes.


// Global Variables
//
//Channel to Listen for Commands on
integer channelID = 2;
//Data Lists
list disciplineList = ["Figure 8", 0, "Slalom", 1, "Circle", 2, "Line (Forwards)", 3, "Line (Backwards)", 4];
list figEightLetters = ["B", "J"];
list slalomLetters = ["E", "F"];
list circleLetters = ["C", "D", "G", "H"];
list lineForLetters = ["C", "H"];
list lineBackLetters = ["D", "G"];
list patternGen = [];

//Pattern Generating Function
randomPatternScript(key id) {
   
        list randPattern = [];
        list randLetter = [];
        string pattern = "";
        
        //Randomise Pattern Order 
        randPattern = llListRandomize(disciplineList, 2);
         
        //Randomise Pattern Letters Based on Discipline
        integer p = 0; 
        for (; p < 5; ++p){
            randLetter = [];
            integer pos = (2 * p) + 1;
            //Figure 8 Random
            if (llList2Integer(randPattern, pos) == 0){
                randLetter = llListRandomize(figEightLetters, 1);
                pattern = "Figure 8 from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern]; 
            }
            //Slalom Random
            if (llList2Integer(randPattern, pos) == 1){
                randLetter = llListRandomize(slalomLetters, 1);
                pattern = "Slalom from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern]; 
            }
            //Circle Random
            if (llList2Integer(randPattern, pos) == 2){
                randLetter = llListRandomize(circleLetters, 1);
                pattern = "Circle from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern]; 
            }
            //Line (Forward) Random
            if (llList2Integer(randPattern, pos) == 3){
                randLetter = llListRandomize(lineForLetters, 1);
                pattern = "Line from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern]; 
            }
            //Line (Backward) Random
            if (llList2Integer(randPattern, pos) == 4){
                randLetter = llListRandomize(lineBackLetters, 1);
                pattern = "Line from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern]; 
            }
        }
        
        //Output to Dialog Box & Chat Window
        integer i = 0;
        string patternMessage = "Your Random Pattern is:\n";
        for (; i < 5; ++i){
            patternMessage = patternMessage + "\n" + llList2String(patternGen,i); 
        }
        
        llDialog(id, patternMessage, [], -145);
        llRegionSayTo(id, 0, "\n" + patternMessage );
        
        //Reset Script
        llResetScript();
}


//Main Script
default
{ 
    state_entry() {
        llListen(channelID,"", NULL_KEY, "");
    }

    listen(integer channel, string name, key id, string message) {
        if (message == "getpattern") {
        key id = id;
        randomPatternScript(id);
        }
    }
    
    touch_start(integer num_detected) {
     //   key id = llDetectedKey(0);
     //   randomPatternScript(id); 
    } 
}
