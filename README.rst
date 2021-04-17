FindLatexmk
===========

A :program:`cmake` module to locate :program:`latexmk` and provide a
function to add a LaTeX document to the build.  The goal of this module
is to provide a :program:`cmake` interface similar to ``add_executable``
or ``add_library`` where one specified the ``TARGET`` followed by the
sources  This would let :program:`latexmk` do what it does and manage
the main LaTeX dependencies while providing a :program:`cmake`\ -like
interface.  The pie in the sky interface would be

.. code-block:: cmake

  add_document(main.pdf main.tex [input1.tex input2.tex ...])

However, this it not practical as the exact output can be customized via
the ``latexmkrc`` (not limited to specifying the PDF generation via
``pdflatex``, ``lualatex``, or ``xelatex``).  This module aims to add a
proper :program:`cmake` target assuming the user has not added too many
customizations to their ``latexmkrc``.

Usage
-----

To include the module in a project:

1.  Add the ``FindLatexmk.cmake`` to your project and the add
    ``include(FindLatexmk.cmake)`` to your main ``CMakeLists.txt``, or
2.  Put the ``FindLatexmk.cmake`` on the ``cmake`` search path
    (``CMAKE_MODULE_PREFIX``) and use ``find_package(Latexmk)``
    in your main ``CMakeLists.txt``.

Then add the following to your ``CMakeLists.txt``

.. code-block:: cmake

  add_latex_document(doc.<ext> doc.tex [extra-1.tex extra-2.tex ...]
                     [DRIVER PDFLATEX | LUALATEX | XELATEX])

Additional flags to ``latexmk`` may be specified with ``Latexmk_FLAGS``.

.. note::
   It is highly recommended to *not* specify the ``-dvi``, ``-ps``,
   ``-pdf``, ``-lualatex``, or ``-xelatex`` flags or their equivalents
   in the ``latexmkrc`` as this could lead to additional files that are
   not recognized as byproducts by ``cmake``.

For full details, see the internal module documentation.

License
-------

Distributed under the OSI-approved `BSD 2-Clause License`_.  See the
module source for details.

Change Log
----------

Unreleased_
^^^^^^^^^^^

Fixed
"""""

-   Corrected check for ``Latexmk_DIR``

0.1_ - 2020-09-05
^^^^^^^^^^^^^^^^^

-   Functional release

.. _BSD 2-Clause License: https://opensource.org/licenses/BSD-2-Clause
.. _Unreleased: https://github.com/kprussing/findlatexmk/compare/0.1...HEAD
.. _0.1: https://github.com/kprussing/findlatexmk/releases/tag/0.1
