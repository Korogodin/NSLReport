% This package designed and commented in Russian (utf-8 encoding).
%
% Лицензия GNU GPL v2 и совместимые
%
% Базовый стиль документов Лаборатории навигационных систем,
% предназначен для реализации:
% - текстовых документов по ГОСТ 2.105 (с основной надписью и без).
% - отчетов НИР по ГОСТ 7.32
% - пояснительных записок и диссертаций
% - книги?
%
% Основан на стандартном report.cls и совместим с ним по интерфейсу, не подключает дополнительные пакеты.
% Все дополнительные пакеты вынесены в NSLExtra, который следует подключаться после \documentclass[14pt]{NSLReport}
% Для оформления по ГОСТ после NSLExtra подключите стиль соответствующего типа документа, например, NSLDisser
%
% Исправляет относительно report:
%    - представление структурных элементов документа: главы, разделы, пункты;
%    - представление таблиц, рисунков, формул;
%    - отступы, поля, размеры страницы;
%    - перечисления нумерованные и нет;
%    - вид оглавления.
%
% Автор - Илья Корогодин
%
% Создан путем модификации report.cls из /usr/share/texlive/texmf-dist/tex/latex/base/report.cls 
%
% Вдохновлен стилем G2-105 за авторством Алексея Томина, Михаила Конника, Андрея Спицыны, Ивана Короткова и Всеволода Крищенко.
%
% Используется с texlive под Kubuntu 16.04+
%

\ProvidesClass{NSLReport}[2021/11/27 v1.00 NavSysLab modified report class]
\NeedsTeXFormat{LaTeX2e}


%%%% Тут у нас определяются опции класса
\newcommand\@ptsize{}

\newif\if@restonecol  
\newif\if@titlepage
\@titlepagetrue
\newif\if@openright

\if@compatibility\else % Иностранные форматы удалены
\DeclareOption{a3paper}{\setlength\paperheight{420mm}\setlength\paperwidth{297mm}}
\DeclareOption{a4paper}{\setlength\paperheight{297mm}\setlength\paperwidth{210mm}}
\DeclareOption{a5paper}{\setlength\paperheight{210mm}\setlength\paperwidth{148mm}}
\fi

\if@compatibility  % Расширен список размеров
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{12pt}{\renewcommand\@ptsize{1}}
\DeclareOption{14pt}{\renewcommand\@ptsize{4}}
\DeclareOption{15pt}{\renewcommand\@ptsize{5}}
\DeclareOption{16pt}{\renewcommand\@ptsize{6}}
\DeclareOption{17pt}{\renewcommand\@ptsize{7}}

\if@compatibility\else % Может дойти до оформления книги или каких-то руководств на базе этого стиля
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}

\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi

\DeclareOption{titlepage}{\@titlepagetrue} % А вдруг мы методику или т.п. без титульника будем делать
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi

\if@compatibility % Оставлю для совместимости с report
\else
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\fi

\if@compatibility\else % Оставлю для совместимости с report
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}

\DeclareOption{leqno}{\input{leqno.clo}} % Что-то из report, не разбирался
\DeclareOption{fleqn}{\input{fleqn.clo}}

\DeclareOption{openbib}{%   % Что-то из report, не разбирался
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}

\ExecuteOptions{a4paper,14pt,oneside,onecolumn,final,openany}
\ProcessOptions

\input{size1\@ptsize.clo}
%%%%% -----------------------------------------------------


\setlength\lineskip{1\p@}                
\setlength\normallineskip{1\p@}           


\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}   
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2} 
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3} 
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}


\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\thepage\hfil\slshape\leftmark}%
      \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter. \ %
        \fi
        ##1}}{}}%
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\z@
          \thesection. \ %
        \fi
        ##1}}}}
\else % оставалась только эта
  \def\ps@headings{%
    \let\@oddfoot\@empty
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter. \ %
        \fi
        ##1}}}}
\fi


\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble
}



% Титульная страница
\if@titlepage
  \newcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\LARGE \@title \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}

\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}
\fi



