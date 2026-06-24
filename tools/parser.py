import os
import sys
import re
import json
import sqlite3
import fitz  # PyMuPDF

# ==============================================================================
# CONFIGURATION & CONSTANTS
# ==============================================================================
PDF_PATH = r"C:\Users\hp\Downloads\Telegram Desktop\amharic (1).pdf"
OUTPUT_JSON_PATH = r"c:\Users\hp\Desktop\CODES\AMHARICQUR\assets\database\book.json"
OUTPUT_DB_PATH = r"c:\Users\hp\Desktop\CODES\AMHARICQUR\assets\database\book.db"

# Font names observed in the PDF
FONT_ARABIC_PATTERNS = ["uthmanic", "lotus", "arabic", "kfgqpc"]
FONT_AMHARIC_PATTERNS = ["nyala"]
FONT_LATIN_PATTERNS = ["arno", "minion", "times"]

# Regex patterns
RE_ARABIC_INDIC = re.compile(r'[\u0660-\u0669]+')
RE_VERSE_NUM_AMHARIC = re.compile(r'^(\d+(?:-\d+)?)\.\s*')
RE_JUZ_HEADER = re.compile(r'^(\d+)\s*ክፍል\s*(\d+)')
RE_SURAH_HEADER = re.compile(r'^ምዕራፍ\s*\((\d+)\)\s*(.*)')

# ==============================================================================
# TEXT RECONSTRUCTION UTILITIES
# ==============================================================================
def reverse_arabic_indic_digits(text):
    """Reverses the visual character ordering of Arabic-Indic digits in a string."""
    def replace(match):
        return match.group(0)[::-1]
    return RE_ARABIC_INDIC.sub(replace, text)

def is_arabic_span(span):
    """Checks if a span is Arabic based on its font name or character ranges."""
    font_lower = span["font"].lower()
    if any(p in font_lower for p in FONT_ARABIC_PATTERNS):
        return True
    # Fallback to character checking (Arabic Unicode Block)
    text = span["text"]
    if any(0x0600 <= ord(c) <= 0x06FF for c in text):
        return True
    return False

def group_spans_into_physical_lines(spans, y_tolerance=2.0):
    """Groups text spans sharing the same vertical coordinate (y0) into lines."""
    lines = []
    if not spans:
        return lines
        
    # Sort spans by y0 first (top to bottom)
    sorted_spans = sorted(spans, key=lambda s: s["bbox"][1])
    
    current_line = []
    current_y = None
    
    for span in sorted_spans:
        # Ignore empty/whitespace spans
        if not span["text"].strip():
            continue
            
        y0 = span["bbox"][1]
        if current_y is None:
            current_y = y0
            current_line.append(span)
        elif abs(y0 - current_y) <= y_tolerance:
            current_line.append(span)
        else:
            lines.append(current_line)
            current_line = [span]
            current_y = y0
            
    if current_line:
        lines.append(current_line)
        
    return lines

def reconstruct_line_text(line_spans):
    """
    Sorts spans horizontally based on language text direction and joins them.
    Arabic spans are sorted Right-to-Left (x descending).
    Amharic/Latin spans are sorted Left-to-Right (x ascending).
    """
    if not line_spans:
        return "", False
        
    # Determine if line is primarily Arabic
    arabic_count = sum(1 for s in line_spans if is_arabic_span(s))
    is_arabic_line = arabic_count > (len(line_spans) / 2.0)
    
    # Sort spans
    if is_arabic_line:
        sorted_spans = sorted(line_spans, key=lambda s: s["bbox"][0], reverse=True)
    else:
        sorted_spans = sorted(line_spans, key=lambda s: s["bbox"][0])
        
    # Reconstruct text
    segments = []
    for span in sorted_spans:
        text = span["text"]
        if is_arabic_line:
            # Reverse Arabic numbers (due to LTR physical extraction)
            text = reverse_arabic_indic_digits(text)
        segments.append(text)
        
    joined_text = "".join(segments)
    
    # Clean up excess spaces but preserve structural spaces
    joined_text = re.sub(r' +', ' ', joined_text)
    
    return joined_text.strip(), is_arabic_line

