# OSTRealmContacts

__Realm + AddressBook.framework__

## Wut?

This is an iOS Sample project that explores the importation of AddressBook contacts into a [Realm](http://realm.io) database using [Swift](https://developer.apple.com/swift/), bridged with an Objective-C based wrapper of [ABAddressBook](https://developer.apple.com/library/ios/documentation/AddressBook/Reference/ABAddressBookRef_iPhoneOS/index.html) called [RHAddressBook](https://github.com/heardrwt/RHAddressBook).

The project uses an in-memory instance of Realm, but you can make a one-line change in `OSTABManager` to switch to a persisted, default Realm (so that you can, for example, check out the data in the [Realm Browser](http://realm.io/docs/cocoa/#realm-browser).)

## Known Issues / TODOs

* If you're already run the app, and you want to switch from in-memory to default Realm (or _vice-versa_) then you'll need to delete the app, as the two engines will conflict with each other.
* The app can crash when switching Contacts permissions while the app is running. This is related the way threads get stored inside an [RHAddressBook singleton](https://github.com/heardrwt/RHAddressBook/blob/master/RHAddressBook/RHAddressBookSharedServices.m). We can either address this in a fork, or look into newer Swift-based libraries like <https://github.com/a2/Gulliver>.
* Deleted records from the AddressBook don't sync across to the Realm database… yet. 
* Writes for each record happen in a batch within a GCD concurrent queue, but this might need to happen in a more efficient manner. We'll know for sure when this is tested by a very popular person with 25K+ records 😇.
* While Swift makes prefix-style class namespacing "unnecessary," I still used the `OST` prefix as it still helped my brain think about the code.

## Thanks!

[Realm](http://realm.io). A sweet mobile database engine.

[RHAddressBook](https://github.com/heardrwt/RHAddressBook) ©2011-2012 [Richard Heard](https://github.com/heardrwt). Used under Modified BSD License.

## License & Copyright

©2015 Robert Otani <http://otanistudio.com>

OSTRealmContacts is Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
