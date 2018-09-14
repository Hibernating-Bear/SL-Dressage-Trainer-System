//Silent Dressage HUD Display Module
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
//and let the original author if you do make changes.


//Global Variables

//Output HorScale, VertScale, HozOffset, VertOffset Data
list blank = [0.42, 0.0545, 0.28004, 0.25912];
list fig8B = [0.42, 0.0545, 0.28004, 0.19869];
list fig8J = [0.42, 0.0545, 0.28004, 0.13826];
list slaE = [0.42, 0.0545, 0.28004, 0.07783];
list slaF = [0.42, 0.0545, 0.28004, 0.0174];
list cirC = [0.42, 0.0545, 0.28004, -0.04303];
list cirD = [0.42, 0.0545, 0.28004, -0.10346];
list cirG = [0.42, 0.0545, 0.28004, -0.16389];
list cirH = [0.42, 0.0545, 0.28004, -0.22432];
list lineC = [0.42, 0.0545, 0.28004, -0.28475];
list lineD = [0.42, 0.0545, 0.28004, -0.34518];
list lineG = [0.42, 0.0545, 0.28004, -0.40561];
list lineH = [0.42, 0.0545, 0.28004, -0.46604];



//Other Variables
list curOutput = [];
integer indexNum = 1;

//Display Function
setDisplay(string output){

  if (output == "fig8B") {
    llScaleTexture(llList2Float(fig8B,0), llList2Float(fig8B,1), ALL_SIDES);
    llOffsetTexture(llList2Float(fig8B,2), llList2Float(fig8B,3), ALL_SIDES); 
  }
  else if (output == "fig8J") {
    llScaleTexture(llList2Float(fig8J,0), llList2Float(fig8J,1), ALL_SIDES);
    llOffsetTexture(llList2Float(fig8J,2), llList2Float(fig8J,3), ALL_SIDES);   
  }
  else if (output == "slaE") {
    llScaleTexture(llList2Float(slaE,0), llList2Float(slaE,1), ALL_SIDES);
    llOffsetTexture(llList2Float(slaE,2), llList2Float(slaE,3), ALL_SIDES);
  }
  else if (output == "slaF") {
    llScaleTexture(llList2Float(slaF,0), llList2Float(slaF,1), ALL_SIDES);
    llOffsetTexture(llList2Float(slaF,2), llList2Float(slaF,3), ALL_SIDES);
  }
  else if (output == "cirC") {
    llScaleTexture(llList2Float(cirC,0), llList2Float(cirC,1), ALL_SIDES);
    llOffsetTexture(llList2Float(cirC,2), llList2Float(cirC,3), ALL_SIDES);
  }
  else if (output == "cirD") {
    llScaleTexture(llList2Float(cirD,0), llList2Float(cirD,1), ALL_SIDES);
    llOffsetTexture(llList2Float(cirD,2), llList2Float(cirD,3), ALL_SIDES);
  }
  else if (output == "cirG") {
    llScaleTexture(llList2Float(cirG,0), llList2Float(cirG,1), ALL_SIDES);
    llOffsetTexture(llList2Float(cirG,2), llList2Float(cirG,3), ALL_SIDES);
  }
  else if (output == "cirH") {
    llScaleTexture(llList2Float(cirH,0), llList2Float(cirH,1), ALL_SIDES);
    llOffsetTexture(llList2Float(cirH,2), llList2Float(cirH,3), ALL_SIDES);
  }
  else if (output == "lineC") {
    llScaleTexture(llList2Float(lineC,0), llList2Float(lineC,1), ALL_SIDES);
    llOffsetTexture(llList2Float(lineC,2), llList2Float(lineC,3), ALL_SIDES);
  }
  else if (output == "lineD") {
    llScaleTexture(llList2Float(lineD,0), llList2Float(lineD,1), ALL_SIDES);
    llOffsetTexture(llList2Float(lineD,2), llList2Float(lineD,3), ALL_SIDES);
  }
  else if (output == "lineG") {
    llScaleTexture(llList2Float(lineG,0), llList2Float(lineG,1), ALL_SIDES);
    llOffsetTexture(llList2Float(lineG,2), llList2Float(lineG,3), ALL_SIDES);
  }
  else if (output == "lineH") {
    llScaleTexture(llList2Float(lineH,0), llList2Float(lineH,1), ALL_SIDES);
    llOffsetTexture(llList2Float(lineH,2), llList2Float(lineH,3), ALL_SIDES);
  }
  else if (output == "blank") {
    llScaleTexture(llList2Float(blank,0), llList2Float(blank,1), ALL_SIDES);
    llOffsetTexture(llList2Float(blank,2), llList2Float(blank,3), ALL_SIDES);
  }

}


//Main Script
default
{ 
    state_entry() {
      setDisplay ("blank");
    }

    
    on_rez(integer start_param)
    {
        llResetScript();
        setDisplay ("blank");
    }
    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        curOutput = llParseString2List(msg, ["|"],[]);
        if ((integer)llList2String(curOutput, 0) == indexNum){
          setDisplay(llList2String(curOutput, 1));
        }
    }
}