# ==============================================================================
# BLOCK PARSING ENGINE
# ==============================================================================
def extract_blocks_from_page(page):
    """
    Extracts high-fidelity structured text blocks from a single PDF page.
    Groups spans by line, classifies paragraph language, and keeps styling info.
    """
    page_dict = page.get_text("dict")
    raw_blocks = page_dict["blocks"]
    
    structured_blocks = []
    
    # Track global sort order within page
    sort_order = 0
    
    for block in raw_blocks:
        if "lines" not in block:
            continue
            
        # Collect all spans in block
        spans = []
        for line in block["lines"]:
            for span in line["spans"]:
                spans.append(span)
                
        if not spans:
            continue
            
        # Group spans by vertical y coordinate to form lines
        physical_lines = group_spans_into_physical_lines(spans)
        
        # Build block segments
        block_text_ar = []
        block_text_am = []
        block_spans_meta = []
        
        has_arabic = False
        has_amharic = False
        
        # Gather styling characteristics
        font_families = set()
        font_sizes = set()
        font_colors = set()
        
        for line_spans in physical_lines:
            line_text, is_ar = reconstruct_line_text(line_spans)
            if not line_text:
                continue
                
            if is_ar:
                block_text_ar.append(line_text)
                has_arabic = True
            else:
                block_text_am.append(line_text)
                has_amharic = True
                
            for s in line_spans:
                font_families.add(s["font"])
                font_sizes.add(round(s["size"], 1))
                font_colors.add(f"#{s['color']:06X}")
                
        text_ar = " ".join(block_text_ar).strip()
        text_am = " ".join(block_text_am).strip()
        
        if not text_ar and not text_am:
            continue
            
        # Classify block type
        block_type = "paragraph"
        level = None
        
        # Check if Surah heading
        if text_am and RE_SURAH_HEADER.match(text_am):
            block_type = "surahTitle"
            level = 1
        # Check if Juz heading
        elif text_am and RE_JUZ_HEADER.match(text_am):
            block_type = "chapterTitle"
            level = 1
        # Check if Arabic verse block
        elif text_ar and not text_am:
            block_type = "verse_arabic"
        # Check if Amharic translation block
        elif text_am and RE_VERSE_NUM_AMHARIC.match(text_am):
            block_type = "translation_amharic"
        # Check if bullet list takeaway
        elif text_am and re.match(r'^\d+\.\s+\t*', text_am):
            block_type = "list_item"
            
        # Style details
        style = {
            "font_family": list(font_families)[0] if font_families else "Nyala-Regular",
            "font_size": max(font_sizes) if font_sizes else 10.0,
            "text_color": list(font_colors)[0] if font_colors else "#231F20",
            "alignment": "center" if block_type in ["surahTitle", "chapterTitle"] else ("right" if block_type == "verse_arabic" else "left")
        }
        
        structured_blocks.append({
            "type": block_type,
            "sort_order": sort_order,
            "level": level,
            "text_ar": text_ar if text_ar else None,
            "text_am": text_am if text_am else None,
            "style": style,
            "bbox": block["bbox"]
        })
        
        sort_order += 1
        
    return structured_blocks

