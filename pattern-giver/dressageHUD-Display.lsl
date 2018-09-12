//Silent Dressage HUD Display Module
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
//and let the original author if you do make changes.


//Global Variables

//Letter Offset Scale Data
list b = [];
list c = [];
list d = [];
list e = [];
list f = [];
list g = [];
list h = [];
list j = [];

//Discipline Offset Scale Data
list figEight = [];
list line = [];
list slalom = [];
list circle = [];

//Other Variables
list curOutput = [];
integer indexNum = 1;

//Display Function
setDisplay(string discip, string letter){
  
  // Disicpline Output
  if (discip == "Figure 8") {
  
  }
  if (discip == "Slalom") {
  
  }
  if (discip == "Circle") {
  
  }
  if (discip == "Line") {
  
  }
  // Letter Output
  if (letter == "B") {
  
  }
  if (letter == "C") {
  
  }
  if (letter == "D") {
  
  }
  if (letter == "E") {
  
  }
  if (letter == "F") {
  
  }
  if (letter == "G") {
  
  }
  if (letter == "H") {
  
  }
  if (letter == "J") {
  
  }

}


//Main Script
default
{ 
    state_entry() {
    
    }

    
    on_rez(integer start_param)
    {
        llResetScript();        
    }
    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        curOutput = llParseString2List(msg, ["|"],[]);
        if ((integer)llList2String(curOutput, 0) == indexNum){
          setDisplay(llList2String(curOutput, 1), llList2String(curOutput, 2);
        }
    }
}
