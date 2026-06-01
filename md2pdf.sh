#!/bin/zsh
# md2pdf.sh — Конвертация Markdown → PDF по шаблонам ЕСКД/Диссертация/Книга
# Использует NSLReport (LaTeX) + pandoc
#
# Использование:
#   ./md2pdf.sh <входной.md> [вариант]
#
# Варианты оформления:
#   1 или eskd   — ЕСКД ГОСТ 2.105 с рамкой (по умолчанию)
#   2 или disser — Диссертация ГОСТ Р 7.0.11
#   3 или book   — Книга / методическое пособие
#
# Примеры:
#   ./md2pdf.sh ../РЭ/РЕГ-6\ Руководство\ по\ экспулатации\ платформы.md
#   ./md2pdf.sh ../РЭ/РЕГ-6\ Руководство\ по\ экспулатации\ платформы.md eskd
#   ./md2pdf.sh ../ТПД/ТПД-3-2\ ДОКУМЕНТ\ АРХИТЕКТУРЫ.md disser
#   ./md2pdf.sh ../ТПД/ТПД-3-2\ ДОКУМЕНТ\ АРХИТЕКТУРЫ.md book

set -euo pipefail

# --- Цвета для вывода ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="${0:A:h}"

# --- Проверка аргументов ---
if [[ $# -lt 1 ]]; then
    echo "${YELLOW}Использование:${NC} $0 <входной.md> [вариант]"
    echo ""
    echo "Варианты оформления:"
    echo "  1 / eskd   — ЕСКД ГОСТ 2.105 с рамкой (по умолчанию)"
    echo "  2 / disser — Диссертация ГОСТ Р 7.0.11"
    echo "  3 / book   — Книга / методическое пособие"
    exit 1
fi

INPUT_MD="$1"
VARIANT="${2:-eskd}"

# Нормализация варианта
case "$VARIANT" in
    1|eskd|eskd_fo) VARIANT="eskd" ;;
    2|disser)       VARIANT="disser" ;;
    3|book)         VARIANT="book" ;;
    *)
        echo "${RED}Ошибка: неизвестный вариант '$VARIANT'${NC}"
        echo "Допустимые: 1/eskd, 2/disser, 3/book"
        exit 1
        ;;
esac

# --- Проверка входного файла ---
if [[ ! -f "$INPUT_MD" ]]; then
    echo "${RED}Ошибка: файл '$INPUT_MD' не найден${NC}"
    exit 1
fi

# --- Проверка зависимостей ---
for cmd in pandoc pdflatex biber; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "${RED}Ошибка: '$cmd' не найден. Установите зависимости.${NC}"
        echo "  TinyTeX: curl -sL 'https://yihui.org/tinytex/install-bin-unix.sh' | sh"
        echo "  pandoc:  скачайте с https://github.com/jgm/pandoc/releases"
        exit 1
    fi
done

# --- Подготовка путей ---
INPUT_BASENAME=$(basename "$INPUT_MD" .md)
INPUT_DIR=$(cd "$(dirname "$INPUT_MD")" && pwd)
BUILD_DIR="$SCRIPT_DIR/build/${INPUT_BASENAME}"
OUTPUT_PDF="$SCRIPT_DIR/output/${INPUT_BASENAME}.pdf"

# --- Автоматическое определение метаданных документа ---
# Определяем номер документа из имени файла
DOC_NUMBER=""
DOC_TITLE_FULL=""
DOC_TITLE_SHORT=""
DOC_RAZRAB="Жданов"
DOC_YTVERD="Оглизнев"
DOC_NCONTROL="Жданов"
DOC_YEAR="2026"

