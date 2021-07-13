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

