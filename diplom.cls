% !TeX encoding = UTF-8
%%
%% This is file diplom.cls
%% It is based on report.cls, adapted for XeLaTeX/LuaLaTeX
%%
%% Developed by: Aleksandr Maksimenko, maximenko.a.n@gmail.com
%% Modified by: Vladislav Kopnin, vlad.kopnen@mail.ru
%% Modified for bibnum counting: 2026
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{diplom}[2025/01/02 Modern diploma class for XeLaTeX/LuaLaTeX]

% Загружаем базовый класс report с переданными опциями
\LoadClassWithOptions{extreport}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Подключаем основные пакеты
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{xparse}
\RequirePackage{geometry}
\RequirePackage{setspace}
\RequirePackage{indentfirst}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage{caption}
\RequirePackage{enumitem}
\RequirePackage{amsmath,amssymb,mathtools}
\RequirePackage{amsthm}
\RequirePackage{totcount}
\RequirePackage{hyperref}
\RequirePackage{booktabs}
\RequirePackage{graphicx}
\RequirePackage{letltxmacro}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Шрифты и язык (XeLaTeX/LuaLaTeX)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{fontspec}
\setmainfont{Times New Roman}[Script=Cyrillic]
\setmonofont{DejaVu Sans Mono}[Scale=0.85]

\RequirePackage[english,russian]{babel}
\babelprovide[import, onchar=fonts ids]{russian}
\babelfont{rm}{Times New Roman}
\babelfont{tt}{DejaVu Sans Mono}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Геометрия страницы и интервалы
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\geometry{
  a4paper,
  left=3cm,
  right=1.5cm,
  top=2cm,
  bottom=2cm,
  bindingoffset=0cm
}

