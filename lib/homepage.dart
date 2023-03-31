import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  var squareStatus = [];

  final List<int> bombLocation = [
    4,
    5,
    6,
    41,
    42,
    43,
    61,
  ];

  bool bombsRevealed=false;
  
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  void restartGame(){
    setState(() {
      bombsRevealed=false;
      for(int i=0; i<numberOfSquares; i++){
        squareStatus[i][1]=false;
      }
    });
  }

  void revealBoxNumbers(int index) {
    if(squareStatus[index][0]!=0){
      setState(() {
        squareStatus[index][1] = true;
      });
    }

    else if(squareStatus[index][0]==0){
      setState(() {
        squareStatus[index][1]=true;

        if(index%numberInEachRow != 0){
          if(squareStatus[index-1][0]==0 && squareStatus[index-1][1]==false){
            revealBoxNumbers(index-1);
          }
          squareStatus[index-1][1]=true;
        }

        if(index%numberInEachRow !=0 && index>=numberInEachRow){
          if(squareStatus[index-1-numberInEachRow][0]==0 && squareStatus[index-1-numberInEachRow][1]==false){
            revealBoxNumbers(index-1-numberInEachRow);
          }
          squareStatus[index-1-numberInEachRow][1]=true;
        }

        if(index>=numberInEachRow){
          if(squareStatus[index-numberInEachRow][0]==0 && squareStatus[index-numberInEachRow][1]==false){
            revealBoxNumbers(index-numberInEachRow);
          }
          squareStatus[index-numberInEachRow][1]=true;
        }

        if(index>=numberInEachRow && index%numberInEachRow!=numberInEachRow-1){
          if(squareStatus[index+1-numberInEachRow][0]==0 && squareStatus[index+1-numberInEachRow][1]==false){
            revealBoxNumbers(index+1-numberInEachRow);
          }
          squareStatus[index+1-numberInEachRow][1]=true; 
        }

        if(index<numberOfSquares-numberInEachRow && index%numberInEachRow!=numberInEachRow-1){
          if(squareStatus[index+1+numberInEachRow][0]==0 && squareStatus[index+1+numberInEachRow][1]==false){
            revealBoxNumbers(index+1+numberInEachRow);
          }
          squareStatus[index+1+numberInEachRow][1]=true; 
        }

        if(index<numberOfSquares-numberInEachRow ){
          if(squareStatus[index+numberInEachRow][0]==0 && squareStatus[index+numberInEachRow][1]==false){
            revealBoxNumbers(index+numberInEachRow);
          }
          squareStatus[index+numberInEachRow][1]=true; 
        }

        if(index<numberOfSquares-numberInEachRow && index%numberInEachRow!=0){
          if(squareStatus[index-1+numberInEachRow][0]==0 && squareStatus[index-1+numberInEachRow][1]==false){
            revealBoxNumbers(index-1+numberInEachRow);
          }
          squareStatus[index-1+numberInEachRow][1]=true; 
        }

      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
            numberOfBombsAround++;
      }

      if(bombLocation.contains(i-numberInEachRow) && i>=numberInEachRow){
        numberOfBombsAround++;
      }

      if(bombLocation.contains(i+1-numberInEachRow)&&i>=numberInEachRow && i%numberInEachRow !=numberInEachRow-1){
        numberOfBombsAround++;
      }

      if(bombLocation.contains(i+1) && i%numberInEachRow != numberInEachRow-1){
        numberOfBombsAround++;
      }

      if(bombLocation.contains(i+1+numberInEachRow) && i % numberInEachRow != numberInEachRow-1 && 
      i<numberOfSquares - numberInEachRow){
        numberOfBombsAround++;
      }

      if(bombLocation.contains(i+numberInEachRow) && i<numberOfSquares-numberInEachRow){
        numberOfBombsAround++;
      }

      if(bombLocation.contains(i-1+numberInEachRow) && i<numberOfSquares-numberInEachRow && i%numberInEachRow != 0){
        numberOfBombsAround++;
      }

      setState((){
        squareStatus[i][0]=numberOfBombsAround; 
      });

    }
  }

void playerLost(){
  showDialog(context: context, builder:(context){
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: const Center(child: Text('YOU LOST', style: TextStyle(color:Colors.white),),),
      actions:[
        MaterialButton(
          color:Colors.grey[100],
          onPressed:(){
            restartGame();
            Navigator.pop(context);
          },
          child:Icon(Icons.refresh)
        )
      ],
    );
  }); 
}

void playerWon(){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor:Colors.grey[700],
      title:const Center(
        child:Text(
          'YOU WIN!', style:TextStyle(color:Colors.white),
        ),
      ),
      actions: [
        Center(
          child:MaterialButton(
            onPressed:(){
              restartGame();
              Navigator.pop(context);
            },
            child:ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:Container(
                color:Colors.grey[300],
                child:const Padding(
                  padding:EdgeInsets.all(5.0),
                  child:Icon(Icons.refresh, size:30)
                )
              )
            ),
          ),
        ),
      ],
    );
  });
}

void checkWinner(){
  int unrevealedBoxes=0;
  for(int i=0; i<numberOfSquares; i++){
    if(squareStatus[i][1]==false){
      unrevealedBoxes++;
    }
  }
  if(unrevealedBoxes==bombLocation.length){
    playerWon();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              height: 150,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bombLocation.length.toString(), style: const TextStyle(fontSize: 40)),
                      const Text('B O M B'),
                    ],
                  ),
                  GestureDetector(
                    onTap: restartGame,
                    child:Card(
                    child:  Icon(Icons.refresh, color: Colors.white, size: 40),
                    color: Colors.grey[700],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('0', style: TextStyle(fontSize: 40)),
                      Text('T I M E'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInEachRow),
                itemBuilder: (context, index) {
                  if (bombLocation.contains(index)) {
                    return MyBomb(
                      revealed: bombsRevealed,
                      function: () {
                        setState((){
                          bombsRevealed=true;
                        });
                        playerLost();
                      },
                    );
                  } else {
                    return MyNumberBox(
                      child: squareStatus[index][0],
                      revealed: squareStatus[index][1],
                      function: () {
                        revealBoxNumbers(index);
                        checkWinner();
                      },
                    );
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Text('C R E A T E D  B Y  W I Z'),
            ),
          ],
        ));
  }
}
