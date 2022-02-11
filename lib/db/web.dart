import 'package:drift/web.dart';

import 'database.dart';

Database constructDb() => Database(WebDatabase('db'));
