import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/components/contacts-list.dart';
import 'package:contacts_app/dialpad.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contacts',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Contacts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppContact> contacts = [];
  List<AppContact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }
  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;
    List<AppContact> _contacts = (await ContactsService.getContacts(withThumbnails: false, photoHighResolution: false)).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return new AppContact(info: contact, color: baseColor);
    }).toList();
    setState(() {
      contacts = _contacts;
      contactsLoaded = true;
    });
  }

  filterContacts() {
    List<AppContact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.info.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.info.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (
        (isSearching == true && contactsFiltered.length > 0) ||
        (isSearching != true && contacts.length > 0)
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: 'btn2',
        child: Icon(Icons.add, color: Colors.indigo,),
        elevation: 0,
        // backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () async {
          try {
            Contact contact = await ContactsService.openContactForm();
            if (contact != null) {
              getAllContacts();
            }
          } on FormOperationException catch (e) {
            switch(e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                print(e.toString());
            }
          }
        },
      ),],
        title: Text(widget.title, style: TextStyle(color: Colors.indigo),),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn1',
        child: Icon(Icons.dialpad),
        backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> DialScreen()));
          // try {
          //   Contact contact = await ContactsService.openContactForm();
          //   if (contact != null) {
          //     getAllContacts();
          //   }
          // } on FormOperationException catch (e) {
          //   switch(e.errorCode) {
          //     case FormOperationErrorCode.FORM_OPERATION_CANCELED:
          //     case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
          //     case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
          //       print(e.toString());
          //   }
          // }
        },
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              child: TextField(
                style: TextStyle(color: Colors.indigo),
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: new BorderSide(
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor
                  )
                ),
              ),
            ),
            contactsLoaded == true ?  // if the contacts have not been loaded yet
              listItemsExist == true ?  // if we have contacts to show
              ContactsList(
                reloadContacts: () {
                  getAllContacts();
                },
                contacts: isSearching == true ? contactsFiltered : contacts,
              ) : Container(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  isSearching ?'No search results to show' : 'No contacts exist',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
              ) :
            Container(  // still loading contacts
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: CircularProgressIndicator(color: Colors.cyan, ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
