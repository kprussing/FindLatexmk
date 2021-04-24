FindLatexmk
-----------

Locate ``latexmk`` and provide a function to add a LaTeX document as a
target.  It locates ``latexmk`` by inspecting the environment variable
``LATEXMK``, checking in ``Latexmk_DIR``, and finally in the directories
containing the binaries found by :module:`FindLATEX`.  This module will
also load :module:`FindLATEX` to check that a valid LaTeX compiler is on
the system.

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` targets:

``Latexmk::Latexmk``
  The ``latexmk`` executable

Result Variables
^^^^^^^^^^^^^^^^

``Latexmk_FOUND``
  The system has ``latexmk``
``Latexmk_Executable``
  The path to the ``latexmk`` executable

Hints
^^^^^

Additional flags to ``latexmk`` may be specified via ``Latexmk_FLAGS``.

This module will inspect the environment variable ``LATEXMK`` for an
absolute path to ``latexmk``.  It is a fatal error if this is not an
executable.  It will then check ``Latexmk_DIR`` for the executable
before checking the directories containing the binaries found by
:module:`FindLATEX`.

Defined Macros
^^^^^^^^^^^^^^

This module defines the following macros:

.. command:: add_latex_document

  .. code-block:: cmake

    add_latex_document(
        <main source> [<additional sources> ...] [ALL]
        [ENGINE PDFLATEX | LUALATEX | XELATEX | LATEX | DVI | PS]
    )

  This function takes a main LaTeX source file and creates a target that
  will run ``latexmk`` on the input.  All of the dependency scanning for
  the target is deferred to ``latexmk``.  The ``ENGINE`` option sets
  LaTeX engine to use and dictates the output target (``PDFLATEX``,
  ``LUALATEX``, and ``XELATEX`` yield ``<main source root>.pdf``,
  ``LATEX`` and ``DVI`` yield ``<main source root>.dvi``, and ``PS``
  yields ``<main source root>.ps``).  The default is ``PDFLATEX``.  This
  creates a target of the appropriate name (``<main source
  root>.${ext}``).  The ``ALL`` option adds the document to the ``ALL``
  command.  Additional flags may be passed via ``Latesmk_FLAGS``.  The
  command only uses the main source.  All additional sources are set as
  explicit dependencies for the target at the CMake level (such as a
  ``latexmkrc``).

  .. note::
    It is highly recommended to *not* add the ``-dvi``, ``-pdf``,
    ``-lualatex``, ``-xelatex``, or ``-ps`` flags to ``Latexmk_FLAGS``
    or the equivalent entries in the ``latexmkrc`` as this may lead to
    files that are not recognized as byproducts by CMake.

  .. note::
    This method does not sanity check the ``Latexmk_FLAGS`` for
    incompatible flags.

Known Bugs
^^^^^^^^^^

This module does not know if it needs to check for ``biblatex``,
``biber``, ``makeindex``, or any other executables.  It assumes that if
``latexmk`` has been found, the compilation will succeed.  This is not a
terrible assumption since a user will most likely have a full enough
LaTeX installation since they have ``latexmk``.