%
%% Счётчики общего числа страниц, таблиц, рисунков и источников
%\newcounter{totalpage}
%\newcounter{totaltable} \setcounter{totaltable} {0}
%\newcounter{totalfigure}\setcounter{totalfigure}{0}
%\newcounter{totalbib}   \setcounter{totalbib}   {0}
%\newif\if@tablesonchapter \@tablesonchapterfalse
%\newif\if@figuresonchapter\@figuresonchapterfalse
%
%% На последней странице ставятся метки с номерами
%%  - последней страницы
%%  - числа таблиц, имеющих caption
%%  - числа рисунков, имеющих caption
%\def\totalobjects@putlabel{%
% \addtocounter{totalpage}  {\c@page}
% \addtocounter{totaltable} {\c@table}
% \addtocounter{totalfigure}{\c@figure}
% \addtocounter{totaltable} {-1}
% \addtocounter{totalfigure}{-1}
% \addtocounter{totalbib}{-1}
% \refstepcounter{totalpage}  \label{reftotalpages}
% \refstepcounter{totaltable} \label{reftotaltables}
% \refstepcounter{totalfigure}\label{reftotalfigures}
% \refstepcounter{totalbib}   \label{reftotalbibs}
%}
%\AtEndDocument{\totalobjects@putlabel}
%
%% Команды отображение общего числа ...
%\newcommand\totalpages  {\pageref{reftotalpages}}
%\newcommand\totaltables {\ref{reftotaltables}   }
%\newcommand\totalfigures{\ref{reftotalfigures}  }
%\newcommand\totalbibs   {\ref{reftotalbibs}     }
%
%% Другая реализация обсчета рисунков и таблиц.
%\RequirePackage{lastpage}                   % Пакет для подсчета общего числа страниц
%\newcounter{totfigures}
%\newcounter{tottables}
%\newcounter{totappendices}
%\newcounter{totbiblio}
%
%\setcounter{totfigures}{0}
%\setcounter{tottables}{0}
%\setcounter{totappendices}{0}
%\setcounter{totbiblio}{0}
%
%
%\providecommand\totfig{\number\value{totfigures}}%
%\providecommand\tottab{\number\value{tottables}}%
%\providecommand\totapp{\number\value{totappendices}}%
%\providecommand\totbib{\number\value{totbiblio}}%
%
%\AtEndDocument{%
%  \addtocounter{totfigures}{\value{figure}}%
%  \addtocounter{tottables}{\value{table}}%
%  \ifNSL@HaveAppendices%
%  \addtocounter{totappendices}{\value{chapter}}%
%  \fi%
%  \addtocounter{totbiblio}{\value{biblio}}%
%  \immediate\write\@mainaux{%
%    \string\gdef\string\totfig{\number\value{totfigures}}%
%    \string\gdef\string\tottab{\number\value{tottables}}%
%    \string\gdef\string\totapp{\number\value{totappendices}}%
%    \string\gdef\string\totbib{\number\value{totbiblio}}%
%  }%
%}


% Абзацный отступ: 
%       - 15..17 мм в ГОСТ 2.105 
%       - 12.5 мм в ГОСТ 7.0.11 и 7.32
\setlength\parindent{12,5mm}  % в report отсутсвует, потребуется переопределить для ГОСТ 2.105

%%%% Структурные элементы документа
%
% К сожалению, у разныех документов разные названия структурных элементов
% В текстовых документах по ГОСТ 2.105: раздел, подраздел, пункт, подпункт
% В отчете НИР по ГОСТ 7.32: глава, ...и кажется, раздел, подраздел
% В диссертации по ГОСТ Р 7.0.11 все сложно, но у нас принято сводить к главе, разделу, подразделу
% Есть ТЗ, методики, контракты, в которых появляются разделы, подразделы, а в них живут пункты, подпункты с многосточным текстом
%
% Введем \chapter, \section, \subsection, \subsubsecton, \subsubsection, а потом попытаемся их дополнить пунктами/подпунктами в стиле ТЗ


%%  Команды для подстройки вида заголовков:
%%   расстояние между заголовком и текстом
\newlength\NSLAfterTitleSkip     \setlength\NSLAfterTitleSkip    {1.2ex}%5mm}
\newlength\NSLBetweenTitleSkip   \setlength\NSLBetweenTitleSkip  {1.8ex}%8mm}

\newlength\NSLBeforTitleSkip     \setlength\NSLBeforTitleSkip    {3.2ex}%\NSLAfterTitleSkip}
\newlength\NSLBeforNoTitleSkip   \setlength\NSLBeforNoTitleSkip  {1.0ex}
\newlength\NSLHTitleSpace        \setlength\NSLHTitleSpace       {2mm}
\newlength\NSLTitleIndent        \setlength\NSLTitleIndent       {\parindent}
\newlength\NSL@ChapterIndent     \setlength\NSL@ChapterIndent    {\NSLTitleIndent}
\newlength\NSL@MainChapterIndent \setlength\NSL@MainChapterIndent{\parindent}
\newlength{\NSL@TitleDropSkip}   \setlength\NSL@TitleDropSkip{\NSLBetweenTitleSkip}
                                    \addtolength\NSL@TitleDropSkip{-\NSLAfterTitleSkip}
                                    
%%  стиль всех заголовков, \normalfont оставлен
\newcommand\NSLTitleStyle{\normalfont\bfseries}
\newcommand\NSL@MainChapterStyle{\large\bfseries}
\newcommand\NSL@StructChapterStyle{\large\bfseries\centering}
\newcommand\NSL@ChapterStyle{\NSL@MainChapterStyle}


% Part как она была в report, оставляю для совместимости
\newcounter{part}
\newcommand\part{%
    \clearpage
  \thispagestyle{plain}%
  \null\vfil
  \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\partname~\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       \huge\bfseries \partname\nobreakspace\thepart
       \par
       \vskip 20\p@
     \fi
     \Huge \bfseries #2\par}%
    \@endpart}
\def\@spart#1{%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \Huge \bfseries #1\par}%
    \@endpart}
\def\@endpart{\vfil\newpage}



