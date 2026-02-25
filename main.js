const menuToggle = document.querySelector('.menu-toggle');
const navLinks = document.querySelector('.nav-links');

if (menuToggle && navLinks) {
  menuToggle.addEventListener('click', () => {
    navLinks.classList.toggle('active');
  });

  navLinks.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => navLinks.classList.remove('active'));
  });
}

const navbar = document.querySelector('.navbar');
window.addEventListener('scroll', () => {
  if (!navbar) return;
  navbar.style.background = window.scrollY > 50 ? 'rgba(0, 0, 0, 0.86)' : 'var(--glass-bg)';
  navbar.style.padding = window.scrollY > 50 ? '10px 0' : '16px 0';
});

document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener('click', function (event) {
    const target = document.querySelector(this.getAttribute('href'));
    if (!target) return;
    event.preventDefault();
    target.scrollIntoView({ behavior: 'smooth' });
  });
});

const bookingForm = document.getElementById('booking-form');
if (bookingForm) {
  bookingForm.addEventListener('submit', (event) => {
    event.preventDefault();

    const name = document.getElementById('name')?.value?.trim();
    const phone = document.getElementById('phone')?.value?.trim();
    const service = document.getElementById('service')?.value || 'Consultation';
    const preference = document.getElementById('preference')?.value || 'Not specified';

    const message = [
      'Hello Akshar Dental Clinic,',
      '',
      'I would like to book an appointment.',
      '',
      `*Name:* ${name}`,
      `*Phone:* ${phone}`,
      `*Service:* ${service}`,
      `*Preferred Date & Time:* ${preference}`,
    ].join('\n');

    window.open(`https://wa.me/919067026607?text=${encodeURIComponent(message)}`, '_blank');
    bookingForm.reset();
  });
}
