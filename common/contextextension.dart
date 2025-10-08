import 'package:crm_generatewealthapp/Accounting/provider/Accountsprovider.dart';
import 'package:crm_generatewealthapp/CRM/provider/crmprovider.dart';
import 'package:crm_generatewealthapp/themeprovider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../provider/Userprovider.dart';

extension BuidContextExtension on BuildContext {
  ThemeProvider get watchtheme {
    return watch<ThemeProvider>();
  }

  Userprovider get readuser {
    return read<Userprovider>();
  }

  Userprovider get watchuser {
    return watch<Userprovider>();
  }

  Accountsprovider get readaccounts {
    return read<Accountsprovider>();
  }

  Accountsprovider get watchaccounts {
    return watch<Accountsprovider>();
  }

  Crmprovider get readcrm {
    return read<Crmprovider>();
  }

  Crmprovider get watchcrm {
    return watch<Crmprovider>();
  }
}
