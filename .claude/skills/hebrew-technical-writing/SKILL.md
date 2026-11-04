---
name: hebrew-technical-writing
description: How to write or translate technical content into natural Israeli tech Hebrew, rendered correctly right-to-left. Use when writing a Hebrew blog post, doc, interview guide or translation of technical material, or when asked to make Hebrew text "read naturally" or fix RTL layout.
---

# Writing technical Hebrew

Goal: text that reads like an Israeli engineer wrote it, not like a translation, and renders correctly right-to-left.

## Language

- **Write, don't translate.** Rewrite each idea the way you'd say it in Hebrew. Literal calques are the main failure.
- **Keep the English terms engineers actually use**: commit, בראנץ', deploy, timeout, cache, bulk, fixture, plugin, exception, rolling upgrade, bound parameters, roadmap, packaging, scope. Don't invent Hebrew coinages nobody says ("הנהלת חשבונות" for resource tracking, "פרמטרים קשורים" for bound parameters).
- **Hebrew prefixes attach with a hyphen**: ב-Kibana, ל-PyPI, ה-API, מ-git.
- **One term per concept** across the whole text. Pick it once (e.g. "exception" vs "חריגה") and stick to it.
- **Check that meaning survives.** Ambiguous Hebrew can flip technical meaning: "הריצות שעברו" reads as "runs that passed", so write "הריצות הקודמות" for past runs; "בכלל" can mean "at all" or "in the rule".
- **Gender-neutral by default:**
  - Address the reader in plural (אתם / בדקו / תארו), never masculine singular.
  - First person in past tense ("בניתי", "הוספתי") or "אנחנו"; present-tense first person singular is gendered ("אני סומך").
  - Quoted instructions as infinitives ("לנסות שוב", not "נסה שוב").
- **Idioms over translations**: "החשודים הרגילים" (not "הקבועים"), "לאן להמשיך לחפור", "עבר backport לכל הבראנצ'ים היציבים".
- Full spelling (כתיב מלא). No em dashes; use a regular hyphen.

### Calque → natural (real fixes)

| Literal | Natural |
| --- | --- |
| אסור לו לעולם להפיל את הריצה | אסור שהוא יפיל את הריצה, אף פעם |
| טסט רגרסיה נעל את התיקון | טסט רגרסיה מוודא שהבאג לא יחזור |
| להמציא מחדש את האריזה | להמציא מחדש את ה-packaging |
| מה הייתם מוסיפים עם עוד שבוע? | אם היה לכם עוד שבוע, מה הייתם מוסיפים? |
| נעילות היו מסדרות בתור את השרתים | נעילות היו הופכות את הכתיבות לסדרתיות |
| קחו בקשה אחת מקצה לקצה | עברו על בקשה אחת מקצה לקצה |

## Right-to-left rendering

- Set `dir="rtl" lang="he"` on the root container. Never `dir="auto"` on headings: a heading that starts with "Q1.1" or an English word flips to LTR.
- Isolate code and identifiers: `code { direction: ltr; unicode-bidi: isolate; }`.
- Wrap English runs that touch punctuation (colons, parentheses, a leading ID like `Q3.4`) in `<bdi>`.
- When a sentence starts with an English word right after a period, put an RLM (U+200F) before it.
- Use logical CSS properties: `padding-inline-start` and `border-inline-start`, not left/right.
- Fonts with good Hebrew: Assistant or Heebo for body, Rubik for headings, and a mono font for code.
- Markdown-only editors and some doc tools can't set direction. If the target can't do RTL, publish HTML (or a Google Doc with RTL paragraphs) instead of fighting it.

## Process

1. Draft in Hebrew directly, following the rules above.
2. Run a second pass as a native-level Hebrew technical editor. Check for calques, agreement, term consistency, meaning drift, gender slips and bidi problems. Keep a list of what changed.
3. Look at the rendered page once: alignment, bullets and indents on the right, no scrambled mixed-language lines.