\onehalfspacing
\setlength{\parindent}{1.25cm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Оформление заголовков
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\titleformat{\chapter}[hang]
  {\normalfont\Large\bfseries}
  {\thechapter.\ }
  {0pt}
  {\normalfont\Large\bfseries}
\titlespacing{\chapter}{0pt}{1em}{3.5em}

\titleformat{\section}[hang]
  {\normalfont\normalsize\bfseries}
  {\thesection.\ }
  {0pt}
  {\normalfont\normalsize\bfseries}
\titlespacing{\section}{0pt}{1em}{1em}

\titleformat{\subsection}[hang]
  {\normalfont\normalsize\bfseries}
  {\thesubsection.\ }
  {0pt}
  {\normalfont\normalsize\bfseries}
\titlespacing{\subsection}{0pt}{1em}{1em}

\titleformat{\subsubsection}[hang]
  {\normalfont\normalsize\bfseries}
  {\thesubsubsection.\ }
  {0pt}
  {\normalfont\normalsize\bfseries}
\titlespacing{\subsubsection}{0pt}{1em}{1em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Оформление содержания
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\titlecontents{chapter}[0pt]
  {\vspace{0.5em}\bfseries}
  {\thecontentslabel.\ }
  {}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{section}[1.5em]
  {}
  {\thecontentslabel.\ }
  {}
  {\titlerule*[1pc]{.}\contentspage}
\titlecontents{subsection}[3.8em]
  {}
  {\thecontentslabel.\ }
  {}
  {\titlerule*[1pc]{.}\contentspage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Подписи к рисункам и таблицам
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareCaptionLabelSeparator{emdash}{~---~}
\captionsetup{
  justification=centering,
  labelsep=emdash,
  labelfont=bf
}
\DeclareCaptionLabelFormat{rtable}{\hfill #1~#2}
\captionsetup[table]{
  position=top,
  labelformat=rtable,
  labelsep=newline,
  textfont=bf,
  justification=centering,
  singlelinecheck=false
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Оформление списков
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setlist{noitemsep, leftmargin=\parindent}
\setlist[itemize]{label=--}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Счётчики для реферата
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\regtotcounter{page}
\newtotcounter{chapternum}
\newtotcounter{appnum}
\newtotcounter{fignum}
\newtotcounter{tablenum}

% Счётчик источников (ручное управление через .aux)
\newcounter{bibnum}
\providecommand{\total@bibnum}{0}
\newcommand{\getbibnum}{\@ifundefined{total@bibnum}{0}{\csname total@bibnum\endcsname}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Флаг для приложений и переопределение \chapter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifinappendix
\inappendixfalse

\LetLtxMacro{\originalchapter}{\chapter}

\renewcommand{\chapter}{%
  \@ifstar
    {\originalchapter*}%
    {%
      \ifinappendix
        \stepcounter{appnum}%
      \else
        \stepcounter{chapternum}%
      \fi
      \originalchapter
    }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Подсчёт рисунков и таблиц
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtBeginDocument{%
  \let\oldcaption=\caption
  \def\caption{%
    \def\floatf{figure}%
    \ifx\floatf\@captype
      \stepcounter{fignum}%
    \else
      \stepcounter{tablenum}%
    \fi
    \oldcaption
  }%
  \let\oldtableofcontents\tableofcontents
  \renewcommand{\tableofcontents}[1][\contentsname]{%
    \renewcommand{\contentsname}{#1}%
    \oldtableofcontents
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Оформление приложений
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\oldappendix=\appendix
\renewcommand{\appendix}{%
  \inappendixtrue
  \oldappendix
  \renewcommand{\thechapter}{\Asbuk{chapter}}
  \titleformat{\chapter}[display]
    {\normalfont\Large\bfseries}
    {\hfill\appendixname\ \thechapter}
    {0pt}
    {\normalfont\Large\bfseries\centering}
  \titlespacing{\chapter}{0pt}{0pt}{3.5em}
  \let\addcontentslineold=\addcontentsline
  \renewcommand{\addcontentsline}[3]{%
    \addcontentslineold{##1}{##2}{\appendixname~##3}%
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Команды для заполнения титульной страницы
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*{\LetterHead}[1]{\gdef\@LetterHead{#1}}
\newcommand*{\Kafedra}[1]{\gdef\@Kafedra{#1}}
\newcommand*{\Napr}[1]{\gdef\@Napr{#1}}
\newcommand*{\ZavKaf}[2]{\gdef\@ZavStatus{#1}\gdef\@ZavName{#2}}
\newcommand*{\DocumentType}[1]{\gdef\@DocumentType{#1}}
\newcommand*{\Title}[1]{\gdef\@Title{#1}}
\newcommand*{\Author}[2]{\gdef\@AuthorStatus{#1}\gdef\@AuthorName{#2}}
\newcommand*{\Chief}[2]{\gdef\@ChiefStatus{#1}\gdef\@ChiefName{#2}}
\newcommand*{\City}[1]{\gdef\@City{#1}}
\newcommand*{\Year}[1]{\gdef\@Year{#1}}

\newif\ifkursovaya
\kursovayafalse
\newcommand*{\Kursovaya}{\kursovayatrue}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Значения по умолчанию для титульной страницы
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LetterHead{\bfseries ВУЗ}
\Kafedra{Кафедра}
\Napr{Направление}
\ZavKaf{Заведующий кафедрой,\\ д.\,ф.-м.\,н., профессор}{С.\,С.~Сидоров}
\DocumentType{\large Выпускная квалификационная работа}
\Title{\Large\bfseries Название дипломной работы}
\Chief{Научный руководитель\\ к.\,ф.-м.\,н., доцент}{П.\,П.~Петров}
\Author{Студент группы ИТ-41БО}{И.\,И.~Иванов}
\City{Ярославль}
\Year{\the\year}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Блок подписи на титульной странице
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newlength{\VisaWidth}
\setlength{\VisaWidth}{6cm}
\newcommand*{\SignDate}{\\[3pt]<<\rule{1cm}{0.5pt}>>\hrulefill\ \@Year~г.}
\newcommand*{\SignBlock}[1]{%
   \hbox to \textwidth{%
   \hfill%
   \begin{minipage}[t]{\VisaWidth}
     \begin{flushright}
       #1
     \end{flushright}
   \end{minipage}%
   }%
}
\newcommand*{\StandardSign}[2]{%
    \SignBlock{#1\\
	\hrulefill\ #2
	\SignDate}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Титульная страница
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand*{\maketitle}{%
\begin{titlepage}
	\hypersetup{pdftitle=\@Title, pdfauthor=\@AuthorName}
	\begin{center}
	  {\@LetterHead}\\[0.5\baselineskip]
	  {\@Kafedra}\\[0.5\baselineskip]
	\end{center}
	\vspace{0.5\baselineskip}
    \noindent\hfill
		\SignBlock{Сдано на кафедру \SignDate\\
		\@ZavStatus\\
		\hrulefill\ \@ZavName}
	\vspace{1.1\baselineskip}
	\begin{center}
	    {\@DocumentType\\[1\baselineskip]}
		{\bfseries \@Title\\[1\baselineskip]}
  		{\@Napr}\\
	\end{center}
	\vspace{0.5\baselineskip}
	\StandardSign{\@ChiefStatus}{\@ChiefName}
	\vspace{2.5\baselineskip}
	\StandardSign{\@AuthorStatus}{\@AuthorName}
	\vfill\strut
	\centerline{\@City\ \@Year\ г.}
\end{titlepage}
\setcounter{page}{2}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Реферат и ключевые слова
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\Keywords}[1]{\gdef\@keywords{#1}}
\renewenvironment{abstract}{%
  \chapter*{Реферат}%
  \noindent
  Объем \total{page}~с., \total{chapternum}~гл., \total{fignum}~рис.,
  \total{tablenum}~табл., \getbibnum~источников, \total{appnum}~прил.%
  \par\medskip
  \noindent
  Ключевые слова: \textbf{\@keywords}%
  \par\medskip
  \noindent
  \ignorespaces
}{%
  \clearpage
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Библиография (biblatex + biber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[backend=biber, style=gost-numeric, sorting=none, language=auto, autolang=other]{biblatex}
\renewcommand{\bibname}{Список литературы}
\defbibheading{bibliography}[\bibname]{%
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{#1}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Подсчёт количества использованных источников
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\makeatletter
\defbibenvironment{countbib}
  {\setcounter{bibnum}{0}%
   \renewcommand{\blx@driver}[1]{}}
  {}
  {\stepcounter{bibnum}}

\newcommand{\countbibentries}{%
  \ifcsname printbibliography\endcsname
    \printbibliography[heading=none, env=countbib, title={}, resetnumbers=false]%
  \fi
}

% Записываем значение в .aux после подсчёта
\AtEndDocument{%
  \countbibentries
  \immediate\write\@auxout{\string\gdef\string\total@bibnum{\the\value{bibnum}}}%
}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ненумерованная глава
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\chapternonum}[1]{%
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{#1}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Настройка стиля ненумерованных глав
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\titleformat{name=\chapter,numberless}[display]
{\normalfont\bfseries\centering}
{}
{0pt}
{\bfseries\centering\fontsize{16pt}{18pt}\selectfont}
\titlespacing*{name=\chapter,numberless}{0pt}{0pt}{0.5em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Переопределение верхнего отступа для ненумерованных глав
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\def\@makeschapterhead#1{%
	{\parindent \z@ \centering
		\normalfont
		\bfseries
		\fontsize{16pt}{18pt}\selectfont
		#1\par\nobreak
		\vskip 0.5em
}}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Переопределение верхнего отступа для нумерованных глав
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\def\@makechapterhead#1{%
	{\parindent \z@
		\normalfont
		\bfseries
		\fontsize{16pt}{18pt}\selectfont
		\ifnum \c@secnumdepth >\m@ne
		\thechapter.\quad #1\par\nobreak
		\else
		#1\par\nobreak
		\fi
		\vskip 1em
}}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Математические макросы
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\counterwithout{equation}{chapter}
\providecommand\given{}
\newcommand\SetSymbol[1][]{%
  \nonscript\:#1\vert
  \allowbreak \nonscript\: \mathopen{}}
\DeclarePairedDelimiterX\Set[1]\{\}{%
  \renewcommand\given{\SetSymbol[\delimsize]} #1}
\DeclarePairedDelimiterXPP\Pb[1]{\mathsf{P}}(){}{
  \renewcommand\given{\nonscript\:\delimsize\vert\nonscript\:\mathopen{}} #1}

\endinput
