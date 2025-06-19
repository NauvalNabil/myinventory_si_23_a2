import 'package:flutter/material.dart';
import 'package:myinventory_si_23_a2/buatkardus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16002F),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 125, 125, 174),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10)
          )
        ),
        title: Row(
          children: [
            Container(
            width: 45,
            height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 114, 54),
                shape: BoxShape.circle
              ),
                child: Icon(Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
            ),
           
           SizedBox(width: 10,),
           Text ("Selamat datang, Username", 
              style: TextStyle (
                color: Colors.white,
                fontSize: 18,

              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16,),
        child: Row(          
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context)=>Buatkardus()),
                );
              },
              child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 114, 54),
                borderRadius: BorderRadius.circular(10),
              ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.add, color: Colors.white,size: 40,),                 
                  ],
                ),
              ),
            ),

            SizedBox(width: 16,),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>Buatkardus()),
                );
              },
              child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 114, 54),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(Icons.format_list_bulleted, color: Colors.white,size: 35,),
                  ],
                ),
              ),
            ),
            
            
          ],
        ),
      ),
      
      

    );
  }
}