\newcommand*\chaptermark[1]{}
\setcounter{secnumdepth}{5}                 % в report(?) было 2
\newcounter {chapter}                       % совпадает с 2-105
\newcounter {section}[chapter]              % совпадает с 2-105
\newcounter {subsection}[section]           % совпадает с 2-105
\newcounter {subsubsection}[subsection]     % совпадает с 2-105
\newcounter {paragraph}[subsubsection]      
\newcounter {subparagraph}[paragraph]
\renewcommand \thechapter        {\@arabic\c@chapter}                       % совпадает с 2-105
\renewcommand \thesection        {\ifnum \c@chapter>\z@ \thechapter.\fi\@arabic\c@section}           % совпадает с 2-105 
\renewcommand\thesubsection      {\thesection.\@arabic\c@subsection}        % совпадает с 2-105 
\renewcommand\thesubsubsection   {\thesubsection.\@arabic\c@subsubsection}  % совпадает с 2-105 
\renewcommand\theparagraph       {\ifnum \c@chapter>\z@ \thechapter.\fi\ifnum \c@section>\z@ \@arabic\c@section.\fi\ifnum \c@subsection>\z@ \@arabic\c@subsection.\fi\ifnum \c@subsubsection>\z@ \@arabic\c@subsubsection.\fi\@arabic\c@paragraph}
\renewcommand\thesubparagraph    {\theparagraph.\@arabic\c@subparagraph}
\newcommand\@chapapp             {\chaptername}



% Магия Главы из report.cls
% Из 2-105, было перед объявлением chapter:
%\newif\if@breakingbeforechapter\@breakingbeforechaptertrue

\newcommand\chapter{{\addtocounter{totfigures}{\value{figure}}}
                    {\addtocounter{tottables}{\value{table}}}
                     \if@openright\cleardoublepage\else\clearpage\fi
%                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindenttrue
                    \secdef\@chapter\@schapter}
%\newcommand\chapter{    %  Из 2-105
%    {\addtocounter{totfigures}{\value{figure}}}
%    {\addtocounter{tottables}{\value{table}}}
%    \if@breakingbeforechapter%
%    \clearpage%
%    \fi%
%    \if@figuresonchapter%
%    \addtocounter{totalfigure}{\c@figure}\setcounter{figure}{0}%
%    \fi%
%    \if@tablesonchapter%
%    \addtocounter{totaltable} {\c@table }\setcounter{table}{0}%
%    \fi%
%    \thispagestyle{plain}%
%    \global\@topnum\z@
%    \@afterindentfalse
%\secdef\@chapter\@schapter}

