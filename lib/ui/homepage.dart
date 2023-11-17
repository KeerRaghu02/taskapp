import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:finalkeerflutproj/controllers/task_controller.dart';
import 'package:finalkeerflutproj/services/notification_services.dart';
import 'package:finalkeerflutproj/services/theme_services.dart';
import 'package:finalkeerflutproj/ui/add_task_bar.dart';
import 'package:finalkeerflutproj/ui/theme.dart';
import 'package:finalkeerflutproj/ui/widgets/button.dart';
import 'package:finalkeerflutproj/ui/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate= DateTime.now();

  final _taskController=Get.put(TaskController());
  late NotifyHelper notifyHelper; // Initialize the notifyHelper variable

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();// Initialize the notifyHelper object
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addtaskBar(),
          _adddateBar(),
          SizedBox(height:10,),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child:Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,

            itemBuilder: (_,index) {
              print(_taskController.taskList.length);
              // print(_taskController.taskList);
              Task task = _taskController.taskList[index];
              print(task.completedFor);
              if (task.repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      _showBottomSheet(context, task);
                                    },
                                    child: TaskTile(task)
                                )
                              ],
                            )
                        )
                    ));
              }
              if(task.date==DateFormat('dd/MM/yyyy').format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      _showBottomSheet(context, task);
                                    },
                                    child: TaskTile(task)
                                )
                              ],
                            )
                        )
                    ));

              }else{
                return Container();
              }

            });
      }),
    );
  }

  _showBottomSheet(BuildContext context,Task task){
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top:4),
          height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.24:
          MediaQuery.of(context).size.height*0.32,
          color:Get.isDarkMode?darkgreyclr:Colors.white,
          child: Column(
            children: [
              Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color:Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
                  )
              ),
              Spacer(),
              task.isCompleted==1
                  ?Container()
                  :_bottomSheetButton(
                label: "Task completed",
                onTap: (){
                  _taskController.markTaskCompleted(task.id!, task.completedFor!+","+_selectedDate.toString());
                  Get.back();
                },
                clr: primaryclr,
                context: context,
              ),

              _bottomSheetButton(
                label: "Delete Task",
                onTap: (){
                  _taskController.delete(task);

                  Get.back();
                },
                clr: Colors.red[300]!,
                context: context,
              ),
              SizedBox(height: 20,
              ),
              _bottomSheetButton(
                label: "Close",
                onTap: (){
                  Get.back();
                },
                clr: Colors.white,
                isClose:true,
                context: context,
              )
            ],
          ),
        )
    );
  }
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,
  }){
    return GestureDetector(
        onTap:onTap,
        child:Container(
            margin:const EdgeInsets.symmetric(vertical:4),
            height: 55,
            width:MediaQuery.of(context).size.width*0.9,

            decoration:BoxDecoration(
              border:Border.all(
                  width:2,
                  color:isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
              ),
              borderRadius: BorderRadius.circular(20),
              color:isClose==true?Colors.transparent:clr,
            ),
            child:Center(
              child: Text(
                label,
                style:isClose?titleStyle:titleStyle.copyWith(color:Colors.white),
              ),
            )
        )
    );
  }
  _adddateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryclr,
        dateTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: TextStyle(
          fontSize: 16,  // Adjusted font size to 20
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: TextStyle(
          fontSize: 14,  // Adjusted font size to 20
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date){
          setState((){
            _selectedDate=date;
          });
        },
      ),
    );
  }
  _addtaskBar(){
    return Container(
      margin: const EdgeInsets.only(left:2,right:11,top:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin:const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome to the app!",
                  style: subHeadingStyle,
                ),
                SizedBox(height:5),
                Text("Today:",
                  style:headingStyle,),
                SizedBox(height:5),
              ],

            ),

          ),

          MyButton(label: "+ Add Task", onTap: ()async{
            await Get.to(()=>AddTaskPage());
            _taskController.getTasks();
          }
          ),
        ],
      ),
    );

  }
  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme");
        },
        child: Icon(Get.isDarkMode? Icons.wb_sunny_outlined:Icons.nightlight_round,
            size: 20,
            color:Get.isDarkMode?Colors.white:Colors.black
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/pic.jpg"
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

