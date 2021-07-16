# Ausarbeitung

Compile with PDFLatex.

Content not really correctable nor sinnvoll atm.



## Marvin Anmerkungen

* Alle figures/tables erstmal auf [tbh] setzen, dann ggf. später mit [H] murksen. Gute Idee dazu: Zu allen sections und subsections floatbarriers hinzufügen, dass keine flots komisch in die nächste section überlaufen

  ```latex
  \let\Oldsection\section
  \renewcommand{\section}{\FloatBarrier\Oldsection}
  \let\Oldsubsection\subsection
  \renewcommand{\subsection}{\FloatBarrier\Oldsubsection}
  \let\Oldsubsubsection\subsubsection
  \renewcommand{\subsubsection}{\FloatBarrier\Oldsubsubsection}
  ```

* ToC sollte möglichst eine "Geschichte erzählen": Einleitung, Theory, Was war schon da, was braucht man, was sollst du machen? Was hast du gemacht? Hat das gepasst? Zuammenfassung/Ausblick

* 

# Idea ToC

* Introduction

* Structure of a general XYZ System

  The xyz system needs A, B, C, see schematic ... .

  * Theory of A
  * Theory of B
  * Theory of C

* Selection of a FPGA Board

  Here are some boards, spartan, kintex, altera, ...

  * Can these boards do A, B, C?
  * Other factors were: price, mechanical constraints, connectors, board-material color, ...
  * Thats why we chose board ...

* Development of a Analog Front-End card

  * Card needs to fit board ...
  * circuit, see TRH in ... , ADCs in ... and ...
  * pcb layout

* Evaluation of the overall system

* Results