# ==============================================================================
# PIPELINE EXECUTION
# ==============================================================================
def build_sqlite_db(pages_data):
    """
    Creates and seeds the SQLite database matching the updated normalized schema.
    Uses incremental writes for memory efficiency.
    """
    if os.path.exists(OUTPUT_DB_PATH):
        os.remove(OUTPUT_DB_PATH)
        
    conn = sqlite3.connect(OUTPUT_DB_PATH)
    cursor = conn.cursor()
    
    # 1. Create tables
    cursor.execute('''
    CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        metadata_json TEXT
    )''')
    
    cursor.execute('''
    CREATE TABLE chapters (
        id INTEGER PRIMARY KEY,
        book_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (book_id) REFERENCES books(id)
    )''')
    
    cursor.execute('''
    CREATE TABLE sections (
        id INTEGER PRIMARY KEY,
        chapter_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        level INTEGER NOT NULL,
        FOREIGN KEY (chapter_id) REFERENCES chapters(id)
    )''')
    
    cursor.execute('''
    CREATE TABLE pages (
        id INTEGER PRIMARY KEY,
        book_id INTEGER NOT NULL,
        page_number INTEGER NOT NULL,
        header TEXT,
        footer TEXT,
        style_json TEXT,
        FOREIGN KEY (book_id) REFERENCES books(id)
    )''')
    
    cursor.execute('''
    CREATE TABLE content_blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        page_id INTEGER NOT NULL,
        section_id INTEGER,
        type TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        style_json TEXT,
        metadata_json TEXT,
        FOREIGN KEY (page_id) REFERENCES pages(id),
        FOREIGN KEY (section_id) REFERENCES sections(id)
    )''')
    
    cursor.execute('''
    CREATE TABLE paragraphs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content_block_id INTEGER NOT NULL,
        language TEXT NOT NULL,
        text TEXT NOT NULL,
        style_json TEXT,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (content_block_id) REFERENCES content_blocks(id)
    )''')
    
    # Virtual table FTS5
    cursor.execute('''
    CREATE VIRTUAL TABLE book_content_fts USING fts5(
        content_id UNINDEXED,
        title,
        text_ar,
        text_am,
        tokenize = 'unicode61'
    )''')
    
    # Trigger to sync FTS5
    cursor.execute('''
    CREATE TRIGGER book_content_ai AFTER INSERT ON paragraphs BEGIN
        INSERT INTO book_content_fts(content_id, title, text_ar, text_am)
        SELECT 
            NEW.content_block_id,
            CASE WHEN cb.type IN ('surahTitle', 'chapterTitle', 'heading') THEN NEW.text ELSE '' END,
            CASE WHEN NEW.language = 'ar' THEN NEW.text ELSE '' END,
            CASE WHEN NEW.language = 'am' THEN NEW.text ELSE '' END
        FROM content_blocks cb WHERE cb.id = NEW.content_block_id;
    END;
    ''')
    
    # 2. Seed Book metadata
    book_id = 1
    cursor.execute(
        "INSERT INTO books (id, title, author, metadata_json) VALUES (?, ?, ?, ?)",
        (book_id, "Amharic Quran Tafsir", "Sheikh Muhammedzeyn Zehredin Khelil", "{}")
    )
    
    # Track hierarchy references
    current_chapter_id = 0
    current_section_id = 0
    chapter_order = 1
    section_order = 1
    global_block_id = 1
    
    # 3. Seed Page and Content blocks page by page
    for p_idx, page_data in enumerate(pages_data):
        page_num = page_data["page_number"]
        header = page_data.get("header")
        
        # Insert Page
        cursor.execute(
            "INSERT INTO pages (book_id, page_number, header, footer, style_json) VALUES (?, ?, ?, ?, ?)",
            (book_id, page_num, header, None, json.dumps(page_data["style"]))
        )
        page_db_id = cursor.lastrowid
        
        for block in page_data["content_blocks"]:
            b_type = block["type"]
            
            # Identify chapter hierarchy
            if b_type == "chapterTitle":
                current_chapter_id += 1
                cursor.execute(
                    "INSERT INTO chapters (id, book_id, title, sort_order) VALUES (?, ?, ?, ?)",
                    (current_chapter_id, book_id, block["text_am"], chapter_order)
                )
                chapter_order += 1
                current_section_id = 0 # reset sections inside new chapter
                
            elif b_type == "surahTitle":
                current_section_id += 1
                section_title = block["text_am"] if block["text_am"] else (block["text_ar"] if block["text_ar"] else "Surah")
                # Ensure we have a valid chapter to link to
                valid_chap_id = current_chapter_id if current_chapter_id > 0 else 1
                if current_chapter_id == 0:
                    current_chapter_id = 1
                    cursor.execute(
                        "INSERT INTO chapters (id, book_id, title, sort_order) VALUES (?, ?, ?, ?)",
                        (current_chapter_id, book_id, "Prefatory", chapter_order)
                    )
                    chapter_order += 1
                cursor.execute(
                    "INSERT INTO sections (id, chapter_id, title, sort_order, level) VALUES (?, ?, ?, ?, ?)",
                    (current_section_id, current_chapter_id, section_title, section_order, block.get("level", 1))
                )
                section_order += 1
                
            # Resolve section foreign key
            sec_fk = current_section_id if current_section_id > 0 else None
            
            # Insert Content Block
            cursor.execute(
                "INSERT INTO content_blocks (page_id, section_id, type, sort_order, style_json, metadata_json) VALUES (?, ?, ?, ?, ?, ?)",
                (page_db_id, sec_fk, b_type, block["sort_order"], json.dumps(block["style"]), "{}")
            )
            block_db_id = cursor.lastrowid
            
            # Insert Paragraphs
            para_order = 0
            if block["text_ar"]:
                cursor.execute(
                    "INSERT INTO paragraphs (content_block_id, language, text, style_json, sort_order) VALUES (?, ?, ?, ?, ?)",
                    (block_db_id, "ar", block["text_ar"], json.dumps(block["style"]), para_order)
                )
                para_order += 1
            if block["text_am"]:
                cursor.execute(
                    "INSERT INTO paragraphs (content_block_id, language, text, style_json, sort_order) VALUES (?, ?, ?, ?, ?)",
                    (block_db_id, "am", block["text_am"], json.dumps(block["style"]), para_order)
                )
                
    conn.commit()
    conn.close()
    print("Database built successfully!")

