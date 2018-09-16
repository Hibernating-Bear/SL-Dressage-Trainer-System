//Silent Dressage Random Pattern Giver
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
//and let the original author if you do make changes.

//
// Global Variables
//
//Channel to Listen for Commands on
integer channelID;
//Command to Listen for
string commandName;
//Enabling of Features
integer touchEnabled;
integer commandEnabled;
integer displayChat;
integer displayPopup;
//HUD Broadcast System
integer hudLinkEnabled;
integer hudChannel = -2784831;
string hudLoc;
string hudID;
string userID;
string hudTransmit;
//Notecard Configuration Variables
integer line;
string configFile = "patternGiver.cfg";
key readLineID;
integer loaded = FALSE;
//Data Lists
list disciplineList = ["Figure 8", 0, "Slalom", 1, "Circle", 2, "Line (Forwards)", 3, "Line (Backwards)", 4];
list figEightLetters = ["B", "J"];
list slalomLetters = ["E", "F"];
list circleLetters = ["C", "D", "G", "H"];
list lineForLetters = ["C", "H"];
list lineBackLetters = ["D", "G"];
//Other Global Variables
key idA;



//Initialisation 
init () {
    
    // make sure the file exists and is a notecard
    if(llGetInventoryType(configFile) != INVENTORY_NOTECARD)
    {
        // notify owner of missing file
        llOwnerSay("Missing inventory Notecard: " + configFile);
        return; // don't do anything else
    }
 
    // initialize to start reading from first line
    line = 0;
 
    // read the first line
    readLineID = llGetNotecardLine(configFile, line++);
 
}

string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index, -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}

string uniqueUserID(key id) {
    string name = llKey2Name(id);
    string nameID = (string)id;
    string lastName = right(name, " ");
    string uniqueNum = llGetSubString(nameID, 0, 7);
    string first = llGetSubString(name, 0, 0);
    string second = llGetSubString(lastName, 0, 0);
    string firstSecond = uniqueNum + first + second;
    return firstSecond;
}



//Pattern Generating Function
randomPatternScript(key id) {
        list patternGen = [];
        list randPattern = [];
        list randLetter = [];
        hudTransmit = hudID + "|";
        string pattern = "";
        integer i = 0;
        string patternMessage = ""; 
        //Randomise Pattern Order 
        randPattern = llListRandomize(disciplineList, 2);
         
        //Randomise Pattern Letters Based on Discipline
        integer p = 0; 
        for (p=0; p < 5; ++p){
            randLetter = [];
            integer pos = (2 * p) + 1;
            //Figure 8 Random
            if (llList2Integer(randPattern, pos) == 0){
                randLetter = llListRandomize(figEightLetters, 1);
                pattern = "Figure 8 from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern];
                hudTransmit = hudTransmit + "fig8|" + llList2String(randLetter, 0) + "|";
            }   
            //Slalom Random
            if (llList2Integer(randPattern, pos) == 1){
                randLetter = llListRandomize(slalomLetters, 1);
                pattern = "Slalom from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern];
                hudTransmit = hudTransmit + "sla|" + llList2String(randLetter, 0) + "|"; 
            }
            //Circle Random
            if (llList2Integer(randPattern, pos) == 2){
                randLetter = llListRandomize(circleLetters, 1);
                pattern = "Circle from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern];
                hudTransmit = hudTransmit + "cir|" + llList2String(randLetter, 0) + "|"; 
            }
            //Line (Forward) Random
            if (llList2Integer(randPattern, pos) == 3){
                randLetter = llListRandomize(lineForLetters, 1);
                pattern = "Line from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern];
                hudTransmit = hudTransmit + "line|" + llList2String(randLetter, 0) + "|"; 
            }
            //Line (Backward) Random
            if (llList2Integer(randPattern, pos) == 4){
                randLetter = llListRandomize(lineBackLetters, 1);
                pattern = "Line from " + llList2String(randLetter, 0);
                patternGen = (patternGen=[]) + patternGen + [pattern];
                hudTransmit = hudTransmit + "line|" + llList2String(randLetter, 0) + "|"; 
            }
        }
        
        //Output to Dialog Box & Chat Window
        i = 0;
        patternMessage = "Your Random Pattern is:\n";
        for (; i < 5; ++i){
            patternMessage = patternMessage + "\n" + llList2String(patternGen,i); 
        }
        
        if (displayPopup == TRUE) {
            llDialog(id, patternMessage, [], -145);
        }
        if (displayChat == TRUE) {
            llRegionSayTo(id, 0, "\n" + patternMessage );
        }
        if (hudLinkEnabled == TRUE) {
            llSay(hudChannel, hudTransmit);
            llSleep(0.5); 
            llSay(hudChannel, hudTransmit);
            llSleep(0.5);  
            llSay(hudChannel, hudTransmit);
        }
        
}