case "$INPUT_BASENAME" in
    *РЕГ-4-2*)
        DOC_NUMBER="РЕГ-4-2"
        DOC_TITLE_FULL="Руководство по эксплуатации медицинского изделия"
        DOC_TITLE_SHORT="Руководство по эксплуатации МИ"
        ;;
    *РЕГ-5*)
        DOC_NUMBER="РЕГ-5"
        DOC_TITLE_FULL="Руководство по интеграции в PACS"
        DOC_TITLE_SHORT="Руководство по интеграции в PACS"
        ;;
    *РЕГ-6*)
        DOC_NUMBER="РЕГ-6"
        DOC_TITLE_FULL="Руководство по эксплуатации платформы"
        DOC_TITLE_SHORT="Руководство по эксплуатации платформы"
        ;;
    *РЕГ-7*)
        DOC_NUMBER="РЕГ-7"
        DOC_TITLE_FULL="Паспорт медицинского изделия"
        DOC_TITLE_SHORT="Паспорт МИ"
        ;;
    *ТПД-1-3*|*ТПД-1*)
        DOC_NUMBER="ТПД-1-3"
        DOC_TITLE_FULL=$(head -5 "$INPUT_MD" | grep -m1 '^#' | sed 's/^#\+\s*//' | sed 's/^[^:]*:\s*//')
        DOC_TITLE_SHORT="$DOC_TITLE_FULL"
        ;;
    *ТПД-*)
        # Извлекаем номер ТПД из имени файла
        DOC_NUMBER=$(echo "$INPUT_BASENAME" | grep -oE 'ТПД-[0-9]+-[0-9]+|ТПД-[0-9]+')
        DOC_TITLE_FULL=$(head -5 "$INPUT_MD" | grep -m1 '^#' | sed 's/^#\+\s*//' | sed 's/^[^:]*:\s*//')
        DOC_TITLE_SHORT="$DOC_TITLE_FULL"
        ;;
    *)
        DOC_NUMBER="$INPUT_BASENAME"
        DOC_TITLE_FULL=$(head -5 "$INPUT_MD" | grep -m1 '^#' | sed 's/^#\+\s*//' | sed 's/^[^:]*:\s*//')
        DOC_TITLE_SHORT="$DOC_TITLE_FULL"
        ;;
esac

# Если заголовок не определён — используем имя файла
if [[ -z "$DOC_TITLE_FULL" ]]; then
    DOC_TITLE_FULL="$INPUT_BASENAME"
    DOC_TITLE_SHORT="$INPUT_BASENAME"
fi

echo "${GREEN}=== md2pdf ===${NC}"
echo "  Входной файл: $INPUT_MD"
echo "  Вариант:      $VARIANT"
echo "  Документ:     $DOC_NUMBER — $DOC_TITLE_FULL"
echo "  Сборка в:     $BUILD_DIR"
echo ""

# --- Создание рабочей директории ---
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$SCRIPT_DIR/output"

# --- Предобработка MD (fix_md.py) ---
PREPROCESSED_MD="$BUILD_DIR/preprocessed.md"
python3 "$SCRIPT_DIR/fix_md.py" "$INPUT_MD" "$PREPROCESSED_MD"

# --- Конвертация MD → LaTeX (только тело документа) ---
echo "${YELLOW}[1/4] Конвертация Markdown → LaTeX...${NC}"

pandoc "$PREPROCESSED_MD" \
    --from markdown \
    --to latex \
    --top-level-division=chapter \
    --wrap=none \
    -o "$BUILD_DIR/content.tex"

# --- Пост-обработка LaTeX: удаление несовместимых конструкций pandoc ---
# Убираем \def\LTcaptype{none} — вместо этого определяем counter 'none' в macros
# (уже сделано через \newcounter{none})

# --- Пост-обработка таблиц: добавление вертикальных линий (ЕСКД) ---
python3 -c "
import re, sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    text = f.read()

# Добавить | к простым спецификациям колонок: @{}lll@{} -> |l|l|l|
text = re.sub(
    r'@\{\}(l+)@\{\}',
    lambda m: '|' + '|'.join(m.group(1)) + '|',
    text
)

# Добавить | к сложным спецификациям (p-колонки):
# Открывающий @{} -> |
text = re.sub(r'\[\]\{@\{\}\s*\n', '[]{|\n', text)
# Между колонками: }}\\n  > -> }}|\\n  >
text = re.sub(r'(\\\\real\{[\d.]+\}\})\n(  >)', r'\1|\n\2', text)
# Закрывающий @{}} -> |}
text = text.replace('@{}}', '|}')