def main():
    print(f"Opening PDF: {PDF_PATH}")
    doc = fitz.open(PDF_PATH)
    
    pages_data = []
    
    print("Beginning page-by-page extraction...")
    for i in range(len(doc)):
        page = doc[i]
        
        # Page dimensions
        width = round(page.rect.width, 2)
        height = round(page.rect.height, 2)
        
        # Extract blocks
        blocks = extract_blocks_from_page(page)
        
        # Detect header from the first block if it's placed near the top
        header = None
        if blocks and blocks[0]["bbox"][1] < 45.0:
            header_block = blocks.pop(0)
            header = header_block["text_am"] if header_block["text_am"] else header_block["text_ar"]
            # Correct sort order of remaining blocks
            for idx, b in enumerate(blocks):
                b["sort_order"] = idx
                
        page_entry = {
            "page_number": i + 1,
            "header": header,
            "style": {
                "page_width": width,
                "page_height": height,
                "background_color": "#FFFFFF"
            },
            "content_blocks": blocks
        }
        
        pages_data.append(page_entry)
        
        if (i + 1) % 100 == 0:
            print(f"Processed {i + 1} / {len(doc)} pages...")
            
    # Write JSON output
    print(f"Saving JSON output: {OUTPUT_JSON_PATH}")
    os.makedirs(os.path.dirname(OUTPUT_JSON_PATH), exist_ok=True)
    with open(OUTPUT_JSON_PATH, "w", encoding="utf-8") as f:
        json.dump({"book": {
            "title": "Amharic Quran Tafsir",
            "author": "Sheikh Muhammedzeyn Zehredin Khelil",
            "metadata": {}
        }, "pages": pages_data}, f, ensure_ascii=False, indent=2)
        
    # Build SQLite DB
    print(f"Building SQLite database: {OUTPUT_DB_PATH}")
    os.makedirs(os.path.dirname(OUTPUT_DB_PATH), exist_ok=True)
    build_sqlite_db(pages_data)
    
    print("Parsing pipeline completed successfully!")

if __name__ == "__main__":
    main()