% Используется для chapter без звезды                    
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne                               % совпадает с 2-105 
                         \refstepcounter{chapter}%                             % совпадает с 2-105 
                         \typeout{\@chapapp\space\thechapter.}%                % совпадает с 2-105 
                         \addcontentsline{toc}{chapter}%                       % совпадает с 2-105 
                                   {\protect\numberline{\thechapter}#1}%       % совпадает с 2-105 
                    \else                                                      % совпадает с 2-105 
                      \addcontentsline{toc}{chapter}{#1}%                      % совпадает с 2-105 
                    \fi                                                        % совпадает с 2-105  
                    \chaptermark{#1}%                                          % совпадает с 2-105 
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%            % совпадает с 2-105 
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%            % совпадает с 2-105 
                    \if@twocolumn                                              
                      \@topnewpage[\@makechapterhead{#2}]%                     
                    \else                                                  
                      \@makechapterhead{#2}%                                   % совпадает с 2-105 
                      \@afterheading                                           % совпадает с 2-105 
                    \fi}
           
          
% Верстка заголовка chapter:                    
\def\@makechapterhead#1{%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \hspace{\NSL@ChapterIndent}\NSL@MainChapterStyle%
      \large \bfseries \thechapter \space
    \fi
    \interlinepenalty\@M
    \NSL@ChapterStyle{#1}\par\nobreak
    \vspace{\NSLAfterTitleSkip}
  }}
 
  
% Используется для chapter*
\def\@schapter#1{\if@twocolumn
                   \@topnewpage[\@makeschapterhead{#1}]%
                 \else
                   \addcontentsline{toc}{chapter}{#1}
                   \@makeschapterhead{#1}%
                   \@afterheading
                 \fi}
                 
% Верстка заголовка chapter*
\def\@makeschapterhead#1{%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    {\centering
    \large \bfseries  #1\par\nobreak % \Huge \bfseries  #1\par\nobreak
    }
    \vskip 5\p@
  }}

%Из 2-105:
%\def\@chapapp{} % blank chapter prefix
%
%\newcommand*\chaptermark[1]{}
%\newcommand*\apart[2]{\chapter {#2\label{#1}}}
%\newcommand*\cpart[2]{\chapter*{#2\label{#1}}}


% Магия раздела
\newcommand\section{\@startsection {section}{1}{\NSLTitleIndent} % как в 2-105
                                   {\NSLBeforTitleSkip}%
                                   {\NSLAfterTitleSkip}%
                                   {\NSLTitleStyle}}

% Магия подраздела
\newcommand\subsection{\@startsection{subsection}{2}{\NSLTitleIndent}%
                                     {\NSLBeforTitleSkip}%
                                     {\NSLAfterTitleSkip}%
                                     {\NSLTitleStyle}}
% Было в report:
%\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
%                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
%                                     {1.5ex \@plus .2ex}%
%                                     {\normalfont\bfseries}}
%%  Из 2-105 (пункт) 
%%  ... попадающий в оглавление
%\newcommand\subsection{%
% \@startsection{subsection}{2}%
% {\NSLTitleIndent}{\NSLBeforTitleSkip}{\NSLAfterTitleSkip}%
% {\NSLTitleStyle}%
%}
%\newcommand*{\apara}[2]{\subsection{#2\label{#1}}}
%%  ... не попадающий в оглавление
%\newcommand\nsubsection{%
% \par\vspace{\NSLBeforNoTitleSkip}%
% \refstepcounter{subsection}\thesubsection%
% \hspace{\NSLHTitleSpace}%
%}
%\newcommand*{\npara}[1]{\nsubsection\label{#1}}
                                     

% Магия подподраздела 
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\NSLTitleIndent}%
                                     {\NSLBeforTitleSkip}%
                                     {\NSLAfterTitleSkip}%
                                     {\NSLTitleStyle}}
% Было в report:
%\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
%                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
%                                     {1.5ex \@plus .2ex}%
%                                     {\normalfont\normalsize\bfseries}}
%%  Подпункт из 2-105
%%  ... попадающий в оглавление
%\newcommand\subsubsection{%
% \@startsection{subsubsection}{3}%
% {\NSLTitleIndent}{\NSLBeforTitleSkip}{\NSLAfterTitleSkip}%
% {\NSLTitleStyle}%
%}
%\newcommand*\asubpara[2]{\subsubsection{#2\label{#1}}}
%%  ... не попадающий в оглавление
%\newcommand\nsubsubsection{%
% \par\vspace{\NSLBeforNoTitleSkip}%
% \refstepcounter{subsubsection}\thesubsubsection%
% \hspace{\NSLHTitleSpace}%
%}
%\newcommand*\nsubpara[1]{\nsubsubsection\label{#1}}
 
                                     
% Магия параграфа из report.cls      (в 2-105 был закомментированный более навороченный вариант, но использовался этот )                          
%\newcommand\paragraph{\@startsection{paragraph}{3}{\z@}%   % только не 3, а 4 в 2-105
%                                    {0.3ex} % в report было 3.25ex \@plus1ex \@minus.2ex
%                                    {-1em}  % -1em
%                                    {\normalfont\normalsize}} % в report было {\normalfont\normalsize\bfseries}
                                    
\newcommand\paragraph{\secdef\@paragraph\@sparagraph}

% Используется для paragraph без звезды                    
\def\@paragraph[#1]#2{\refstepcounter{paragraph} 
                      %\par \@tempskipa -3.25ex\@plus -1ex \@minus -.2ex \relax
                      \@makeparagraphhead{#2}%
}
           
% Верстка paragraph в основном тексте
\def\@makeparagraphhead#1{%
%\noindent\space\space\theparagraph\space#1
{\noindent\raggedleft\theparagraph\interlinepenalty\@M\hspace{2mm}#1\hspace{-3mm} }
}

% Используется для paragraph*
\def\@sparagraph#1{\@makesparagraphhead{#1}}
% Верстка заголовка paragraph*
\def\@makesparagraphhead#1{#1}
  
  
% Магия подпараграфа из report.cls (совпадает с 2-105)
%\newcommand\subparagraph{\@startsection{subparagraph}{4}{\z@}% % только не 4, а 5 в 2-105
%                                       {0.3ex} % в report было 3.25ex \@plus1ex \@minus.2ex
%                                       {-1em}  % -1em
%                                      {\normalfont\normalsize}} % в report было {\normalfont\normalsize\bfseries}  

\newcommand\subparagraph{\secdef\@subparagraph\@ssubparagraph}

% Используется для subparagraph без звезды                    
\def\@subparagraph[#1]#2{\refstepcounter{subparagraph} 
                      \@makesubparagraphhead{#2}%                                   
                    }
           
% Верстка subparagraph в основном тексте
\def\@makesubparagraphhead#1{%
%\noindent\space\space\thesubparagraph\space#1
{\noindent\raggedleft\thesubparagraph\interlinepenalty\@M\hspace{2mm}#1\hspace{-3mm} }
}

% Используется для paragraph*
\def\@ssubparagraph#1{\@makessubparagraphhead{#1}}
% Верстка заголовка paragraph*
\def\@makessubparagraphhead#1{\noindent #1}



% Отступы и поля
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}         % совпадает с 2-105
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {0mm}            % в report было 2.2em
\setlength\leftmarginiii {1.87em}         % отсутствует в 2-105
\setlength\leftmarginiv  {1.7em}          % отсутствует в 2-105
\if@twocolumn
  \setlength\leftmarginv  {.5em}          % отсутствует в 2-105
  \setlength\leftmarginvi {.5em}          % отсутствует в 2-105
\else
  \setlength\leftmarginv  {1em}           % отсутствует в 2-105
  \setlength\leftmarginvi {1em}           % отсутствует в 2-105
\fi

\setlength  \labelsep  {.5em}             % совпадает с 2-105 
\setlength  \labelwidth{\leftmargini}     % совпадает с 2-105 
\addtolength\labelwidth{-\labelsep}       % совпадает с 2-105 

% Что-то, связаннное с разрывом строк
\@beginparpenalty -\@lowpenalty           % совпадает с 2-105 
\@endparpenalty   -\@lowpenalty           % совпадает с 2-105 
\@itempenalty     -\@lowpenalty           % совпадает с 2-105 



% Перечисления

% Из 2-105:
%\newlength{\NSLItemGap}
%\newlength{\NSLItemIndent}
%\newlength{\NSLItemNestedIndent}

%\newcommand\NSL@List{%
%    \setlength{\itemsep}{.5\parskip}%                пробел между последовательными элементами
%    \setlength{\topsep}{0mm}%                 отступ от текста до перечня (и от перечня до текста)
%    \setlength{\partopsep}{0mm}%              дополнительный отступ,  если начали абзац
%    \setlength{\listparindent}{\parindent}%   Красная строка
%    \setlength{\parsep}{\parskip}%                 расстояние между абзацами внутри пункта
%    \setlength{\leftmargin}{0mm}% левый отступ до текста
%    \setlength{\itemindent}{\NSLItemIndent}%             дополнительный левый отступ первой строчки
%    \setlength{\labelsep}{2\NSLItemGap}%     от метки до текста
%}
%
%\newcommand\NSL@NestedList{%
%    \setlength{\itemsep}{.5\parskip}%                пробел между последовательными элементами
%    \setlength{\topsep}{0mm}%                 отступ от текста до перечня (и от перечня до текста)
%    \setlength{\partopsep}{\parskip}%              дополнительный отступ,  если начали абзац
%    \setlength{\listparindent}{1.5em}%   Красная строка
%    \setlength{\parsep}{\parskip}%                 расстояние между абзацами внутри пункта
%    \setlength{\leftmargin}{\NSLItemNestedIndent}% левый отступ до текста
%    \setlength{\itemindent}{0mm}%             дополнительный левый отступ первой строчки
%    \setlength{\labelsep}{2\NSLItemGap}%     от метки до текста
%}
%


%\renewcommand{\@listI} {\NSL@List}
%\renewcommand{\@listii}{\NSL@NestedList}
%\renewcommand{\@listiii}{\NSL@NestedList}
%\renewcommand{\@listiv}{\NSL@NestedList}
%
%\setlength\NSLItemGap{1mm} % небольшие отступы для пунктов перечисления
%\setlength\NSLItemIndent{\parindent}
%\setlength\NSLItemNestedIndent{\parindent}
%\addtolength\NSLItemNestedIndent{0mm}

%  ненумерованные перечисления
\newcommand{\labelitemi}{~--}        % в report было \textbullet, в 2-105 \cdash---
\newcommand{\labelitemii}{~--}       % в report было \normalfont\bfseries \textendash
\newcommand{\labelitemiii}{~--}      % в report было \textasteriskcentered
\newcommand{\labelitemiv}{~--}       % в report было \textperiodcentered

%%  нумерованные перечисления
\renewcommand\theenumi{\asbuk{enumi}}               % в report было \@arabic\c@enumi, в 2-105 \asbuk{enumi}
\renewcommand\theenumii{\asbuk{enumii}}             % в report было \@alph\c@enumii, в 2-105 \arabic{enumii}
\renewcommand\theenumiii{\asbuk{enumiii}}           % в report было \@roman\c@enumiii, в 2-105 отсутствовало
\renewcommand\theenumiv{\@Alph\c@enumiv}            % в report было \textperiodcentered
\newcommand\labelenumi{\theenumi)}                  % в report было \textperiodcentered
\newcommand\labelenumii{(\theenumii)}               % в report было \textperiodcentered
\newcommand\labelenumiii{\theenumiii.}              % в report было \textperiodcentered
\newcommand\labelenumiv{\theenumiv.}                % в report было \textperiodcentered
\renewcommand\p@enumii{\theenumi}                   % в report было \textperiodcentered
\renewcommand\p@enumiii{\theenumi(\theenumii)}      % в report было \textperiodcentered
\renewcommand\p@enumiv{\p@enumiii\theenumiii}       % в report было \textperiodcentered


% Из 2-105:
%%  ссылка на нумерованное перечисление
%\newcommand*\pref[2]{%
% перечисление~\ref{#2})~\ref{#1}}
%
%%перечисление типа abbreviation - для списка сокращения
%%заменено на description для совместимости -- Коротков И.
%\newenvironment{description}{%
% \list{}{%
%  \labelwidth \z@ \leftmargin 0mm%
%  \let\makelabel\abbreviationlabel%
% }%
%}{%
% \endlist%
%}
%\newcommand*\abbreviationlabel[1]{\hspace\labelsep #1 \cdash---}% убран \normalfont



%\newlength{\NirTitleDropSkip}
%%  Эта команда должна вставлятся между двумя заголовками
%\newcommand\ttl{\vspace{\NSL@TitleDropSkip}}


% Дескрипшены мы не исользуем пока, оставлю для совместимости с report
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
                                
                                
% Абстракт как он был в report, но с правками
%\if@titlepage
%  \newenvironment{abstract}{%
%       blabla
%      \titlepage
%      \null\vfil
%      \@beginparpenalty\@lowpenalty
%      \begin{center}%
%        \bfseries \abstractname
%        \@endparpenalty\@M
%      \end{center}}%
%     {\par\vfil\null\endtitlepage}
%\else
  \newenvironment{abstract}{%
      \if@twocolumn
        \chapter*{\abstractname}% \section*{\abstractname}%
      \else
        \chapter*{\abstractname}
%        \small
%        \begin{center}%
%          {\bfseries \abstractname\vspace{-.5em}\vspace{\z@}}%
%        \end{center}%
%        \quotation
      \fi}
%      {\if@twocolumn\else\endquotation\fi}
%\fi


% Стихи, цитаты и т.п. из report
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
               
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
               
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
           


% Определение титульной страницы            
\if@compatibility
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi


% Приложения
\newcommand\appendix{\par
  \setcounter{secnumdepth}{4}
  \NSL@HaveAppendicestrue
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\Asbuk{chapter}} % В report было \@Alph\c@chapter
  % Добавляю из 2-105 в своей интерпретации:
  \gdef\@chapter[##1]##2{
    \ifnum \c@secnumdepth >\m@ne
      \refstepcounter{chapter}%
      \typeout{\@chapapp\space\thechapter.}%
      \addcontentsline{toc}{chapter}%
      {\@chapapp\space\protect\numberline{\thechapter}##1}%
    \else
      \addcontentsline{toc}{chapter}{##1}%
    \fi
    \chaptermark{##1}%
    \addtocontents{lof}{\protect\addvspace{10\p@}}%
    \addtocontents{lot}{\protect\addvspace{10\p@}}%
    \@makeappendixhead{##2}%
    \@afterheading
  }  
}

\def\@makeappendixhead#1{%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \hspace{\NSL@ChapterIndent}\NSL@MainChapterStyle%
      \large \bfseries \appendixname\space\thechapter. \space
    \fi
    \interlinepenalty\@M
    \NSL@ChapterStyle{#1}\par\nobreak
    \vspace{\NSLAfterTitleSkip}
  }
}
  
% Из 2-105
%\newif\ifNSL@HaveAppendices
%\NSL@HaveAppendicesfalse
%
%\newcommand\appendix{\par
%    \setcounter{secnumdepth}{4}
%    \NSL@HaveAppendicestrue
%    \setcounter{chapter}{0}%
%    \setcounter{section}{0}%
%    \EqInChapter\PicInChapter\TableInChapter%
%    \renewcommand\@chapapp{\appendixname}%
%    \gdef\thechapter{\Asbuk{chapter}}%
%    \renewcommand\NSL@ChapterStyle{\NSL@StructChapterStyle}%
%    \setlength\NSL@ChapterIndent{0mm}%
%    \let\@sect\NSL@old@sect%
%\renewcommand\@makechapterhead[1]{%
%  {\parindent \z@ \centering \normalfont
%    \ifnum \c@secnumdepth >\m@ne
%        \NSLTitleStyle\NSL@ChapterStyle \@chapapp\space\thechapter%
%    \fi
%    \par
%    \interlinepenalty\@M
%    \NSL@ChapterStyle{##1}\par\nobreak
%    \vspace{\NSLAfterTitleSkip}
%  }}
%}  
  
  
  
\setlength\arraycolsep{5\p@}          % совпадает с 2-105 (только сгруппировано выше было)
\setlength\tabcolsep{6\p@}            % совпадает с 2-105
\setlength\arrayrulewidth{.4\p@}      % совпадает с 2-105
\setlength\doublerulesep{2\p@}        % совпадает с 2-105
\setlength\tabbingsep{\labelsep}      % совпадает с 2-105

\skip\@mpfootins = \skip\footins      % отсутствует в 2-105
\setlength\fboxsep{3\p@}              % совпадает с 2-105
\setlength\fboxrule{.4\p@}            % совпадает с 2-105


% Формулы и ссылки на них:
\@addtoreset {equation}{chapter}
\renewcommand\theequation
  {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@equation}
%% Из 2-105:
%\newcommand\EqInChapter{%
% \@addtoreset{equation}{chapter}%
% \renewcommand{\theequation}{\thechapter.\arabic{equation}}%
%}

% Из 2-105:
\renewcommand\leq{\leqslant}  % Знаки меньше-равно в русском стиле
\renewcommand\geq{\geqslant}
%\AtBeginDocument{%  Думаю, это для самописного блока "где" под формулой (с перечислением параметров), не используем
% \makeatletter%
%  \setlength\NSL@EqRemLen{\textwidth}%
%  \addtolength\NSL@EqRemLen{-10mm}%
%  \settowidth\NSL@@EqRemLen{где}%
%  \addtolength\NSL@EqRemLen{-\NSL@@EqRemLen}%
% \makeatother%
%}  
  
  
% Рисунки  
\newcounter{figure}[chapter]  % в 2-105 не через PicInChapter
\renewcommand \thefigure
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@figure}
%\newcounter{figure}
%\newcommand\PicInChapter{%
%    \@addtoreset{figure}{chapter}%
%    \@figuresonchaptertrue%
%    \renewcommand{\thefigure}{\thechapter.\arabic{figure}}%
%} 
     
\def\fps@figure{tbp} % в 2-105: \def\fps@figure{bph}
\def\ftype@figure{1}
\def\ext@figure{lof} 
\def\fnum@figure{\figurename\nobreakspace\thefigure} % в 2-105: \figurename~\thefigure
\newenvironment{figure}                              % совпадает с 2-105
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}                             % совпадает с 2-105
               {\@dblfloat{figure}}
               {\end@dblfloat}


% Таблицы               
\newcounter{table}[chapter] % в 2-105 без chapter с добавлением его по TableInChapter ниже
\renewcommand \thetable
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@table}
\def\fps@table{tbp}     % в 2-105: bph
\def\ftype@table{2}     %  2-105: 1
\def\ext@table{lot}     % совпадает с 2-105
\def\fnum@table{\tablename\nobreakspace\thetable} %  2-105: \tablename~\thetable
\newenvironment{table}               % совпадает с 2-105
               {\@float{table}}
               {\end@float}
\newenvironment{table*}              % совпадает с 2-105
               {\@dblfloat{table}}
               {\end@dblfloat}
% Из 2-105:
%%  Подпись к таблице
%\addto\captionsrussian{\def\tablename{Таблица}}   %% И без этого Таблица
%% НЕ добавлена точка после таблицы. Крищенко
%
%\newcommand\TableInChapter{%
%    \@addtoreset{table}{chapter}%
%    \@tablesonchaptertrue%
%    \renewcommand{\thetable}{\thechapter.\arabic{table}}%
%}    


% Не знаю что это, но было только в report'е
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}

\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
  
 
%%для русского языка, взято из 2-105, в report отсутствует
\righthyphenmin=2
\unitlength=1mm
\clubpenalty=10000
\widowpenalty=10000

  
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
%% Из 2-105:
%% убран \normalfont из всех \DeclareOldFontCommand
%\DeclareOldFontCommand{\rm}{\rmfamily}{\mathrm}
%\DeclareOldFontCommand{\sf}{\sffamily}{\mathsf}
%\DeclareOldFontCommand{\tt}{\ttfamily}{\mathtt}
%\DeclareOldFontCommand{\bf}{\bfseries}{\mathbf}
%\DeclareOldFontCommand{\it}{\itshape}{\mathit}
%\DeclareOldFontCommand{\sl}{\slshape}{\@nomath\sl}
%\DeclareOldFontCommand{\sc}{\scshape}{\@nomath\sc}


\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}     % Совпадают с 2-105
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}



% Оглавление
\newcommand\@pnumwidth{1.55em} % совпадает с 2-105
\newcommand\@tocrmarg{2.55em} % отступ правого края оглавления перенесённых строк, совпадает с 2-105
\newcommand\@dotsep{4.5} % между точками в оглавлении в em, совпадает с 2-105

\setcounter{tocdepth}{2}
\newcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    }
%всякие оглавления - из 2-105
%\newcommand\tableofcontents{\chapter*{\contentsname}\@starttoc{toc}}%    
    
% Настройки верстки элементов в оглавлении
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi}

% Пафосный вариант из report.cls:
%\newcommand*\l@chapter[2]{%
%  \ifnum \c@tocdepth >\m@ne
%    \addpenalty{-\@highpenalty}%
%    \vskip 1.0em \@plus\p@
%    \setlength\@tempdima{1.5em}%
%    \begingroup
%      \parindent \z@ \rightskip \@pnumwidth
%      \parfillskip -\@pnumwidth
%      \leavevmode \bfseries
%      \advance\leftskip\@tempdima
%      \hskip -\leftskip
%      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
%      \penalty\@highpenalty
%    \endgroup
%  \fi}
\newcommand{\l@chapter}         {\@dottedtocline{1}{0mm}{1.2em}} % простой вариант из 2-105

%\newcommand*\l@section         {\@dottedtocline{1}{1.5em}{2.3em}} % так было в report
\newcommand*\l@section          {\@dottedtocline{1}{.8em}{2em}} 
%\newcommand{\l@section}        {\@dottedtocline{2}{.8em}{2em}}    % а так в 2-105
\newcommand*\l@subsection       {\@dottedtocline{2}{3.8em}{3.2em}} % так было в report
%\newcommand{\l@subsection}     {\@dottedtocline{3}{1.6em}{2.7em}}
\newcommand*\l@subsubsection    {\@dottedtocline{3}{7.0em}{4.1em}} % так было в report
%\newcommand{\l@subsubsection}  {\@dottedtocline{4}{2.4em}{3.5em}}
\newcommand*\l@paragraph        {\@dottedtocline{4}{10em}{5em}}    % так было в report
%\newcommand{\l@paragraph}      {\@dottedtocline{5}{3.2em}{4.8em}}
\newcommand*\l@subparagraph     {\@dottedtocline{5}{12em}{6em}}    % так было в report
%\newcommand{\l@subparagraph}   {\@dottedtocline{6}{5.0em}{4.8em}}

% Из 2-105 (было в разделе с пакетами, такого нет в report.cls
%\newcommand*{\l@figure}        {\@dottedtocline{1}{1.5em}{2.3em}}
%\newcommand*{\l@table}         {\@dottedtocline{1}{1.5em}{2.3em}}



% Список рисунков, мы не используем, оставляю для совместимости
\newcommand\listoffigures{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    }
    

% Список таблиц, мы не используем, оставляю для совместимости    
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    }
    
    
% Библиография из report.cls    
% Переведена на biblatex, пока работает из коробки без правок этого кода
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
     {\chapter*{\bibname}% В 2-105 без звездочки
      \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty      
% Из 2-105:
%%библиография
%\newcounter{biblio}
%\setcounter{biblio}{0}
%\newdimen\bibindent
%\newenvironment{thebibliography}[1]{
% \chapter{\bibname}%
% \list{\@biblabel{\@arabic\c@biblio}}%
%      {\settowidth\labelwidth{\@biblabel{#1}}%
%       \leftmargin\labelwidth
%       \advance\leftmargin\labelsep
%       \@openbib@code
%       \usecounter{biblio}%
%       \let\p@enumiv\@empty
%       \renewcommand\thebiblio{\@arabic\c@biblio}}%
% \sloppy\clubpenalty4000\widowpenalty4000%
% \sfcode`\.\@m
%}{
%%\setcounter{totbiblio}{\value{\c@biblio}}%
% \def\@noitemerr
% {\@latex@warning{Empty `thebibliography' environment}}%
% \endlist
%}
%\renewcommand\@biblabel{}%
%\setlength\bibindent{1.5em}
%
%% Точки после номеров в библиографии. Несовместимо с natbib! -- Коротков И.
%%\renewcommand*{\@biblabel}[1]{\hfill#1.}      
      
      
% Индекс, мы не используем, оставляю для совместимости с report.cls
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \twocolumn[\@makeschapterhead{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}


% Заметки в футере
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\@addtoreset{footnote}{chapter}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
    
    
% Есть только в report    
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\bibname{Bibliography}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\chaptername{Chapter}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}


% Есть только в report
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
  
  
\setlength\columnsep{10\p@}     % совпадают с 2-105
\setlength\columnseprule{0\p@}

\pagestyle{plain}               % совпадает с 2-105, но там задавалось в начале файла
\pagenumbering{arabic}

\if@twoside
\else
  \raggedbottom                 % совпадает с 2-105 для oneside
\fi

\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn                    % совпадает с 2-105 для oneside
\fi



% Названия обязательных разделов по-умолчанию
%\newcommand\TableOfContent{ %список исполнителей
% \chapter*{Оглавление}%
%}


\linespread{1.3} %полуторный межстрочный интервал

\setlength\parskip{0mm} % Дополнительное расстояние между абзацами

\endinput


%
%% Проценты в URL в библиографии
%\def\BibUrl{\url}
%
%\newcommand\AfterHyperrefFix{% issue #31 fix (https://github.com/latex-g7-32/latex-g7-32/issues/31) 
% \makeatletter
% \let\NSL@old@sect\@sect
% \def\@sect##1##2##3##4##5##6[##7]##8{%
%   \NSL@old@sect{##1}{##2}{##3}{##4}{##5}{}[{##7}]{%
%     ##6{##8}%
%   }%
% }
% \makeatother
%}
%
%%Чтобы избежать переопределения \cyrdash в bbl файле
%\def\FixBibliographyCyrdash{
%  \let\NSL@old@thebibliography\thebibliography
%  \renewenvironment{thebibliography}[1]{%
%    \let\NSL@old@ProvideTextCommandDefault\ProvideTextCommandDefault%
%    \let\ProvideTextCommandDefault\@gobbletwo%
%    \begin{NSL@old@thebibliography}{##1}%
%  }{
%    \end{NSL@old@thebibliography}%
%    \let\ProvideTextCommandDefault\NSL@old@ProvideTextCommandDefault%
%  }
%}
%

%
%\newcommand\MakeDashesBold{
%  \usepackage{trimclip}
%  \makeatletter
%  \let\NSL@old@cyrdash\cyrdash
%  \def\cyrdash{%
%    \ifdim\f@size pt>13pt%
%       \clipbox{0pt}{\hbox to .8em{\textbf{\NSL@old@cyrdash\hss}}}%
%    \else%
%       \NSL@old@cyrdash%
%    \fi%
%  }
%  \FixBibliographyCyrdash
%  \makeatother
%}
%
%\ifXeTeX
%\FixBibliographyCyrdash
%\fi
%
