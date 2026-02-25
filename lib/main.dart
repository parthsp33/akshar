import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'platform_utils.dart' as platform_utils;

void main() {
  platform_utils.registerViewFactory(
    'google-maps-view',
    'https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d3671.428782976!2d72.65313281141755!3d23.00890666613327!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m2!1m1!2zMjPCsDAwJzM1LjEiTiA3MsKwMzk\'MjAuNSJF!5e0!3m2!1sen!2sin!4v1739770542345!5m2!1sen!2sin',
  );
  runApp(const AksharApp());
}

class AksharApp extends StatelessWidget {
  const AksharApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akshar Dental Clinic',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF090C12),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: const Color(0xFFFF7A1A),
          secondary: const Color(0xFF36C4FF),
          surface: const Color(0xFF121722),
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
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _serviceController = TextEditingController();

  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _bookingKey = GlobalKey();

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final nextValue = _scrollController.offset > 20;
      if (nextValue != _isScrolled) {
        setState(() => _isScrolled = nextValue);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 820;

    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(isMobile),
                _buildHighlightsSection(isMobile),
                _buildAboutSection(isMobile),
                _buildServicesSection(isMobile),
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
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 14),
          decoration: BoxDecoration(
            color: _isScrolled ? const Color(0xCC111520) : const Color(0x73111520),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isScrolled ? 0.3 : 0.08),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.local_hospital_rounded, color: Color(0xFFFF7A1A), size: 26),
              const SizedBox(width: 10),
              Text(
                'AKSHAR DENTAL',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const Spacer(),
              if (isMobile)
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  ),
                )
              else ...[
                _navItem('About', () => _scrollTo(_aboutKey)),
                _navItem('Services', () => _scrollTo(_servicesKey)),
                _navItem('Booking', () => _scrollTo(_bookingKey)),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _scrollTo(_bookingKey),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A1A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0E131D),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Akshar Dental',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          _drawerItem('About', () {
            Navigator.pop(context);
            _scrollTo(_aboutKey);
          }),
          _drawerItem('Services', () {
            Navigator.pop(context);
            _scrollTo(_servicesKey);
          }),
          _drawerItem('Booking', () {
            Navigator.pop(context);
            _scrollTo(_bookingKey);
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(String text, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
    );
  }

  Widget _navItem(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      key: _heroKey,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, isMobile ? 130 : 120, isMobile ? 20 : 48, 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -110,
            left: -120,
            child: _blurGlow(const Color(0xFFFF7A1A)),
          ),
          Positioned(
            bottom: 30,
            right: -80,
            child: _blurGlow(const Color(0xFF36C4FF)),
          ),
          if (isMobile)
            Column(
              children: [
                _heroText(isMobile),
                const SizedBox(height: 24),
                _heroImage(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 11, child: _heroText(isMobile)),
                const SizedBox(width: 24),
                Expanded(flex: 9, child: _heroImage()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _heroText(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _chip('Ahmedabad • Laser & Implant Clinic'),
        const SizedBox(height: 18),
        Text(
          'Future of\nPainless Smiles',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: isMobile ? 42 : 68,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A premium dental experience designed with advanced technology, gentle care, and beautiful outcomes.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(color: Colors.white.withOpacity(0.72), fontSize: 17, height: 1.6),
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF28D468),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onPressed: _openClinicWhatsapp,
              icon: const Icon(Icons.chat_rounded),
              label: const Text('WhatsApp'),
            ),
            OutlinedButton(
              onPressed: () => _scrollTo(_bookingKey),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF7A1A)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Image.asset('assets/images/hero-bg.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.42),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection(bool isMobile) {
    final cards = [
      ('Hours', 'Mon - Sat\n9:00 AM - 8:00 PM', Icons.schedule_rounded),
      ('Trusted Care', '1000+ happy smiles\nSterile, modern setup', Icons.verified_user_rounded),
      ('Payments', 'UPI, card, cash\nInsurance support', Icons.payments_rounded),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 0, isMobile ? 20 : 48, 52),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards
            .map(
              (card) => SizedBox(
                width: isMobile ? double.infinity : (MediaQuery.of(context).size.width - 128) / 3,
                child: _glassBox(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(card.$3 as IconData, color: const Color(0xFFFF7A1A), size: 28),
                      const SizedBox(height: 14),
                      Text(card.$1 as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(card.$2 as String, style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.5)),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Container(
      key: _aboutKey,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 20 : 36),
      child: _glassBox(
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset('assets/images/doctor.png', fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 28 : 0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _chip('About Doctor'),
                  const SizedBox(height: 14),
                  Text(
                    'Dr. Pratik Prajapati',
                    style: TextStyle(fontSize: isMobile ? 32 : 42, fontWeight: FontWeight.w800, height: 1.15),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Laser Expert & Implantologist',
                    style: TextStyle(color: Color(0xFFFF7A1A), fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Known for precision-driven, pain-minimized dentistry with compassionate patient care and advanced treatments.',
                    style: TextStyle(color: Colors.white.withOpacity(0.74), fontSize: 16, height: 1.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile) {
    final services = [
      ('Laser Dentistry', 'Fast healing and pain-controlled gum procedures.', Icons.auto_awesome),
      ('Dental Implants', 'Long-lasting and natural replacement for missing teeth.', Icons.health_and_safety_rounded),
      ('Smile Designing', 'Custom veneers and aesthetic smile corrections.', Icons.sentiment_very_satisfied_rounded),
      ('Root Canal', 'Microscopic endodontic care with comfort-first protocol.', Icons.medical_services_rounded),
    ];

    return Container(
      key: _servicesKey,
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 36, isMobile ? 20 : 48, 24),
      child: Column(
        children: [
          _chip('Our Services'),
          const SizedBox(height: 12),
          Text('Specialized Dental Treatments', style: TextStyle(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isMobile ? 1.35 : 1.6,
            ),
            itemBuilder: (_, index) {
              final item = services[index];
              return _glassBox(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.$3 as IconData, color: const Color(0xFF36C4FF), size: 30),
                    const SizedBox(height: 14),
                    Text(item.$1 as String, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(item.$2 as String, style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.6)),
                    const Spacer(),
                    const Text('Learn more →', style: TextStyle(color: Color(0xFFFF7A1A), fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(bool isMobile) {
    return Container(
      key: _bookingKey,
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 36, isMobile ? 20 : 48, 20),
      child: _glassBox(
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _chip('Book Appointment'),
                  const SizedBox(height: 14),
                  Text('Let\'s design your healthiest smile', style: TextStyle(fontSize: isMobile ? 30 : 38, fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 12),
                  Text(
                    'Share your details and our team will connect with available time slots.',
                    style: TextStyle(color: Colors.white.withOpacity(0.72), height: 1.7),
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 0 : 28, height: isMobile ? 24 : 0),
            Expanded(
              child: Column(
                children: [
                  _field('Your Name', _nameController),
                  const SizedBox(height: 12),
                  _field('Phone Number', _phoneController, keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  _field('Service Interested', _serviceController),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _sendAppointmentRequest,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A1A),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Send via WhatsApp'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 36, isMobile ? 20 : 48, 20),
      child: Column(
        children: [
          _chip('Location'),
          const SizedBox(height: 12),
          Text('Visit Akshar Dental Clinic', style: TextStyle(fontSize: isMobile ? 28 : 38, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          _glassBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: isMobile ? 320 : 440,
                child: kIsWeb
                    ? const HtmlElementView(viewType: 'google-maps-view')
                    : Center(
                        child: FilledButton.icon(
                          onPressed: () => _openLink('https://www.google.com/maps/search/?api=1&query=23.00975,72.655694'),
                          icon: const Icon(Icons.map_rounded),
                          label: const Text('Open in Google Maps'),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 24, isMobile ? 20 : 48, 40),
      child: _glassBox(
        padding: const EdgeInsets.all(20),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2026 Akshar Dental Clinic • Crafted for confident smiles',
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(color: Colors.white.withOpacity(0.72)),
            ),
            if (isMobile) const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.facebook_rounded, size: 20),
                SizedBox(width: 10),
                Icon(Icons.camera_alt_rounded, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassBox({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF141A27).withOpacity(0.75),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A1A).withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xFFFF7A1A).withOpacity(0.38)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFFFA35E), fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _blurGlow(Color color) {
    return IgnorePointer(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.35), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF0E1320),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Future<void> _openClinicWhatsapp() async {
    const phone = '919067026607';
    await _openLink('https://wa.me/$phone');
  }

  Future<void> _sendAppointmentRequest() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final service = _serviceController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and phone number.')),
      );
      return;
    }

    const clinicPhone = '919067026607';
    final message = 'Hello Akshar Dental Clinic,%0A%0A'
        '*Name:* $name%0A'
        '*Phone:* $phone%0A'
        '*Service:* ${service.isEmpty ? 'General Consultation' : service}';

    await _openLink('https://wa.me/$clinicPhone?text=$message');
  }

  Future<void> _openLink(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $link')),
    );
  }
}
