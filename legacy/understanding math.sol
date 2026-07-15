pragma solidity >=0.5.0 <0.8.7;

uint8 can equal any value between 0 and 256
2**8= 256 (256 equals the highest unique value possible from uint8) 
can not be set to 256 (255) 255+1=256) x=254 + 1= 255

overlow definition = if a sum value is greater then any possible sums of a unit (8 257+   would remain values 1+ overflow)


not an example of overflow 
    contract Numbers {
    function percent(unit8 a) public pure returns (uint8){
    unit8 a= 255;
    return b; 
    }
    }

example of over flow 
    contract Numbers {
    function add(uint8 a, uint8 a) public pure returns (uint8){
    return a +b;
    }
    }


/// 3.5% as fee on every transaction | stack overflow example 
    contract Numbers {
    function percent(uint16 x) public pure returns (uint){
    //uint r = unit16(2292500); //64276 
    return (x * 35) / 1000 
    }
    }
  
  //explaination 
  //2**16=65535 (rounding down to 65500)
  //x= input 
  //input for x = 65500
  //65500*35= 2292500/1000 = return 64276  (becuase the unit16 is only sum value of 65500 the return is classed down)
  //(x *35) / 1000= return 64%

  /// 3.5% as fee on every transaction | stack overflow solution
    contract Numbers {
    function percent(uint16 x) public pure returns (uint16){
    //uint r = unit16(2292500); //64276 
    return (x * 1000) * 35; //this reduces procision  //2275 cs. (2292.5)
    }
    }
 //written correctly //use safe math
 
  contract Numbers {
  function percent(uint x) public pure returns (uint){
  return (x * 1000) * 35; 
  }
  }













  function balances(address _account) external view returns (uint) {
    return balances[_account];
  }


