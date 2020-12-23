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
              SizedBox(height: 8,),
              Text("Tip Calculator"),
              SizedBox(height: 24,),
              TextField(
                onChanged: (val){
                  billAmount = double.parse(val);
                },
                decoration: InputDecoration(hintText: "Bill"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text("Tip %"),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(onTap: () {
                        tipPercentDecrement();
                      }, child: Icon(Icons.remove_circle)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("$tipPercent %"),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(onTap: () {
                        tipPercentIncrement();
                      }, child: Icon(Icons.add_circle))
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
                  Text("People"),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(onTap: () {
                        peopleDecrement();
                      }, child: Icon(Icons.remove_circle)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("$people"),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(onTap: () {
                        peopleIncrement();
                      }, child: Icon(Icons.add_circle))
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
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 22),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text("Calculate", style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                ),
              ),
              SizedBox(height: 16,),
              tip != 0 ? Text(people == 1 ? "Tip : ${tip.toStringAsFixed(2)}": "Tip : ${tip.toStringAsFixed(2)} per person",style: TextStyle(fontSize: 18),) : Container(),
              SizedBox(height: 8,),
              totalBill != 0 ? Text(people == 1 ? "Total : ${totalBill.toStringAsFixed(2)}": "Total : ${totalBill.toStringAsFixed(2)} per person",style: TextStyle(fontSize: 18)) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