with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(text)
" "$BUILD_DIR/content.tex"

# --- Генерация preamble.inc.tex ---
echo "${YELLOW}[2/4] Генерация шаблона ($VARIANT)...${NC}"

case "$VARIANT" in
    eskd)
        cat > "$BUILD_DIR/preamble.inc.tex" << PREAMBLE_ESKD
\\sloppy

\\renewcommand\\orgName      {ООО <<ВизиоМедИИ>>}
\\renewcommand\\decim        {}
\\renewcommand\\docTypeFull  {}
\\renewcommand\\docType      {${DOC_NUMBER}}
\\renewcommand\\devNameFull  {${DOC_TITLE_SHORT}}
\\renewcommand\\devName      {}
\\renewcommand\\razrab       {${DOC_RAZRAB}}
\\renewcommand\\prover       {}
\\renewcommand\\nControl     {${DOC_NCONTROL}}
\\renewcommand\\ytverd       {${DOC_YTVERD}}

\\NSLHaveLRIfalse
\\NSLHaveLYfalse
\\NSLHaveESKDFrametrue

\\usepackage{lscape}
PREAMBLE_ESKD

        # Генерация rpz.tex для ЕСКД
        cat > "$BUILD_DIR/rpz.tex" << 'RPZ_ESKD'
\documentclass[14pt]{../sty/NSLReport}
\RequirePackage{../sty/NSLExtra}
\RequirePackage{../sty/NSLEskd}

\include{preamble.inc}
\include{macros.inc}

\begin{document}

\include{00-title}

\ifNSLHaveESKDFrame
\makeatletter
\def\@oddhead{\zaglavFrame}
\def\@oddfoot{}
\makeatother
\fi

\setcounter{tocdepth}{0}
\tableofcontents
\clearpage

\ifNSLHaveESKDFrame
\makeatletter
\def\@oddhead{\posledFrame}
\def\@oddfoot{}
\makeatother
\fi

\include{content}

\ifNSLHaveLRI%
\include{98-lri}
\fi%

\ifNSLHaveLY%
\include{99-ly}
\fi%

\end{document}
RPZ_ESKD

        # Генерация титульной страницы ЕСКД
        cat > "$BUILD_DIR/00-title.tex" << TITLE_ESKD

\\ifNSLHaveESKDFrame
\\makeatletter
\\def\\@oddhead{\\titleFrame}
\\def\\@oddfoot{}
\\makeatother
\\fi

\\hfill
\\vspace{20mm}

\\hfill
\\parbox[t]{.45\\linewidth}{
   УТВЕРЖДАЮ\\\\
   Директор ООО <<ВизиоМедИИ>>\\\\
   \\underline{\\hspace{20mm}} Оглизнев А.А.
}

\\vspace{40mm}

\\begin{centering}
	{\\bfseries ${DOC_TITLE_FULL} \\\\[3mm]
	${DOC_NUMBER}} \\\\
\\end{centering}

\\vfill

\\noindent Разработано: ${DOC_RAZRAB} А.А.\\\\
Должность: Директор по качеству

\\vspace{5mm}

\\begin{centering}
${DOC_YEAR}
\\end{centering}

\\vspace{10mm}

\\ifNSLHaveESKDFrame
\\clearpage
\\makeatletter
\\def\\@oddhead{}
\\def\\@oddfoot{}
\\makeatother
\\fi

TITLE_ESKD
        cp "$SCRIPT_DIR/examples/eskd_fo/98-lri.tex" "$BUILD_DIR/" 2>/dev/null || true
        cp "$SCRIPT_DIR/examples/eskd_fo/99-ly.tex" "$BUILD_DIR/" 2>/dev/null || true
        ;;

    disser)
        cat > "$BUILD_DIR/preamble.inc.tex" << 'PREAMBLE_DISSER'
\sloppy
\addbibresource{rpz.bib}
PREAMBLE_DISSER

        cat > "$BUILD_DIR/rpz.tex" << 'RPZ_DISSER'
