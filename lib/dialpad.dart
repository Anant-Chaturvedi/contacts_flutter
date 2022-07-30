import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';




class DialScreen extends StatefulWidget {
  const DialScreen();

  @override
  State<DialScreen> createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.black,
          appBar: AppBar(
            
            
            title: const Text('Dialer', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),),
            
          // shape: StadiumBorder(),
          elevation: 0,
          
           centerTitle: true, backgroundColor: Colors.indigoAccent, systemOverlayStyle: SystemUiOverlayStyle.dark),
          // backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.12,),
                
                Container(
                  child: Stack(
                    children: [
                    Padding(
                 padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.033, left: 8, right: 8),
    
                 child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child:  Container(
                  
      // padding: EdgeInsets.only(top: 15),
                   height: MediaQuery.of(context).size.height*.075,
                ),),
      //           child:   Container(
      // // padding: EdgeInsets.only(top: 15),
      //              height: MediaQuery.of(context).size.height*.075,
      //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey)),),
    ),
    
                      DialPad(
                        
                        dialOutputTextColor: Colors.indigo,
                        buttonColor: Colors.grey.shade200,
                        buttonTextColor: Colors.indigo,
    
                        makeCall: _callNumber,
                          dialButtonColor: Colors.green,
                          dialButtonIconColor: Colors.yellowAccent[100],
                          dialButtonIcon: Icons.call,
                          enableDtmf: true,
                
                          backspaceButtonIconColor: Colors.blue,
                          // makeCall: ,
                          outputMask: '+910000000000',
                
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}


_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}