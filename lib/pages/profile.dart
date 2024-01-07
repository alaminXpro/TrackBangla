import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
//import '/blocs/notification_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import '/core/config/config.dart';
import '/pages/edit_profile.dart';
//import '/pages/notifications.dart';
import '/pages/sign_in.dart';
import '/core/utils/next_screen.dart';
import '/widgets/language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{



  


  openAboutDialog (){
    final sb = context.read<SignInBloc>();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30,),
          applicationVersion: sb.appVersion,
        );
      }
    );
  }





  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text('profile').tr(),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.notifications, size: 20), onPressed: (){ 
            //nextScreen(context, NotificationsPage());
            }
          )
        ],
        
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
        children: [
          sb.isSignedIn == false ? GuestUserUI() : UserUI(),

          Text("general setting", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),).tr(),


          SizedBox(height: 15,),
          ListTile(
            title: Text('get notifications').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.notifications, size: 20, color: Colors.white),
            ),
            // trailing:  Switch(
            //     activeColor: Theme.of(context).primaryColor,
            //     value: context.watch<NotificationBloc>().subscribed,
            //     onChanged: (bool) {
            //       context.read<NotificationBloc>().fcmSubscribe(bool);
            //     }),
          ),
          Divider(height: 5,),
          ListTile(
            title: Text('contact us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.mail, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: () async => await launchUrl('mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body=' as Uri),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('language').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.circle, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, const LanguagePopup()),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('rate this app').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.star, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()async=> LaunchReview.launch(androidAppId: sb.packageName, iOSAppId: Config().iOSAppId),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('licence').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.panorama_photosphere, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()=> openAboutDialog(),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('privacy policy').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.lock, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()async{
                if(await canLaunchUrl(Config().privacyPolicyUrl as Uri)){
                launchUrl(Config().privacyPolicyUrl as Uri);
              }
            },
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('about us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.info, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()async{
              if(await canLaunchUrl(Config().ourWebsiteUrl as Uri)){
                launchUrl(Config().ourWebsiteUrl as Uri);
              }
            },
          ),

          Divider(height: 5,),

          ListTile(
            title: Text('Admin').tr(),
            subtitle: Text('Admin subtitle').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.shopping_cart, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()async{
              if(await canLaunchUrl('https://linkedin.com/in/alaminxpro/' as Uri)){
                launchUrl('https://www.linkedin.com/in/alaminxpro/' as Uri);
              }
            },
          ),
        ],
      )
      
      
    );
  }

  

  @override
  bool get wantKeepAlive => true;
}


class GuestUserUI extends StatelessWidget {
  const GuestUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text('login').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, SignInPage(tag: 'popup',)),
          ),
        SizedBox(height: 20,),
      ],
    );
  }
}


class UserUI extends StatelessWidget {
  const UserUI({super.key});

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: CachedNetworkImageProvider(sb.imageUrl)
              ),
              SizedBox(height: 10,),
              Text(sb.name, style: TextStyle(
                fontSize: 18
              ),)
            ],
          ),
        ),

        ListTile(
            title: Text(sb.email),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.mail, size: 20, color: Colors.white),
            ),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text(sb.joiningDate),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(LineIcons.home, size: 20, color: Colors.white),
            ),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('edit profile').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.edit, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: (){
               nextScreen(context, EditProfile(name: sb.name, imageUrl: sb.imageUrl));
            }
          ),

          Divider(height: 5,),

          ListTile(
            title: Text('logout').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Icons.logout, size: 20, color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, size: 20,),
            onTap: ()=> openLogoutDialog(context),
          ),



          SizedBox(height: 15,)
        

      ],
    );
  }


  void openLogoutDialog (context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('logout title').tr(),
          actions: [
            TextButton(
              child: const Text('no').tr(),
              onPressed: ()=> Navigator.pop(context),
            ),
            TextButton(
              child: const Text('yes').tr(),
              onPressed: ()async{
                Navigator.pop(context);
                await context.read<SignInBloc>().userSignout()
                .then((value) => nextScreenCloseOthers(context, SignInPage(tag: '')));
              },
            )
          ],
        );
      }
    );
  }
}