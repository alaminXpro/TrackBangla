import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/blocs/blog_bloc.dart';
import '/blocs/state_bloc.dart';
import '/models/colors.dart';
import '/models/state.dart';
import '/pages/state_based_places.dart';
import '/core/utils/empty.dart';
import '/core/utils/next_screen.dart';
import '/widgets/custom_cache_image.dart';
import '/core/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';

class StatesPage extends StatefulWidget {
  const StatesPage({Key? key}) : super(key: key);

  @override
  _StatesPageState createState() => _StatesPageState();
}

class _StatesPageState extends State<StatesPage> with AutomaticKeepAliveClientMixin {


  late ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value){
      context.read<StateBloc>().getData(mounted);
    });

  }


  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }




  void _scrollListener() {
    final db = context.read<BlogBloc>();
    
    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<StateBloc>().setLoading(true);
        context.read<StateBloc>().getData(mounted);

      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<StateBloc>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            'states'
            
          ).tr(),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.rotate_90_degrees_ccw, size: 22,),
              onPressed: (){
                context.read<StateBloc>().onReload(mounted);
              },
            )
          ],
        ),

    body: RefreshIndicator(
        child: sb.hasData == false 
        ? ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
            const EmptyPage(icon: Icons.error, message: 'No States found', message1: ''),
          ],
          )
        
        : ListView.separated(
          padding: EdgeInsets.all(15),
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: sb.data.length != 0 ? sb.data.length + 1 : 8,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,),
          
          //shrinkWrap: true,
          itemBuilder: (_, int index) {

            if (index < sb.data.length) {
              return _ItemList(d: sb.data[index]);
            }
            return Opacity(
                opacity: sb.isLoading ? 1.0 : 0.0,
                child: sb.lastVisible == null
                ? LoadingCard(height: 140)
                
                : const Center(
                  child: SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: CupertinoActivityIndicator()),
                ),
              
            );
          },
        ),
        onRefresh: () async {
          context.read<StateBloc>().onRefresh(mounted);
          
        },
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


class _ItemList extends StatelessWidget {
  final StateModel d;
  const _ItemList({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return InkWell(
          child: Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CustomCacheImage(imageUrl: d.thumbnailUrl,)),
            ),

            Align(
              alignment: Alignment.center,
              child: Text(d.name.toUpperCase(), style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),),
            )

            
          ],
        )
      ),

      onTap: ()=> nextScreen(context, StateBasedPlaces(
        stateName: d.name, 
        color: (ColorList().randomColors..shuffle()).first,
        
        )),
    );
  }
}