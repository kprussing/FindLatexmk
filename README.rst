FindLatexmk
***********

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

Installation
============

Use :program:`cmake` to generate the ``FindLatexmk.cmake`` and then
place it on the :program:`cmake` search path (``CMAKE_MODULE_PATH``) and
the add ``find_package(Latexmk)`` to you ``CMakeLists.txt``.
Alternatively, you can place the ``FindLatexmk.cmake`` in your project
and then ``include`` it in your ``CMakeLists.txt``.

Usage
=====

.. include:: usage.rst

License
=======

Distributed under the OSI-approved `BSD 2-Clause License`_.  See the
module source for details.

Change Log
==========

Unreleased_
-----------

Added
^^^^^

-   Rudimentary tests to check the correct output is generated

Changed
^^^^^^^

-   Generate the target based on the engine instead of from the command
-   Moved the usage to a separate file
-   Use :program:`cmake` to generate the final module file

Fixed
^^^^^

-   Corrected check for ``Latexmk_DIR``

0.1_ - 2020-09-05
-----------------

-   Functional release

.. _BSD 2-Clause License: https://opensource.org/licenses/BSD-2-Clause
.. _Unreleased: https://github.com/kprussing/findlatexmk/compare/0.1...HEAD
.. _0.1: https://github.com/kprussing/findlatexmk/releases/tag/0.1