//Main Script
default
{ 
    state_entry() {
        idA = llGetOwner();
        init();
        key id = llGetOwner();        
    }

    
     on_rez(integer start_param)
    {
        llResetScript();    
    }
    
    listen(integer channel, string name, key id, string message) {
        if (llToLower(message) == "hudname"){
            llOwnerSay("HUD Link set to: "+ hudID);    
        }
        if (llToLower(message) == "settings"){
            string commandStatus;
            string touchStatus;
            // Tell Owner What was Loaded
            if(commandEnabled == TRUE){
                commandStatus = "Enabled";
            }
            else {
                commandStatus = "Disabled";
            }
            if(touchEnabled == TRUE){
                touchStatus = "Enabled";
            }
            else {
                touchStatus = "Disabled";
            }
             llRegionSayTo(id, 0, "\nCurrent Settings\n\nTouch Status: " + touchStatus + "\nCommand Status: " + commandStatus + "\nCommand Channel: " + (string)channelID + "\nPattern Command: " + commandName + "  ");
        }
        if (commandEnabled == TRUE) {   
            if (llToLower(message) == llToLower(commandName)) {
                key id = id;
                randomPatternScript(id);
            }
        }
        else{
            return; 
        }
    }
    
    touch_start(integer num_detected) {
        if (touchEnabled == TRUE) {
            key id = llDetectedKey(0);
            randomPatternScript(id); 
        }
        else{
            return;    
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY) llResetScript();
        else if(change & CHANGED_OWNER) llResetScript();
    }
    dataserver(key request_id, string data)
    {
        if(request_id == readLineID){
            if(data!=EOF){
                list lList=llParseString2List(data,[" = "," "],[]);
                if(llList2String(lList,0)=="#") {}//Ignore
                else if(llList2String(lList,0) == "commandEnabled"){
                    if(llToLower(llList2String(lList,1))=="true")
                        commandEnabled=TRUE;
                    else
                        commandEnabled=FALSE;
                }else if(llList2String(lList,0) == "channelID"){
                    channelID = llList2Integer(lList,1);
                
                }else if(llList2String(lList,0) == "commandName"){
                    commandName=llList2String(lList,1);
                }else if(llList2String(lList,0) == "touchEnabled"){
                    if(llToLower(llList2String(lList,1)) == "true")
                        touchEnabled=TRUE;
                    else
                        touchEnabled=FALSE;
                } else if(llList2String(lList,0) == "displayChat"){
                    if(llToLower(llList2String(lList,1)) == "true")
                        displayChat = TRUE;
                    else
                        displayChat = FALSE;
                } else if(llList2String(lList,0) == "displayPopup"){
                    if(llToLower(llList2String(lList,1)) == "true"){
                        displayPopup = TRUE;
                    }else
                        displayPopup = FALSE;
                } else if(llList2String(lList,0) == "hudLinkEnabled"){
                    if(llToLower(llList2String(lList,1))=="true"){
                        hudLinkEnabled=TRUE;
                    }else
                        hudLinkEnabled=FALSE;
                }  else if(llList2String(lList,0) == "hudLoc") {
                    if(llToLower(llList2String(lList,1)) == "local"){
                        hudLoc="local";
                    } else if(llToLower(llList2String(lList,1)) == "remote"){
                        hudLoc = "remote";
                    } else if(llToLower(llList2String(lList,1)) == "hud"){
                        hudLoc="hud";
                    }
                } else if(llList2String(lList,0) == "hudID"){
                    if(hudLoc == "remote"){
                        hudID = llList2String(lList,1);
                    }else{
                        userID=uniqueUserID(idA);
                        hudID=userID+"HUD";
                    }
                }
                readLineID = llGetNotecardLine(configFile,line++);
            } else {
                string output="";
                if(hudLinkEnabled){
                    if(hudLoc=="remote"){
                        output="HUD Channel: "+hudID;
                    }
                }
                if(commandEnabled){
                    output+="\nCommand Set To: /"+ (string)channelID+" "+commandName;
                }
                llSetText(output, <1,1,1>,1);
                llListen(channelID, "", "", "");
                llOwnerSay("System Initialized");
            }
        }
 
    } 
    
}
