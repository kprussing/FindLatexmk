FindLatexmk
-----------

A ``cmake(1)`` module to locate ``latexmk(1)`` and provide a function to
add a LaTeX document to the build system.

The goal of this module is to provide a ``cmake`` interface similar to
:command:`add_executable` or :command:`add_library` where one specified
the output ``TARGET`` followed by the sources.  This would let
``latexmk`` do what it does and manage the main LaTeX dependencies while
providing a ``cmake`` style interface.  A pie in the sky interface would
look like:

.. code-block:: cmake

  add_document(main.pdf main.tex [input1.tex input2.tex ...])

However, this it not practical as the exact output can be customized via
the ``latexmkrc`` (not limited to specifying the PDF generation via
``pdflatex``, ``lualatex``, or ``xelatex``).  This module aims to add a
proper ``cmake`` target assuming the user has not added too many
customizations in their ``latexmkrc``.

Usage
^^^^^

To include the module in a project:

1.  Add the ``FindLatexmk.cmake`` to you project and the add
    ``include(FindLatexmk.cmake)`` to your main ``CMakeLists.txt``, or
2.  Put the ``FindLatexmk.cmake`` on the ``cmake`` search path
    (:variable:`CMAKE_MODULE_PREFIX`) and use ``find_package(Latexmk)``
    in your main ``CMakeLists.txt``.

Then add the following to your ``CMakeLists.txt``

.. code-block:: cmake

  add_latex_document(doc.<ext> doc.tex [extra-1.tex extra-2.tex ...]
                     [DRIVER PDFLATEX | LUALATEX | XELATEX])

This adds a target of the same name as the output file.  The particular
driver is deduced by the extension of the output and passed as flags to
the ``latexmk``.  The rules are:

-   ``.dvi``:   ``-dvi``
-   ``.ps``:    ``-ps``
-   ``.pdf``:   ``-pdf``
-   ``.pdf`` and ``DRIVER PDFLATEX``: ``-pdf``
-   ``.pdf`` and ``DRIVER LUALATEX``: ``-lualatex``
-   ``.pdf`` and ``DRIVER XELATEX``: ``-xelatex``

Additional flags to ``latexmk`` may be specified with
:variable:`Latexmk_FLAGS`.

.. note::
   It is highly recommended to *not* specify the ``-dvi``, ``-ps``,
   ``-pdf``, ``-lualatex``, or ``-xelatex`` flags or their equivalents
   in the ``latexmkrc`` as this could lead to additional files that are
   not recognized as byproducts by ``cmake``.

License
^^^^^^^

Distributed under the OSI-approved BSD 2-Clause License.  See the module
source for details.

