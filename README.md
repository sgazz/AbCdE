# Aplikacija za učenje pisanja

Interaktivna aplikacija za učenje pisanja slova namenjena deci i svima koji žele da nauče da pišu.

## 🎯 Funkcionalnosti

### 📝 Glavne funkcionalnosti
- **Crtanje slova** - Custom canvas za crtanje slova prstom
- **ML analiza** - TensorFlow Lite integracija za prepoznavanje slova
- **Ocenjivanje** - Sistem zvezdica (1-5) za ocenjivanje pisanja
- **Trace writing** - Praćenje linije slova
- **Animacije** - Demonstracije kako se crtaju slova

### 🎵 Audio funkcionalnosti
- **Zvukovi slova** - Reprodukcija zvuka za svako slovo
- **Uputstva** - Audio instrukcije za korisnike
- **Feedback zvukovi** - Success/error zvukovi
- **Volume kontrola** - Podešavanje glasnoće

### 📊 Progress tracking
- **Statistike** - Praćenje napretka i tačnosti
- **Achievement sistem** - Dostignuća za motivaciju
- **Recent activity** - Pregled nedavnih aktivnosti
- **Data management** - Čuvanje i učitavanje podataka

### ⚙️ Podešavanja
- **Audio opcije** - Uključivanje/isključivanje zvuka
- **Display opcije** - Animacije, grid, target slova
- **Learning preferences** - Alfabet, stil, nivo težine
- **Data management** - Reset i export podataka

## 🏗️ Arhitektura

### 📁 Struktura projekta
```
lib/
├── main.dart                 # Glavna aplikacija
├── models/                   # Data modeli
│   ├── letter.dart          # Model za slova
│   └── user_progress.dart   # Model za napredak
├── screens/                  # UI ekrani
│   ├── home_screen.dart     # Početna stranica
│   ├── lessons_screen.dart  # Ekran za lekcije
│   ├── writing_screen.dart  # Ekran za pisanje
│   ├── trace_screen.dart    # Ekran za trace writing
│   ├── progress_screen.dart # Ekran za napredak
│   ├── settings_screen.dart # Ekran za podešavanja
│   └── demo_screen.dart     # Demo animacije
├── widgets/                  # UI komponente
│   ├── drawing_canvas.dart  # Canvas za crtanje
│   ├── star_rating.dart     # Sistem ocenjivanja
│   ├── letter_animation.dart # Animacije slova
│   ├── trace_writing.dart   # Trace writing widget
│   └── achievement_notification.dart # Achievement notifikacije
├── services/                 # Business logika
│   ├── ml_service.dart      # ML integracija
│   ├── audio_service.dart   # Audio funkcionalnosti
│   └── progress_service.dart # Progress tracking
└── utils/                    # Pomoćne funkcije
    └── constants.dart       # Konstante aplikacije
```

### 🔧 Tehnologije
- **Flutter** - Cross-platform framework
- **TensorFlow Lite** - ML model za prepoznavanje
- **AudioPlayers** - Audio reprodukcija
- **SharedPreferences** - Local storage
- **Provider** - State management

## 🚀 Pokretanje aplikacije

### 📋 Preduslovi
- Flutter SDK (3.8.1+)
- Dart SDK (3.8.1+)
- Android Studio / Xcode (za mobilne uređaje)

### ⚡ Instalacija
```bash
# Kloniranje projekta
git clone <repository-url>
cd writing_learning_app

# Instalacija zavisnosti
flutter pub get

# Pokretanje aplikacije
flutter run
```

### 📱 Podržani uređaji
- **iOS** - iPhone, iPad (iOS 12.0+)
- **Android** - Telefoni i tableti (Android 5.0+)
- **Web** - Moderni browseri
- **Desktop** - Windows, macOS, Linux

## 🎮 Korišćenje aplikacije

### 🏠 Početna stranica
- **Započni učenje** - Navigacija na lekcije
- **Demonstracija animacija** - Pregled animacija slova
- **Pogledaj napredak** - Statistike i dostignuća

