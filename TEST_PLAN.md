# Test Plan - Aplikacija za učenje pisanja

## 🧪 Test Plan

### 📱 **Osnovni testovi**

#### 1. **Početna stranica (Home Screen)**
- [ ] Aplikacija se pokreće bez grešaka
- [ ] "Započni učenje" button radi
- [ ] "Demonstracija animacija" button radi
- [ ] Bottom navigation radi (Home, Lessons, Progress, Settings)
- [ ] UI je responsive na iPad-u

#### 2. **Lekcije (Lessons Screen)**
- [ ] Odabir alfabeta (Latinica, Ćirilica, Brojevi)
- [ ] Odabir stila (Rukopis, Štampana slova)
- [ ] "Progresivne lekcije" button radi
- [ ] "Sva slova" prikaz radi
- [ ] Grid prikaz slova je čitljiv

#### 3. **Progresivne lekcije (Lessons Progress Screen)**
- [ ] Header sa progress bar-om
- [ ] Lista lekcija se prikazuje
- [ ] Locked/unlocked status radi
- [ ] Otključavanje lekcija na osnovu zvezdica
- [ ] Navigacija na writing screen

#### 4. **Pisanje slova (Writing Screen)**
- [ ] Drawing canvas radi
- [ ] Crtanje prstom funkcioniše
- [ ] "Analiziraj" button radi
- [ ] ML analiza daje rezultate
- [ ] Star rating se prikazuje
- [ ] "Prati liniju" button radi
- [ ] "Takmičenje" button radi
- [ ] "Ponovo" button briše canvas

#### 5. **Trace Writing (Trace Screen)**
- [ ] Animacija trace path-a
- [ ] Praćenje linije prstom
- [ ] Accuracy calculation
- [ ] Progress bar
- [ ] Reset funkcionalnost
- [ ] Completion dialog

#### 6. **Multiplayer Game**
- [ ] Countdown (3-2-1)
- [ ] Timer (60 sekundi)
- [ ] Score tracking
- [ ] Opponent simulation
- [ ] Game history
- [ ] Results dialog
- [ ] Restart funkcionalnost

#### 7. **Demo Screen (Animacije)**
- [ ] Odabir slova
- [ ] Odabir alfabeta
- [ ] Odabir stila
- [ ] Letter animation radi
- [ ] Play/pause kontrole
- [ ] Smooth animacije

#### 8. **Progress Screen**
- [ ] Statistike se prikazuju
- [ ] Achievement sistem
- [ ] Recent activity
- [ ] Progress overview
- [ ] Data loading

#### 9. **Settings Screen**
- [ ] Audio settings (enable/disable, volume)
- [ ] Display settings (animations, grid, target letter)
- [ ] Learning preferences (alphabet, style, difficulty)
- [ ] Theme selector radi
- [ ] Data management (reset, export)

#### 10. **Theme Selector**
- [ ] Grid prikaz tema
- [ ] Preview tema
- [ ] Odabir teme
- [ ] Aplikacija se ažurira
- [ ] Čuvanje izbora

### 🎵 **Audio testovi**

#### 11. **Audio funkcionalnosti**
- [ ] Letter pronunciation
- [ ] Instructions audio
- [ ] Success/error sounds
- [ ] Volume control
- [ ] Audio enable/disable

### 🤖 **ML testovi**

#### 12. **Machine Learning**
- [ ] TensorFlow Lite model loading
- [ ] Letter recognition
- [ ] Accuracy calculation
- [ ] Star rating conversion
- [ ] Fallback shape analysis

### 📊 **Data testovi**

#### 13. **Progress tracking**
- [ ] Letter progress saving
- [ ] User progress loading
- [ ] Achievement unlocking
- [ ] Statistics calculation
- [ ] Data persistence

### 🎮 **Game testovi**

#### 14. **Multiplayer funkcionalnosti**
- [ ] Game initialization
- [ ] Timer accuracy
- [ ] Score calculation
- [ ] Opponent AI
- [ ] Game state management

### 🎨 **UI/UX testovi**

#### 15. **Visual elements**
- [ ] Animacije su smooth
- [ ] Transitions su fluid
- [ ] Colors su konzistentni
- [ ] Icons su čitljivi
- [ ] Text je čitljiv

### 📱 **Device testovi**

#### 16. **iPad specific**
- [ ] Touch input radi
- [ ] Drawing precision
- [ ] Screen orientation
- [ ] Performance je dobar
- [ ] Memory usage je optimalan

## 🐛 **Bug tracking**

### **Poznati problemi:**
- [ ] Audio fajlovi su placeholder (treba dodati stvarne)
- [ ] ML model je basic (treba trenirati)
- [ ] Neki assets možda nedostaju

### **Potrebni popravci:**
- [ ] Optimizacija performance
- [ ] Error handling
- [ ] Loading states
- [ ] Offline functionality

## ✅ **Test checklist**

### **Kritični testovi (MUST PASS):**
- [ ] Aplikacija se pokreće
- [ ] Drawing canvas radi
- [ ] Navigation radi
- [ ] Data saving radi
- [ ] UI je responsive

### **Važni testovi (SHOULD PASS):**
- [ ] ML analiza radi
- [ ] Audio funkcioniše
- [ ] Animacije su smooth
- [ ] Multiplayer radi
- [ ] Themes se menjaju

### **Bonus testovi (NICE TO HAVE):**
- [ ] Performance je optimalan
- [ ] Memory usage je nizak
- [ ] Battery usage je optimalan
- [ ] Crash-free experience

## 📝 **Test notes**

### **Test environment:**
- Device: iPad (iOS 18.6)
- Flutter version: Latest
- Debug mode: Enabled

### **Test duration:**
- Estimated time: 30-45 minutes
- Focus areas: Core functionality first

### **Test priority:**
1. **High**: Core features (drawing, navigation, data)
2. **Medium**: Advanced features (multiplayer, themes)
3. **Low**: Polish features (animations, audio)

## 🚀 **Ready for testing!**

Aplikacija je spremna za testiranje. Počni sa osnovnim funkcionalnostima i postepeno testiraj naprednije features. 