\documentclass[14pt]{../sty/NSLReport}
\RequirePackage{../sty/NSLExtra}
\RequirePackage{../sty/NSLDisser}

\include{preamble.inc}
\include{macros.inc}

\begin{document}

\tableofcontents

\include{content}

\end{document}
RPZ_DISSER
        ;;

    book)
        cat > "$BUILD_DIR/preamble.inc.tex" << 'PREAMBLE_BOOK'
\sloppy
\addbibresource{rpz.bib}
PREAMBLE_BOOK

        cat > "$BUILD_DIR/rpz.tex" << 'RPZ_BOOK'
\documentclass[14pt]{../sty/NSLReport}
\RequirePackage{../sty/NSLExtra}
\RequirePackage{../sty/NSLBook}

\include{preamble.inc}
\include{macros.inc}

\begin{document}

\setcounter{tocdepth}{3}
\tableofcontents

\include{content}

\end{document}
RPZ_BOOK
        ;;
esac

# Симлинк на директорию стилей (чтобы ../sty/ работало из build/NAME/)
ln -sfn "$SCRIPT_DIR/sty" "$SCRIPT_DIR/build/sty"

# Общие файлы
cat > "$BUILD_DIR/macros.inc.tex" << 'MACROS'
% Пакеты для совместимости с pandoc-таблицами
\usepackage{array}
\usepackage{booktabs}
\usepackage{calc}
\newcounter{none}
% Определение команд pandoc
\providecommand{\tightlist}{\setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}

% Стиль таблиц по ЕСКД: линии-разделители вместо booktabs
\renewcommand{\toprule}{\hline}
\renewcommand{\midrule}{\hline}
\renewcommand{\bottomrule}{\hline}
\renewcommand{\arraystretch}{1.4}
MACROS

# Пустой bib-файл (если нет ссылок)
touch "$BUILD_DIR/rpz.bib"

# Копируем изображения из исходной директории (если есть)
if [[ -d "$INPUT_DIR/graphics" ]]; then
    cp -r "$INPUT_DIR/graphics" "$BUILD_DIR/"
fi
mkdir -p "$BUILD_DIR/graphics/img" "$BUILD_DIR/graphics/svg" "$BUILD_DIR/inc"

# --- Сборка PDF ---
echo "${YELLOW}[3/4] Сборка PDF (pdflatex + biber)...${NC}"

cd "$BUILD_DIR"

# Первый проход pdflatex
if ! pdflatex -interaction=nonstopmode rpz.tex > pdflatex1.log 2>&1; then
    echo "${YELLOW}  Первый проход pdflatex: есть предупреждения (это нормально)${NC}"
fi

# biber
if ! biber rpz > biber.log 2>&1; then
    echo "${YELLOW}  biber: есть предупреждения (это нормально)${NC}"
fi

# Второй проход
if ! pdflatex -interaction=nonstopmode rpz.tex > pdflatex2.log 2>&1; then
    echo "${YELLOW}  Второй проход pdflatex: есть предупреждения${NC}"
fi

# Третий проход (для оглавления)
if ! pdflatex -interaction=nonstopmode rpz.tex > pdflatex3.log 2>&1; then
    echo "${YELLOW}  Третий проход pdflatex: есть предупреждения${NC}"
fi

# --- Проверка результата ---
if [[ -f "$BUILD_DIR/rpz.pdf" ]]; then
    cp "$BUILD_DIR/rpz.pdf" "$OUTPUT_PDF"
    echo ""
    echo "${GREEN}[4/4] Готово!${NC}"
    echo "  PDF: $OUTPUT_PDF"
    echo ""
else
    echo ""
    echo "${RED}Ошибка сборки PDF. Проверьте логи:${NC}"
    echo "  $BUILD_DIR/pdflatex3.log"
    echo ""
    # Показываем последние ошибки
    grep -A2 '^!' "$BUILD_DIR/pdflatex3.log" 2>/dev/null | head -30
    exit 1
fi