### 📚 Lekcije
- **Odabir alfabeta** - Latinica, Ćirilica, Brojevi
- **Odabir stila** - Rukopis, Štampana slova
- **Lista slova** - Grid prikaz svih slova

### ✍️ Pisanje slova
- **Drawing canvas** - Crtanje slova prstom
- **ML analiza** - Automatsko prepoznavanje
- **Star rating** - Ocenjivanje sa zvezdicama
- **Prati liniju** - Trace writing opcija

### 📊 Napredak
- **Statistike** - Ukupno slova, zvezdice, sesije, tačnost
- **Pregled napretka** - Savladana slova i tačnost
- **Dostignuća** - Achievement sistem
- **Nedavna aktivnost** - Pregled poslednjih vežbi

### ⚙️ Podešavanja
- **Audio** - Zvuk, glasnoća
- **Prikaz** - Animacije, grid, target slova
- **Učenje** - Alfabet, stil, nivo težine
- **Podaci** - Reset i export

## 🎯 Alfabeti i stilovi

### 🔤 Latinica (A-Z)
- 26 slova
- Rukopis i štampana slova
- Audio uputstva

### 🔤 Ćirilica (А-Я)
- 33 slova
- Rukopis i štampana slova
- Audio uputstva

### 🔢 Brojevi (0-9)
- 10 brojeva
- Rukopis i štampana slova
- Audio uputstva

## 🏆 Achievement sistem

### 🎖️ Dostignuća
- **Prvi korak** - Prva lekcija
- **Zvezdica** - 5 zvezdica
- **Pismen** - 10 savladanih slova
- **Savršen pisac** - 90% tačnost
- **Majstor alfabeta** - Savladan ceo alfabet

## 🔧 Konfiguracija

### 📱 Platforme
```yaml
# pubspec.yaml
flutter:
  platforms:
    android: true
    ios: true
    web: true
    desktop: true
```

### 🎵 Audio fajlovi
```
assets/audio/
├── letters/          # Zvukovi slova
├── instructions/     # Uputstva
├── effects/          # Feedback zvukovi
├── pronunciation/    # Izgovor
└── animations/       # Animacije zvukovi
```

### 🤖 ML model
```
assets/models/
└── letter_recognition.tflite  # TensorFlow Lite model
```

## 🐛 Troubleshooting

### ❌ Česti problemi
1. **Audio ne radi** - Proverite volume settings
2. **ML analiza ne radi** - Proverite TensorFlow Lite model
3. **Crash na startup** - Proverite dependencies
4. **Performance issues** - Proverite device specifications

### 🔧 Rešenja
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run --debug

# Platform specific
flutter run -d <device-id>
```

## 📈 Planovi za budućnost

### 🚀 Nove funkcionalnosti
- **Više alfabeta** - Arapski, kineski, japanski
- **Više stilova** - Kaligrafija, graffiti
- **Multiplayer** - Takmičenja između korisnika
- **Cloud sync** - Sinhronizacija napretka
- **Offline mode** - Rad bez interneta

### 🎨 UI/UX poboljšanja
- **Dark mode** - Tamna tema
- **Custom themes** - Prilagodljive boje
- **Accessibility** - Podrška za osobe sa invaliditetom
- **Localization** - Više jezika

### 🤖 AI poboljšanja
- **Personalizovani ML** - Učenje na osnovu korisnika
- **Real-time feedback** - Trenutne sugestije
- **Adaptive difficulty** - Prilagodljiva težina
- **Voice commands** - Glasovne komande

## 📄 Licenca

MIT License - pogledajte LICENSE fajl za detalje.

## 🤝 Doprinosi

Dobrodošli su svi doprinosi! Molimo vas da:

1. Fork-ujte projekat
2. Kreirajte feature branch
3. Commit-ujte promene
4. Push-ujte na branch
5. Otvorite Pull Request

## 📞 Kontakt

Za pitanja i podršku:
- Email: support@writinglearningapp.com
- GitHub Issues: [Repository Issues](https://github.com/username/writing-learning-app/issues)

---

**Napomena**: Ova aplikacija je u razvoju. Neke funkcionalnosti mogu biti nedostupne ili u testiranju.
