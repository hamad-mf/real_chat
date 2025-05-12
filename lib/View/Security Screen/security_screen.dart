import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  Map<String, bool> switchStates = {
    'security': false,
    'pinsecurity': false,
    'facesecurity': false,
    'fingerprintsecurity': false,
  };

  // Track the last selected security method
  String lastSelectedMethod = 'pinsecurity'; // Default to PIN

  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchStates['security'] = prefs.getBool('security') ?? false;
      switchStates['pinsecurity'] = prefs.getBool('pinsecurity') ?? false;
      switchStates['facesecurity'] = prefs.getBool('facesecurity') ?? false;
      switchStates['fingerprintsecurity'] =
          prefs.getBool('fingerprintsecurity') ?? false;

      // Load the last selected method
      lastSelectedMethod =
          prefs.getString('lastSelectedMethod') ?? 'pinsecurity';

      // Ensure only one method is enabled if security is on
      if (switchStates['security'] == true) {
        _ensureSingleMethodEnabled();
      }
    });
  }

  void _ensureSingleMethodEnabled() {
    // Count enabled methods
    final enabledMethods = [
      switchStates['pinsecurity'] == true,
      switchStates['facesecurity'] == true,
      switchStates['fingerprintsecurity'] == true,
    ].where((enabled) => enabled).length;

    if (enabledMethods == 0) {
      // Default to the last selected method if none are enabled
      switchStates[lastSelectedMethod] = true;
    } else if (enabledMethods > 1) {
      // If multiple are enabled, update lastSelectedMethod and disable others
      if (switchStates['pinsecurity'] == true) {
        lastSelectedMethod = 'pinsecurity';
        switchStates['facesecurity'] = false;
        switchStates['fingerprintsecurity'] = false;
      } else if (switchStates['facesecurity'] == true) {
        lastSelectedMethod = 'facesecurity';
        switchStates['fingerprintsecurity'] = false;
      } else if (switchStates['fingerprintsecurity'] == true) {
        lastSelectedMethod = 'fingerprintsecurity';
      }
    } else {
      // If exactly one is enabled, update lastSelectedMethod
      if (switchStates['pinsecurity'] == true) {
        lastSelectedMethod = 'pinsecurity';
      } else if (switchStates['facesecurity'] == true) {
        lastSelectedMethod = 'facesecurity';
      } else if (switchStates['fingerprintsecurity'] == true) {
        lastSelectedMethod = 'fingerprintsecurity';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allItems = [
      {
        "name": 'Security',
        'image': 'assets/images/secure.png',
        'trailing': 'switch',
        'key': 'security',
        'alwaysVisible': true,
      },
      {
        "name": 'PIN Security',
        'image': 'assets/images/pin.png',
        'trailing': 'switch',
        'key': 'pinsecurity',
      },
      {
        "name": 'Face Recognition',
        'image': 'assets/images/face.png',
        'trailing': 'switch',
        'key': 'facesecurity',
      },
      {
        "name": 'Fingerprint Security',
        'image': 'assets/images/Fingerprint.png',
        'trailing': 'switch',
        'key': 'fingerprintsecurity',
      },
    ];

    final visibleItems = allItems.where((item) {
      return item['alwaysVisible'] == true || switchStates['security'] == true;
    }).toList();

    // Determine button text based on selected security method
    String buttonText = 'Change PIN';
    if (switchStates['facesecurity'] == true) {
      buttonText = 'Change Face ID';
    } else if (switchStates['fingerprintsecurity'] == true) {
      buttonText = 'Change Fingerprint';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                final key = item['key'] as String;
                final switchValue = switchStates[key] ?? false;

                return ListTile(
                  leading: Image.asset(item['image'] as String,
                      width: 40, height: 40),
                  title: Text(item['name'] as String),
                  trailing: _buildSecuritySwitch(
                    value: switchValue,
                    onChanged: (newValue) => _handleSwitchChange(key, newValue),
                    isMainSwitch: key == 'security',
                  ),
                );
              },
            ),
          ),
          if (switchStates['security'] == true)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  backgroundColor:
                      WidgetStatePropertyAll(ColorConstants.AppBarBlue),
                  minimumSize:
                      WidgetStatePropertyAll(Size(double.infinity, 56)),
                ),
                onPressed: () {
                  // Handle change PIN/face/fingerprint logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      buttonText,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSecuritySwitch({
    required bool value,
    required Function(bool) onChanged,
    bool isMainSwitch = false,
  }) {
    return Switch(
      thumbColor: WidgetStatePropertyAll(Colors.white),
      trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
      inactiveThumbColor: Colors.white,
      value: value,
      onChanged: onChanged,
      activeColor: ColorConstants.AppBarBlue,
    );
  }

  void _handleSwitchChange(String key, bool newValue) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      switchStates[key] = newValue;

      if (key == 'security') {
        if (newValue) {
          // When enabling security, enable the last selected method
          switchStates['pinsecurity'] = lastSelectedMethod == 'pinsecurity';
          switchStates['facesecurity'] = lastSelectedMethod == 'facesecurity';
          switchStates['fingerprintsecurity'] =
              lastSelectedMethod == 'fingerprintsecurity';
        } else {
          // When disabling security, disable all methods but remember the last choice
          switchStates['pinsecurity'] = false;
          switchStates['facesecurity'] = false;
          switchStates['fingerprintsecurity'] = false;
        }
      } else {
        // For method switches
        if (newValue) {
          // Update the last selected method
          lastSelectedMethod = key;

          // Ensure only this method is enabled
          if (key == 'pinsecurity') {
            switchStates['facesecurity'] = false;
            switchStates['fingerprintsecurity'] = false;
          } else if (key == 'facesecurity') {
            switchStates['pinsecurity'] = false;
            switchStates['fingerprintsecurity'] = false;
          } else if (key == 'fingerprintsecurity') {
            switchStates['pinsecurity'] = false;
            switchStates['facesecurity'] = false;
          }
        } else {
          // Don't allow disabling the last enabled method
          if ((switchStates['pinsecurity'] != true) &&
              (switchStates['facesecurity'] != true) &&
              (switchStates['fingerprintsecurity'] != true)) {
            // If trying to disable the last one, revert the change
            switchStates[key] = true;
          }
        }
      }
    });

    // Save all states including the last selected method
    await prefs.setBool('security', switchStates['security'] ?? false);
    await prefs.setBool('pinsecurity', switchStates['pinsecurity'] ?? false);
    await prefs.setBool('facesecurity', switchStates['facesecurity'] ?? false);
    await prefs.setBool(
        'fingerprintsecurity', switchStates['fingerprintsecurity'] ?? false);
    await prefs.setString('lastSelectedMethod', lastSelectedMethod);
  }
}
