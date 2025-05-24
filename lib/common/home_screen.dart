import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/screens/users_login_screen.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/app_images.dart';
import 'package:cattlehealthtracker/common/cattle_screen.dart';
import 'package:cattlehealthtracker/common/culling_screen.dart';
import 'package:cattlehealthtracker/common/dashboard_screen.dart';
import 'package:cattlehealthtracker/common/logs_screen.dart';
import 'package:cattlehealthtracker/common/medicines_screen.dart';
import 'package:cattlehealthtracker/common/roles_screen.dart';
import 'package:cattlehealthtracker/common/users_screen.dart';
import 'package:cattlehealthtracker/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  FlutterSecureStorage storage;
  GlobalKey<ScaffoldState> scaffoldKey;
   HomeScreen({required this.storage, required this.scaffoldKey, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> featuresList;
  Widget selectedScreen = DashboardScreen();
  String selectedScreenName =  "Dashboard";
  AuthenticationCubit cubit = GetIt.instance<AuthenticationCubit>();
  Map<String, List<Widget>> featuresMap = {
    "Users": [Icon(Icons.person, color: AppColors.greenColor,), UsersScreen()],
    "Dashboard": [Icon(Icons.dashboard, color: AppColors.greenColor), DashboardScreen()],
    "Cattle": [Icon(MdiIcons.cow, color: AppColors.greenColor), CattleScreen()],
    "Culling": [Icon(Icons.delete_forever, color: AppColors.greenColor), CullingScreen()],
    "Logs": [Icon(Icons.history,color: AppColors.greenColor), LogsScreen()],
    "Medicines": [Icon(Icons.medication_liquid,color: AppColors.greenColor), MedicinesScreen()], 
    "Settings": [Icon(Icons.settings,color: AppColors.greenColor), SettingsScreen()],
    "Roles": [Icon(Icons.group,color: AppColors.greenColor), RolesScreen()],
    "Logout": [Icon(Icons.logout,color: AppColors.greenColor), SizedBox()],

    };
@override
  void initState() {
    // TODO: implement initState
   print("got to home screen");
    super.initState();
  }

// Future<String> getfeatures() async{
//     String? features = await widget.storage.read(key: "features");
//     return features!;
// }
  @override
  Widget build(BuildContext context) {
    Map<String,String> featuresLocalized = {
     "Users": S.of(context).users,
    "Dashboard": S.of(context).dashboard,
    "Cattle": S.of(context).cattle,
    "Culling": S.of(context).culling,
    "Logs": S.of(context).logs,
    "Medicines": S.of(context).medicines, 
    "Settings": S.of(context).settings,
    "Roles": S.of(context).roles,
    "Logout": S.of(context).logout,


    };
    return  FutureBuilder(
      future: widget.storage.read(key: "features"),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator(),),);
        }
        else if(snapshot.hasData){
          featuresList = json.decode(snapshot.data!).cast<String>().toList();
          featuresList.add("Logout");
          print("features list contents $featuresList");
        return Scaffold(
          key: widget.scaffoldKey,
          drawer: Drawer(
            
            backgroundColor: Theme.of(context).brightness == Brightness.light? AppColors.backgroundColorLight: AppColors.backgroundColorDark,
            child: Column(children: [
              
                Padding(
                  padding:  EdgeInsets.only(top: 45.h),
                  child: Image(image: AssetImage(Theme.of(context).brightness == Brightness.light? AppImages.logo_light:AppImages.logo_dark,),
                  width: 130.w,
                  height: 130.h,
                  ),
                ),

                // Divider(),
        
                Expanded(child: ListView.builder(
                  key: Key('drawerListView'),
                  itemCount: featuresList.length,
                  itemBuilder:(context, index) {
                  return GestureDetector(
                    onTap: () async{
                      if(featuresList[index] == "Logout"){
                       await showDialog(context: context, builder:(context) {
                return AlertDialog(
                  // contentPadding: EdgeInsets.only(top: 10.h),
                  actionsAlignment: MainAxisAlignment.center,
                  content: Text(S.of(context).confirmLogout, style: Theme.of(context).textTheme.bodyLarge,),
                  actions: [
                   CustomButton(
                    text: S.of(context).confirm,
                    onTap: () async{
                      await cubit.logout();
                    },
                    ),
                   CustomButton(
                    bgColor: Colors.red,
                    text: S.of(context).cancel,
                   onTap: () {
                     Navigator.of(context).pop();
                     Scaffold.of(context).closeDrawer();
                   },)
                  ],
                );
              },);
                      }
                      else{
                        setState(() {
                          selectedScreen = featuresMap[featuresList[index]]![1];
                          selectedScreenName  = featuresList[index];
                          Scaffold.of(context).closeDrawer();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: featuresList[index] == "Logout"? Border( top: BorderSide(color: Theme.of(context).secondaryHeaderColor), bottom: BorderSide(color: Theme.of(context).secondaryHeaderColor)) :Border( top: BorderSide(color: Theme.of(context).secondaryHeaderColor))
                      ),
                      child: ListTile(
                        title: Text(featuresLocalized[featuresList[index]]!),
                        key: Key(featuresLocalized[featuresList[index]]!),
                        leading: featuresList[index] == "Logout"? BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
                          if(state is LogoutLoadingState){
                            return CircularProgressIndicator(color: AppColors.greenColor,);
                          }
                          return featuresMap[featuresList[index]]![0];
                        },) :featuresMap[featuresList[index]]![0],
                      ),
                    ),
                  );
                },))
            ],),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(featuresLocalized[selectedScreenName]!, style: TextStyle(color: AppColors.greenColor),)),
        
          body: selectedScreen,
        );
        }
        else{
          return Placeholder();
        }
      }
    );
    }
  
}