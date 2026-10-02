import requests
import time
import json

def generate_ibn_katheer_dart():
    print("Fetching chapter metadata...")
    chapters_url = "https://api.quran.com/api/v4/chapters"
    chapters_response = requests.get(chapters_url, timeout=10).json()
    chapters_map = {c['id']: c for c in chapters_response['chapters']}
    
    print("Generating Ibn Kathir Tafseer Data...")
    resource_id = 169  # Ibn Kathir on Quran.com
    
    dart_code = ""
    
    for surah_id in range(1, 115):
        print(f"Processing Surah {surah_id}...", end=" ")
        try:
            url = f"https://api.quran.com/api/v4/quran/tafsirs/{resource_id}?chapter_number={surah_id}"
            response = requests.get(url, timeout=15).json()
            
            if 'tafsirs' not in response or not response['tafsirs']:
                print("❌ No data")
                continue
                
            tafsirs = response['tafsirs']
            chapter_info = chapters_map[surah_id]
            
            surah_code = f"  {surah_id}: const TafseerSurah(\n"
            surah_code += f"    surahId: {surah_id},\n"
            surah_code += f"    nameAr: '{chapter_info['name_arabic']}',\n"
            surah_code += f"    nameEn: '{chapter_info['name_simple']}',\n"
            surah_code += "    introductionAr: '', introductionEn: '',\n"
            surah_code += "    verses: [\n"
            
            verse_count = 0
            for ayah in tafsirs:
                ayah_num = int(ayah['verse_key'].split(':')[1])
                text = ayah['text'].replace('$', '\\$')
                dart_string = json.dumps(text, ensure_ascii=False)
                
                surah_code += f"      TafseerVerse(verseNumber: {ayah_num}, tafseerAr: {dart_string}, tafseerEn: '', scholar: 'Ibn Kathir'),\n"
                verse_count += 1
            
            surah_code += "    ],\n  ),\n"
            dart_code += surah_code
            
            print(f"✓ {verse_count} verses")
            time.sleep(0.3)
            
        except requests.RequestException as e:
            print(f"❌ Network error: {e}")
        except KeyError as e:
            print(f"❌ Missing field: {e}")
        except Exception as e:
            print(f"❌ Error: {e}")

    with open("ibn_katheer_tafseer.dart", "w", encoding="utf-8") as f:
        f.write(dart_code)
    print("\n✅ Done! Copy the contents of ibn_katheer_tafseer.dart into the ibnKatheerTafseer map")

if __name__ == "__main__":
    generate_ibn_katheer_dart()