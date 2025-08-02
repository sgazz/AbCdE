# 🧪 Vodič za testiranje aplikacije

## 🚀 **Kako testirati aplikaciju**

### **1. Osnovni testovi (5 minuta)**

#### **Početna stranica:**
1. ✅ Aplikacija se pokreće
2. ✅ "Započni učenje" → navigira na Lessons
3. ✅ "Demonstracija animacija" → otvara Demo screen
4. ✅ Bottom navigation radi (Home, Lessons, Progress, Settings)

#### **Navigation test:**
1. ✅ Tap na "Lessons" → otvara Lessons screen
2. ✅ Tap na "Progress" → otvara Progress screen  
3. ✅ Tap na "Settings" → otvara Settings screen
4. ✅ Back button radi na svim ekranima

### **2. Lessons testovi (10 minuta)**

#### **Alfabet odabir:**
1. ✅ Tap na "Latinica" → prikazuje A-Z slova
2. ✅ Tap na "Ćirilica" → prikazuje А-Я slova
3. ✅ Tap na "Brojevi" → prikazuje 0-9 brojeve

#### **Stil odabir:**
1. ✅ Tap na "Rukopis" → menja stil
2. ✅ Tap na "Štampana slova" → menja stil

#### **Progresivne lekcije:**
1. ✅ Tap na "Progresivne lekcije" → otvara Lessons Progress
2. ✅ Vidiš header sa progress bar-om
3. ✅ Vidiš listu lekcija (locked/unlocked)
4. ✅ Tap na unlocked lekciju → navigira na Writing

### **3. Writing testovi (15 minuta)**

#### **Drawing canvas:**
1. ✅ Crtaj prstom po ekranu → linija se prikazuje
2. ✅ Crtaj slovo "A" → linija je glatka
3. ✅ Tap "Ponovo" → canvas se briše

#### **ML analiza:**
1. ✅ Nacrtaj slovo "A"
2. ✅ Tap "Analiziraj" → prikazuje rezultate
3. ✅ Vidiš star rating (1-5 zvezdica)
4. ✅ Vidiš accuracy percentage
5. ✅ Vidiš feedback tekst

#### **Trace writing:**
1. ✅ Tap "Prati liniju" → otvara Trace screen
2. ✅ Vidiš animaciju trace path-a
3. ✅ Prati liniju prstom → accuracy se računa
4. ✅ Kada accuracy > 70% → completion dialog
5. ✅ Tap "Ponovo" → resetuje trace

#### **Multiplayer:**
1. ✅ Tap "Takmičenje" → otvara Multiplayer game
2. ✅ Vidiš countdown (3-2-1)
3. ✅ Vidiš timer (60 sekundi)
4. ✅ Tap "+5", "+10", "+15" → score se povećava
5. ✅ Kada timer završi → results dialog
6. ✅ Vidiš pobedu/poraz

### **4. Demo testovi (5 minuta)**

#### **Animacije:**
1. ✅ Tap "Demonstracija animacija"
2. ✅ Odaberi slovo "A"
3. ✅ Odaberi alfabet "Latinica"
4. ✅ Odaberi stil "Rukopis"
5. ✅ Tap "Play" → animacija se pokreće
6. ✅ Vidiš kako se crta slovo
7. ✅ Tap "Pause" → animacija se pauzira

### **5. Progress testovi (5 minuta)**

#### **Statistike:**
1. ✅ Tap "Progress" → otvara Progress screen
2. ✅ Vidiš ukupno slova, zvezdice, sesije, tačnost
3. ✅ Vidiš progress overview
4. ✅ Vidiš achievements (ako su unlocked)
5. ✅ Vidiš recent activity

### **6. Settings testovi (5 minuta)**

#### **Audio settings:**
1. ✅ Tap "Settings" → otvara Settings screen
2. ✅ Toggle "Uključi zvuk" → audio se uključuje/isključuje
3. ✅ Pomeri volume slider → glasnoća se menja

#### **Display settings:**
1. ✅ Toggle "Animacije" → animacije se uključuju/isključuju
2. ✅ Toggle "Grid pozadina" → grid se prikazuje/sakriva
3. ✅ Toggle "Target slovo" → target slovo se prikazuje/sakriva

#### **Theme selector:**
1. ✅ Tap "Tema aplikacije" → otvara Theme selector
2. ✅ Vidiš grid sa temama
3. ✅ Tap na temu → aplikacija se menja
4. ✅ Vidiš preview teme
5. ✅ Tap "Odabrano" → tema se čuva

#### **Learning preferences:**
1. ✅ Tap "Podrazumevani alfabet" → otvara dialog
2. ✅ Odaberi različit alfabet → menja se
3. ✅ Tap "Podrazumevani stil" → otvara dialog
4. ✅ Odaberi različit stil → menja se

### **7. Data testovi (5 minuta)**

#### **Progress saving:**
1. ✅ Nacrtaj nekoliko slova
2. ✅ Analiziraj ih → dobij zvezdice
3. ✅ Idí na Progress → vidiš napredak
4. ✅ Restart aplikaciju → napredak je sačuvan

#### **Reset functionality:**
1. ✅ Tap "Resetuj napredak" → otvara dialog
2. ✅ Tap "Resetuj" → briše sve podatke
3. ✅ Idí na Progress → vidiš prazne statistike

## 🐛 **Poznati problemi:**

### **Audio:**
- ❌ Audio fajlovi su placeholder (treba dodati stvarne)
- ❌ Neki zvukovi možda neće raditi

### **ML:**
- ⚠️ ML model je basic (može dati netačne rezultate)
- ⚠️ Fallback shape analysis se koristi

### **Performance:**
- ⚠️ Prvi put može biti sporiji
- ⚠️ Animacije mogu biti malo sporije na starijim uređajima

## ✅ **Success criteria:**

### **Aplikacija je uspešna ako:**
- ✅ Možeš crtati slova
- ✅ ML analiza daje rezultate
- ✅ Navigation radi glatko
- ✅ Data se čuva
- ✅ UI je responsive
- ✅ Nema crash-eva

### **Bonus points:**
- ✅ Multiplayer radi
- ✅ Themes se menjaju
- ✅ Animacije su smooth
- ✅ Audio funkcioniše

## 📱 **Test na iPhone-u:**

Aplikacija je pokrenuta na iPhone-u. Testiraj:

1. **Touch input** - crtanje prstom
2. **Screen size** - UI na manjem ekranu
3. **Performance** - brzina na iPhone-u
4. **Orientation** - portrait/landscape

## 🎯 **Fokus na testiranju:**

1. **Prvo testiraj core funkcionalnosti** (drawing, navigation)
2. **Zatim testiraj advanced features** (multiplayer, themes)
3. **Na kraju testiraj polish** (animations, audio)

**Aplikacija je spremna za testiranje! 🚀** 