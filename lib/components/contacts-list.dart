import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/pages/contact-details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'contact-avatar.dart';

class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;
  Function() reloadContacts;
  ContactsList({Key key, this.contacts, this.reloadContacts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];

          return Card(
            elevation: 1,
            color: Colors.white70,
            // shadowColor: Colors.amber,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: ListTile(
              trailing: GestureDetector(
                onTap: () {},
                
                
                child: Icon(Icons.call, color: Colors.green,)),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => ContactDetails(
                    contact,
                    onContactDelete: (AppContact _contact) {
                      reloadContacts();
                      Navigator.of(context).pop();
                    },
                    onContactUpdate: (AppContact _contact) {
                      reloadContacts();
                    },
                  )
                ));
              },
              title: Text(contact.info.displayName),
              subtitle: Text(
                  contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
              ),
              leading: ContactAvatar(contact, 36)
            ),
          );
        },
      ),
    );
  }
}

