import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  void _addTask(){
    if(_controller.text.trim().isNotEmpty){
      FirebaseFirestore.instance.collection('todos').add({
        "title" : _controller.text,
      });
    }

  }
  void onDelete(String id){
    FirebaseFirestore.instance.collection('todos').doc(id).delete();

  }
  Widget _buildBody(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type Here",
                ),
              ),
            ),
            TextButton(
                onPressed: (){
                  _addTask();
                  _controller.clear();
                },
                child: Text('Add Task')),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("todos").snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }else{
                return Expanded(
                  child: ListView(
                    children:
                      snapshot.data!.docs.map((document){
                        return Dismissible(
                          key: Key(document.id),
                          onDismissed: (direction){
                            onDelete(document.id);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          child: ListTile(
                            title: Text(document["title"]),),
                        );
                      }).toList(),

                  ),
                );
              }
            }
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('ToDOList'),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody(context),

    );
  }
}
