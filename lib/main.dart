import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'platform_utils.dart' as platform_utils;

void main() {
  // Register Google Maps iframe
  platform_utils.registerViewFactory(
    'google-maps-view',
    "https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d3671.428782976!2d72.65313281141755!3d23.00890666613327!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m2!1m1!2zMjPCsDAwJzM1LjEiTiA3MsKwMzk'MjAuNSJF!5e0!3m2!1sen!2sin!4v1739770542345!5m2!1sen!2sin",
  );
  runApp(const AksharApp());
}

class AksharApp extends StatelessWidget {
  const AksharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akshar Dental Clinic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF6B00),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.urbanistTextTheme(
          ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6B00),
          secondary: Color(0xFF00A3FF),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavbarGlass = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isNavbarGlass = _scrollController.offset > 50;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _bookingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(isMobile),
                _buildInfoSection(isMobile),
                _buildAboutSection(isMobile),
                _buildServicesSection(isMobile),
                _buildFAQSection(isMobile),
                _buildBookingSection(isMobile),
                _buildLocationSection(isMobile),
                _buildFooter(isMobile),
              ],
            ),
          ),
          _buildNavbar(isMobile),
        ],
      ),
    );
  }

  Widget _buildNavbar(bool isMobile) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: isMobile ? 20 : 40),
          decoration: BoxDecoration(
            color: _isNavbarGlass ? Colors.black.withOpacity(0.8) : Colors.transparent,
            border: _isNavbarGlass ? const Border(bottom: BorderSide(color: Colors.white12)) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.medical_services, color: Color(0xFFFF6B00), size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'AKSHAR',
                    style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -1),
                  ),
                  Text(
                    'DENTAL',
                    style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFFFF6B00)),
                  ),
                ],
              ),
              if (!isMobile)
                Row(
                  children: [
                    _navLink('About', () => _scrollTo(_aboutKey)),
                    const SizedBox(width: 30),
                    _navLink('Services', () => _scrollTo(_servicesKey)),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () => _scrollTo(_bookingKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                        shape: Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android ? null : RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), 
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      ),
                      child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              else
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Text(
                'AKSHAR DENTAL',
                style: TextStyle(color: Color(0xFFFF6B00), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(title: const Text('About'), onTap: () { Navigator.pop(context); _scrollTo(_aboutKey); }),
          ListTile(title: const Text('Services'), onTap: () { Navigator.pop(context); _scrollTo(_servicesKey); }),
          ListTile(title: const Text('Booking'), onTap: () { Navigator.pop(context); _scrollTo(_bookingKey); }),
        ],
      ),
    );
  }

  Widget _navLink(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      key: _heroKey,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 40, isMobile ? 120 : 0, isMobile ? 20 : 40, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glows
          Positioned(right: -100, top: 100, child: _glow(const Color(0xFFFF6B00))),
          Positioned(left: -100, bottom: 100, child: _glow(const Color(0xFF00A3FF))),
          
          isMobile 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _heroContent(isMobile),
                  const SizedBox(height: 40),
                  _heroImage(isMobile),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _heroContent(isMobile)),
                  Expanded(child: _heroImage(isMobile)),
                ],
              ),
        ],
      ),
    );
  }

  Widget _heroContent(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _badge('Evolving Dentistry'),
        const SizedBox(height: 20),
        Text(
          'Future of',
          style: GoogleFonts.urbanist(fontSize: isMobile ? 40 : 80, fontWeight: FontWeight.w800, height: 1.1),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFFFF6B00), Color(0xFFFF9E5E)]).createShader(bounds),
          child: Text(
            'Painless Smiles',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.urbanist(fontSize: isMobile ? 40 : 80, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Experience the perfect blend of technology and\ncare at Ahmedabad\'s premier dental destination.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 18),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat),
              label: const Text('Chat on WhatsApp'),
              style: _btnStyle(const Color(0xFF25D366)),
            ),
            ElevatedButton(
              onPressed: () => _scrollTo(_bookingKey),
              style: _btnStyle(const Color(0xFFFF6B00)),
               child: const Text('Book Now'),
            ),
          ],
        )
      ],
    );
  }

  Widget _heroImage(bool isMobile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.asset('assets/images/hero-bg.png', fit: BoxFit.cover),
    );
  }

  Widget _buildInfoSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: isMobile ? 20 : 40),
      child: isMobile 
        ? Column(children: [
            _infoCard('🕒', 'Working Hours', 'Mon - Sat: 9:00 AM - 8:00 PM\nSun: Emergency Only'),
            const SizedBox(height: 20),
            _infoCard('💳', 'Payment Options', 'Cash, UPI, All Major Cards\n& Insurance Support'),
            const SizedBox(height: 20),
            _infoCard('✅', 'Patient Trust', '1000+ Happy Smiles\nSterilized & Modern Setup'),
          ])
        : Row(children: [
            Expanded(child: _infoCard('🕒', 'Working Hours', 'Mon - Sat: 9:00 AM - 8:00 PM\nSun: Emergency Only')),
            const SizedBox(width: 20),
            Expanded(child: _infoCard('💳', 'Payment Options', 'Cash, UPI, All Major Cards\n& Insurance Support')),
            const SizedBox(width: 20),
            Expanded(child: _infoCard('✅', 'Patient Trust', '1000+ Happy Smiles\nSterilized & Modern Setup')),
          ]),
    );
  }

  Widget _infoCard(String icon, String title, String subtitle) {
    return _glassContainer(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFA0A0A0))),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Container(
      key: _aboutKey,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 20 : 80),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(flex: isMobile ? 0 : 1, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/images/doctor.png'))),
          if (isMobile) const SizedBox(height: 40) else const SizedBox(width: 60),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _badge('Expert Care'),
                const SizedBox(height: 20),
                const Text('Dr. Pratik Prajapati', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const Text('Laser Expert & Implantologist', style: TextStyle(fontSize: 24, color: Color(0xFFFF6B00))),
                const SizedBox(height: 20),
                const Text('Leading the way in modern dentistry with over a decade of experience in providing painless, high-tech dental solutions.', style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile) {
    return Container(
      key: _servicesKey,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 20 : 80),
      child: Column(
        children: [
          _badge('Clinical Excellence'),
          const SizedBox(height: 20),
          const Text('Our Specialized Services', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isMobile ? 0.85 : 0.85,
            children: [
              _serviceCard('Laser Dentistry', 'Pain-free gum care treatments.', 'assets/images/gallery-1.png'),
              _serviceCard('Dental Implants', 'Permanent solutions for missing teeth.', null, icon: '🦷'),
              _serviceCard('Smile Designing', 'Veneers and aesthetic reconstructions.', null, icon: '✨'),
            ],
          )
        ],
      ),
    );
  }

  Widget _serviceCard(String title, String desc, String? img, {String? icon}) {
    return _glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (img != null) 
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.asset(img, width: double.infinity, height: 200, fit: BoxFit.cover))
          else if (icon != null)
             Padding(padding: const EdgeInsets.all(20), child: Text(icon, style: const TextStyle(fontSize: 60))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(desc, style: const TextStyle(color: Color(0xFFA0A0A0))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFAQSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 20 : 80),
      child: Column(
        children: [
          _badge('Common Queries'),
          const SizedBox(height: 20),
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _faqItem('Is laser dentistry really painless?', 'Yes, laser dentistry minimizes the need for drills and anesthesia.'),
          _faqItem('How long does a dental implant last?', 'With proper care, dental implants can last a lifetime.'),
        ],
      ),
    );
  }

  Widget _faqItem(String q, String a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _glassContainer(
        child: ExpansionTile(
          title: Text(q, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: [Padding(padding: const EdgeInsets.all(20), child: Text(a, style: const TextStyle(color: Color(0xFFA0A0A0))))],
        ),
      ),
    );
  }

  Widget _buildBookingSection(bool isMobile) {
    return Container(
      key: _bookingKey,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 20 : 80),
      child: _glassContainer(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 30 : 60, horizontal: isMobile ? 20 : 60),
        child: Column(
          children: [
            const Text('Book Your Visit', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildBookingForm(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingForm(bool isMobile) {
    return Column(
      children: [
        if (isMobile) ...[
          _textField('Full Name', _nameController),
          const SizedBox(height: 20),
          _textField('Phone Number', _phoneController),
        ] else
          Row(children: [
            Expanded(child: _textField('Full Name', _nameController)),
            const SizedBox(width: 20),
            Expanded(child: _textField('Phone Number', _phoneController)),
          ]),
        const SizedBox(height: 20),
        _textField('Service Preference', _serviceController),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            final name = _nameController.text;
            final phone = _phoneController.text;
            final service = _serviceController.text;
            
            if (name.isEmpty || phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in your name and phone number')),
              );
              return;
            }

            final message = "Hello Akshar Dental Clinic,\n\nI would like to book an appointment.\n\n"
                            "*Name:* $name\n"
                            "*Phone:* $phone\n"
                            "*Service:* ${service.isEmpty ? 'General Inquiry' : service}";
            
            // Using the actual clinic number provided by the user.
            const targetPhone = "919067026607"; 
            final whatsappUrl = "https://wa.me/$targetPhone?text=${Uri.encodeComponent(message)}";
            
            if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
              await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch WhatsApp')),
              );
            }
          },
          style: _btnStyle(const Color(0xFFFF6B00), width: double.infinity),
          child: const Text('Send Request'),
        ),
      ],
    );
  }

  Widget _textField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF121212),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return _glassContainer(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: isMobile ? 20 : 40),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.center,
        children: [
          Text(
            '© 2026 Akshar Dental Clinic. All Rights Reserved.',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          if (isMobile) const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _socialIcon(Icons.facebook),
              const SizedBox(width: 10),
              _socialIcon(Icons.camera_alt),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white12),
      child: Icon(icon, size: 20),
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFF6B00).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  ButtonStyle _btnStyle(Color color, {double? width}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      minimumSize: width != null ? Size(width, 0) : null,
    );
  }

  Widget _buildLocationSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 20 : 80),
      child: Column(
        children: [
          _badge('Visit Us'),
          const SizedBox(height: 20),
          const Text('Our Location', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _glassContainer(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 450,
                width: double.infinity,
                child: kIsWeb 
                  ? const HtmlElementView(viewType: 'google-maps-view')
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined, size: 60, color: Color(0xFFFF6B00)),
                          const SizedBox(height: 20),
                          const Text(
                            'View on Google Maps',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              // Fallback to the coordinates if the short link is unknown
                              const fallbackUrl = "https://www.google.com/maps/search/?api=1&query=23.00975,72.655694";
                              if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
                                await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
                              }
                            },
                            style: _btnStyle(const Color(0xFFFF6B00)),
                            child: const Text('Open Maps'),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color color) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.15)),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent)),
    );
  }
}
