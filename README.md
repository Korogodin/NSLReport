Система сборки LaTeX документов по российским ГОСТам
===========

Данный фреймворк используется в Лаборатории Навигационных Систем НИУ МЭИ для документов следующих типов: 
- ~~текстовые конструкторские и эксплуатационные документы по ЕСКД ГОСТ 2.105 с рамкой по ГОСТ 2.104 и без;~~ (coming soon, на переоформлении витрины)
- ~~отчеты о НИР по ГОСТ 7.32-2001 и ГОСТ РВ 15.110;~~ (coming soon)
- кандидатские и докторские диссертации по ГОСТ Р 7.0.11;
- пояснительные записки выпускных квалификационных работ; 
- техническое задание на НИР или ОКР по ГОСТ 15.016, ГОСТ РВ 15.201.

Для переключения между ЕСКД-документом, отчетом и диссертацией в головном файле требуется сменить стиль и титульную страницу. 
Доступны примеры документов.

Ориентирован на работников и студентов НавСисЛаб, принятые в лаборатории инструменты и практики:

- командная разработка документов в парадигме **[docs-as-code](https://www.writethedocs.org/guide/docs-as-code)**
- многократное повторное использование материала
- использование Ubuntu/Kubuntu в качестве ОС
- подготовка иллюстраций в формате svg, используя Inkscape
- использование TexMaker для написания документа
- для сборки документа используем pdflatex из texlive
- используется кодировка UTF-8
- минимизация и унификация списка используемых пакетов
- четкое разделение исходных кодов документа (директория tex) и фреймворка для сборки

Проект является переработанной версией **[latex-g7-32](https://github.com/latex-g7-32/latex-g7-32)**, за что огромное спасибо его авторам. 

Основные изменения относительно `latex-g7-32`:

- работа с документами разных типов, в том числе с многострадальной рамкой
- класс NSLReport полностью совместим со стандартным report, является базовым; легко дебажить проблемы переключением в стандартное окружение
- базовый класс ступенчато расширяется стилями до нужного типа документов
- в расширения входят must have пакеты (graphics, enumitem и т.д.), исправлены их конфликты, убрано неиспользуемое 
- при составлении документа не используются макросы фреймворка (пользователю не нужны специальные знания, облегчает повторное использование материала, части документа легко собираются в других системах, легче проходит конвертация в Word)
- исходные коды документа отдельно, файлы фреймворка отдельно; можно даже хранить и собирать несколько документов
- директории с изображениями поддерживают поддиректории 
- bibtex и natbib заменены на biber и biblatex, что решает проблемы с русскими символами в библиографии
- убраны зависимости от dia, dot, cmake, pkg-config, python


## Где посмотреть собранный пример?

С примерами в формате pdf можно ознакомиться в директории `examples`. 
Собранные версии документов отстают от исходных материалов, обновляются не каждый коммит. 

## Как собрать пример?

Можно начать со сборки примера

1. Установить texlive, inkscape и другие зависимости:
```sudo apt-get update
   sudo apt-get install -y
            latexmk \
            texlive-latex-extra \
            texlive-lang-cyrillic \
            texlive-luatex \
            texlive-extra-utils \
            cm-super \
            inkscape \
            imagemagick 
```

и далее по-обстоятельсвам. 

2. Разрешить imagemagick клепать pdf-ки, для чего поправить policies (можно руками):
```
sed -i 's/^.*policy.*coder.*none.*PDF.*//' /etc/ImageMagick-6/policy.xml
```

3. Форкнуть этот репозиторий, если вы планируете использовать отдельный репозиторий github для хранения документа

4. Склонировать или скачать репозиторий, например,

```
git clone https://github.com/Korogodin/NSLReport
```

5. Собрать пример
```
make
```

При первом запуске `make` будет создана директория `tex` с исходными файлами примера. 
Из них будет собран документ `tex/rpz.pdf`. 
Дальнейшие запуски команды `make` будут приводить к пересборке документа. 

Вы можете собрать примеры других документов, например `make example_nir`, `make example_eskd`, `make example_disser`.
Но сначала удалите директорию `tex`, чтобы скрипт не стеснялся создать её заново из примера. 

## Как составлять свой документ?

Самый простой вариант - начните править файлы в директории `tex`.

В ЛНС принято редактировать текст документа в TexMaker. 
В этом случае откройте `rpz.tex` и назначьте его мастер-документом (`Options->Define Curre...`). 
Теперь вы можете пересобирать документ простым нажатием `F1`.

В директорию `graphics` кладите изображения и схемы. 
Растровые - в `img`, векторные - в `svg`. 
При сборке они будут преобразованы в `pdf` и помещены в `inc`.
**Не кладите** изображения в `inc`, это временная директория. 
Она будет удалена по команде `make clean`!

Когда вы добавили новое изображение и подключили его в документе с помощью `includegraphics`, то пересоберите документ командой `make`. 
Это сконвертирует ваше изображение и перенесет результат в `inc`. 
После этого опять можно пересобирать документ по-быстрому в TexMaker. 

Вы можете разбивать документ на несколько `.tex` файлов. 
Называйте их по шаблону `dd-name.tex`, где `dd` - пара арабских цифр. 
Чем раньше этот файл используется в документе, тем меньше должна быть цифра. 
Так при упорядочивании файлов по имени они сохранят парядок изложения. 
А ещё, так система сборки поймет, что для этих файлов нужно подготовить изображения. 

Описание источников литературы добавляется в файл `rpz.bib` в формате BibTeX. 
Фреймворк использует `biblatex` и `biber`, кодировку `utf8`.

