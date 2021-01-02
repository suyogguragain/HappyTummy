import 'package:flutter/material.dart';

class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double billAmount = 0, tipPercent = 5, people = 1, tip = 0, totalBill = 0;

  void tipPercentIncrement(){
    setState(() {
      tipPercent++;
    });
  }

  void peopleIncrement(){
    setState(() {
      people++;
    });
  }

  void tipPercentDecrement(){
    setState(() {
      tipPercent--;
    });
  }

  void peopleDecrement(){
    setState(() {
      people--;
    });
  }

  void claculate(){
    setState(() {
      print(billAmount);
      print(tipPercent);
      if(people == 1){
        tip = billAmount*(tipPercent/100);
        totalBill = billAmount + tip;
      }else{
        tip = billAmount*(tipPercent/100);
        tip = tip/people;
        totalBill = billAmount/people + tip;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading:  true,
        title: Text("HappyTummy" ,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PermanentMarker",
            fontSize:  32.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/ht.png", width: 100,height: 100,),
              SizedBox(height: 12,),
              Text("Tip Calculator", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0,color: Colors.black),),
              SizedBox(height: 4,),
              TextField(
                onChanged: (val){
                  billAmount = double.parse(val);
                },
                decoration: InputDecoration(hintText: "Bill",hintStyle: TextStyle(fontSize: 25,color: Colors.black54),),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text("Tip %",style: TextStyle(fontSize: 25.0,color: Colors.black),),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(onTap: () {
                        tipPercentDecrement();
                      }, child: Icon(Icons.remove_circle, size: 30)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("$tipPercent %",style: TextStyle(fontSize: 20.0,color: Colors.black),),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(onTap: () {
                        tipPercentIncrement();
                      }, child: Icon(Icons.add_circle,size: 30))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text("No.of People",style: TextStyle(fontSize: 25.0,color: Colors.black),),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(onTap: () {
                        peopleDecrement();
                      }, child: Icon(Icons.remove_circle,size: 30)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("$people",style: TextStyle(fontSize: 20.0,color: Colors.black),),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(onTap: () {
                        peopleIncrement();
                      }, child: Icon(Icons.add_circle,size: 30,))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  if(billAmount > 0){
                    claculate();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 32),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text("Calculate", style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),),
                ),
              ),
              SizedBox(height: 36,),
              tip != 0 ? Text(people == 1 ? "Tip : ${tip.toStringAsFixed(2)}": "Tip Per Person : Rs. ${tip.toStringAsFixed(2)}",style: TextStyle(fontSize: 28),) : Container(),
              SizedBox(height: 8,),
              totalBill != 0 ? Text(people == 1 ? "Total : ${totalBill.toStringAsFixed(2)}": "Total Per Person : Rs.${totalBill.toStringAsFixed(2)}",style: TextStyle(fontSize: 28)) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
