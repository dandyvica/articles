If you don't know *Lateχ* (pronounced Lay-teck, because the last letter is the Greek letter Chi χ), you definitely have to. For professional looking documents, letters, resumes, articles, it's one of the best document production system on earth. To get an idea of its power: https://en.wikipedia.org/wiki/LaTeX

It has nothing to do traditional *WYSIWYG* software. It more relates to a traditional compiler, where source code language is *Lateχ* and compilation output is generally a PDF file (but can also be a DVI or PostScript one). *Lateχ* is extensible using packages, for almost everything. It is very popular among scientists because of its rich and powerful science symbols library.

The number of *Lateχ* documents, tutorials, references etc is literally staggering. Just google them to get the full power of it. My goal is not to add another one, but rather help you to design a good-looking one page letter.

## Installing Latex on Linux

```console
$ sudo apt-get install texlive-full
```
This is a full blown installation, maybe bloated (around 5GB is installed), with all world languages  and lots of packages you'll probably never use. But this is much simpler to deal with IMHO.

## Choosing an editor
On Linux, *TexStudio* is my favorite. Intuitive and already configured, its fast and efficient. It sports syntax color highlighting, shortcuts for most common definitions, wizards, etc. Available for a host of distributions, just download the relevant package and install it: https://www.texstudio.org/

## Designing a letter
Every *Lateχ* document is starting with a preamble:

```tex
% define a new A4 document with 12pt font size
\documentclass[a4paper,12pt]{article}
```

For english-spoken fellows, you can change *a4paper* with *letterpaper* which is the default page size.

After that, a list of packages needed to get the desired effects are loaded:

```tex
% define a new A4 document with 12pt font size
\documentclass[a4paper,12pt]{article}

% for mobile phone etc symbols
\usepackage{marvosym}
	
% set margins with no header and no footer
\usepackage[left=1.9cm,top=2cm,bottom=2.5cm,right=1.9cm,nohead,nofoot]{geometry}

% if fancy tables are needed
\usepackage{array}

% if colors are needed
\usepackage{color}

% Latex can't use TrueType fonts out of the box
% to use TrueType fonts, use this package. 
% Caveat: need to compile with XeLatex
\usepackage{fontspec}
\setmainfont{Linux Libertine O}

% no page numbers
\pagestyle{empty}

% for images and image files list of search paths
\usepackage{graphicx}
\graphicspath{{.}{../../../Photos/}}

% no paragraph identation (or change it to whatever is needed)
\setlength{\parindent}{0pt}

% space between paragraphs
\setlength{\parskip}{11pt}

% interline space
\linespread{1.125}

% PDF metadata into the final file
\usepackage[
            pdfauthor={Conan Doyle},
            pdftitle={Adventures of Sherlock Holmes}
            ]{hyperref}
```

Now it's to time to start typing your text, because up to now, all tags are only for *Lateχ* internal use. Everything should stick between those 2 Latex tags:

```tex
\begin{document}
\end{document}
```

Here is the whole text:

```tex
%% ------------------------------------------------------------
%% document start
%% ------------------------------------------------------------
\begin{document}

%% ------------------------------------------------------------
%% header table
%% ------------------------------------------------------------
\begin{tabular}{p{10cm} p{5cm}}
	
	\begin{minipage}[t]{0.40\textwidth}
		\begin{flushleft}
			{\Large \textbf{John H. Watson}}\\[10pt]
			221B Baker Street\\
			London\\[8pt]
			\Mobilefone ~ +41 06 00 00 00 00\\
			\Email ~ john.watson@outlook.com\\[20pt]
		\end{flushleft}
	\end{minipage}
	
	&
	
	\begin{minipage}[t]{0.40\textwidth}
		\begin{flushright}
			{\Large \textbf{Professor Moriarty}}\\[10pt]
			6649 N Blue Gum St\\
			London\\
		\end{flushright}
	\end{minipage}  
	
\end{tabular}



\begin{flushleft}
London, 1895

Object: A scandal in Bohemia
\end{flushleft}



\vspace{1.5cm}

%% ------------------------------------------------------------
%% Letter body
%% ------------------------------------------------------------
Dear Sir,
\vspace{1.5cm}

To Sherlock Holmes she is always the woman. I have seldom heard
him mention her under any other name. In his eyes she eclipses and
predominates the whole of her sex. It was not that he felt any emotion
akin to love for Irene Adler. All emotions, and that one particularly,
were abhorrent to his cold, precise, but admirably balanced mind. He
was, I take it, the most perfect reasoning and observing machine that
the world has seen; but, as a lover, he would have placed himself in a
false position. He never spoke of the softer passions, save with a gibe
and a sneer. 

They were admirable things for the observer—excellent
for drawing the veil from men’s motives and actions. But for the
trained reasoner to admit such intrusions into his own delicate and
finely adjusted temperament was to introduce a distracting factor which
might throw a doubt upon all his mental results. Grit in a sensitive
instrument, or a crack in one of his own high-power lenses, would not
be more disturbing than a strong emotion in a nature such as his. And
yet there was but one woman to him, and that woman was the late Irene
Adler, of dubious and questionable memory.

I had seen little of Holmes lately. My marriage had drifted us away
from each other. My own complete happiness, and the home-centred
interests which rise up around the man who first finds himself master
of his own establishment, were sufficient to absorb all my attention;
while Holmes, who loathed every form of society with his whole
Bohemian soul, remained in our lodgings in Baker Street, buried among
his old books, and alternating from week to week between cocaine and
ambition, the drowsiness of the drug, and the fierce energy of his
own keen nature.

\vspace{1cm}
\hspace{10cm} Sherlock Holmes

\end{document}
```

Several points to explain:

* tables are not the most easy to read in *Lateχ* source code. This is quite verbose, and not really intuitive. But once you got the whole idea, this is much simpler
* units for spacing are so numerous that there's a complete article on Wikipedia: https://en.wikibooks.org/wiki/LaTeX/Lengths
* to separate 2 paragraphs, just add one blank line between 2 blocks of text
* for text, just type your text without thinking of spacing, alignment, carriage return etc. Just type it,
the *Lateχ* compiler will manage and calculate justification with correct word hyphenation (the way of word is
cut to prevent overflow)
* *hspace* and *vspace* are, as you already guessed, to keep horizontal or vertical spaces between text

Beware that to get the full power of *TrueType* fonts, you need to compile with *XeTeχ*. This is done by selecting *XeLaTeχ* in the combo list in *Options -> Configure -> Production*.

The result is a very neat, professional and good looking letter !

Hope this helps.

> Photo by Andrew Buchanan on Unsplash