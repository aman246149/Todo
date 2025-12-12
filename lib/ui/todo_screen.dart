import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/bloc/todo.dart';
import 'package:todo/bloc/todo_state.dart';
import 'package:todo/model/todo_hive.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    context.read<Todo>().fetchAllTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Todo App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<Todo>().fetchAllTodos();
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<Todo, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TodoSuccess) {
                    if (state.todoList.isEmpty) {
                      return const Center(child: Text('No todos yet'));
                    }
                    return ListView.builder(
                      itemCount: state.todoList.length,
                      itemBuilder: (context, index) {
                        final TodoDb todo = state.todoList[index];
                        return ListTile(
                          leading: todo.image.isNotEmpty
                              ? Image.file(
                                  File(todo.image),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                          title: Text(todo.title),
                          subtitle: Text(todo.description),
                        );
                      },
                    );
                  }
                  if (state is TodoFailure) {
                    return Center(child: Text(state.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                try {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? pickedImage = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      imagePath = pickedImage.path;
                    });
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                child: imagePath != null
                    ? Image.file(File(imagePath!), fit: BoxFit.cover)
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 40),
                            Text('Tap to select image'),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<Todo>().createTodo(
                    TodoDb(
                      title: title.text,
                      description: description.text,
                      image: imagePath ?? '',
                    ),
                  );
                  title.clear();
                  description.clear();
                  setState(() {
                    imagePath = null;
                  });
                },
                child: const Text('Add Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
