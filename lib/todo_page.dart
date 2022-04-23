import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in.dart';
import 'save_widget.dart';
import 'load_widgets.dart';

class ToDoApp extends StatefulWidget {
  ToDoApp({Key? key, this.doesSmile, this.filesContent}) : super(key: key);
  bool? doesSmile;
  List? filesContent;

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> with WidgetsBindingObserver {
  List<String> tasksContents = [];
  final text = '';
  int indexGlobal = 0;
  int title = 0;
  bool first = true;
  int numOfDeletedWidgets = 0;
  late List<Widget> widgetList = [
    toCreate(),
  ];
  List indicesList = [0];
  List<String> texts = [''];
  List<bool> isFirst = [true];

  Color? titleColor;
  Color? textColor;
  List<Color> darkThemeColors = [Colors.black, Colors.lightBlueAccent];
  List<Color> lightThemeColors = [Colors.blue[900]!, Colors.lightBlue];
  List colors = [];
  BoxDecoration background() {
    List colors = widget.doesSmile! ? lightThemeColors : darkThemeColors;
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.5, 0.9],
            colors: [colors[0], colors[1]]));
  }

  List<Color> taskLightColors = [
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.pink
  ];
  List<Color> taskDarkColors = [
    Colors.indigo,
    Colors.white12,
    Colors.indigo,
    Colors.white12
  ];
  BoxDecoration taskBackground() {
    List<Color> colors = widget.doesSmile! ? taskLightColors : taskDarkColors;
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.4, 0.6, 0.9],
          colors: colors,
        ),
        borderRadius: BorderRadius.all(Radius.circular(25)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    createControllers();
    //save(context, titleController, textController, formKey, index, false);
  }

  createControllers() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    //titleController.text = tasksContents[0];
    //print(titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: background(),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CarouselSlider(
              items: widgetList,
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 400,
                  viewportFraction: 0.9),
            ),
          ],
        ),
      ),
    );
  }

  toCreate() {
    titleColor = widget.doesSmile! ? Colors.black : Colors.white;
    return Container(
      decoration: taskBackground(),
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Task',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: titleColor),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            height: 80,
            width: 120,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.blue, Colors.purple]),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: TextButton(
                onPressed: () => toFillPage(justCreated: true),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))))),
          )
        ],
      ),
    );
  }

  void toFillPage(
      {TextEditingController? titleController,
      TextEditingController? textController,
      GlobalKey<FormState>? formKey,
      int index = 0,
      bool justCreated = false,
      bool toChange = false}) {
    if (justCreated) {
      setState(() {
        indexGlobal += 1;
        index = indexGlobal;
      });

      indicesList.add(index);
      isFirst.add(true);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => fillPage(context,
                titleController: titleController,
                textController: textController,
                index: index,
                first: isFirst[index],
                toChange: toChange)));
  }

  Widget fillPage(BuildContext context,
      {TextEditingController? titleController,
      TextEditingController? textController,
      GlobalKey<FormState>? formKey,
      bool? first,
      int index = 0,
      bool toChange = false}) {
    if (!first!) {
      titleController = titleController;
      textController = textController;
      formKey = formKey;
    } else {
      titleController = TextEditingController();
      textController = TextEditingController();
      formKey = GlobalKey<FormState>();
    }

    return Scaffold(
        body: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: 230,
              ),
              Expanded(
                child: TextButton(
                    onPressed: () => save(context, titleController,
                        textController, formKey, index, toChange),
                    child: Icon(Icons.save_outlined)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(100, 20, 100, 0),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task title'),
              maxLength: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Task description'),
              maxLines: 10,
            ),
          )
        ],
      ),
    ));
  }

  void save(BuildContext context, final titleController, final textController,
      final formKey, int index, bool toChange) async {
    if (titleController == null || textController == null) {
      goBack(context, index);
      setState(() {
        indexGlobal -= 1;
        indicesList.removeLast();
      });
      return;
    }
    if (index != 0) {
      setState(() {
        isFirst[index] = false;
      });
    }

    if (titleController.text.isEmpty || textController.text.isEmpty) {
      goBack(context, index);
      setState(() {
        indexGlobal -= 1;
        indicesList.removeLast();
      });

      isFirst.removeLast();
      return;
    }

    if (toChange) {
      update(context, titleController, textController, formKey, index);
      return;
    }

    Navigator.pop(context);

    /*task.saveFile();
    final content = await task.readFile();
    SaveTask.listDir();
    print(content); */
    setState(() {
      texts.add(textController.text);
      tasksContents.add('${titleController.text}[sep]${textController.text}');
      final newWidgetInstance =
          newWidget(titleController, textController, formKey, index);
      widgetList.add(newWidgetInstance);
    });
  }

  void update(BuildContext context, final titleController, final textController,
      final formKey, int index) {
    Navigator.pop(context);
    setState(() {
      widgetList[index] =
          newWidget(titleController, textController, formKey, index);
    });
  }

  void goBack(BuildContext context, int index) {
    Navigator.pop(context);
  }

  Widget newWidget(final titleController, final textController, final formKey,
      final indexReal) {
    String title = titleController.text;
    titleColor = widget.doesSmile! ? Colors.black : Colors.white;
    String text = textController.text;
    textColor = widget.doesSmile! ? Colors.black : Colors.grey[300];
    const maxLenght = 150;

    if (text.characters.length >= maxLenght) {
      text = text.substring(0, maxLenght);
      text += '...';
    }
    if (text.isEmpty) {
      text = 'Task description';
    }
    if (title.isEmpty) {
      title = 'Task title';
    }

    return Container(
      decoration: taskBackground(),
      width: MediaQuery.of(context).size.width - 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 90,
          ),
          TextButton(
              onPressed: () => toFillPage(
                    titleController: titleController,
                    textController: textController,
                    formKey: formKey,
                    toChange: true,
                    index: indexReal,
                  ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  fixedSize: MaterialStateProperty.all(const Size(250, 200))),
              child: Column(
                children: [
                  Text(
                    title.toString(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      text,
                      style: TextStyle(color: textColor),
                    ),
                  )
                ],
              )),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                  height: 80,
                ),
                TextButton(
                  onPressed: () => deleteWidget(indexReal),
                  child: const Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.red,
                  ),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(60, 60))),
                ),
                SizedBox(
                  width: 100,
                ),
                TextButton(
                    onPressed: null,
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.green,
                    ),
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(40, 40)))),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void deleteWidget(int index) {
    index = indicesList.indexOf(index);
    setState(() {
      indicesList.removeAt(index);
      widgetList.removeAt(index);

      if (indicesList.length == 1) {
        indexGlobal = 0;
        isFirst.clear();
        isFirst.add(true);
      }
    });
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('STATE >>>>>>>>> $state');
    await prefs.setStringList('content', tasksContents);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }
}
