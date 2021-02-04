# Copyright 2020 Keith F Prussing
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#[================================================================[.rst:
FindLatexmk
-----------

Locate ``latexmk`` and provide a function to add a LaTeX document as a
target.  It locates ``latexmk`` by inspecting :variable:`ENV{LATEXMK}`,
checking in :variable:`Latexmk_DIR`, and finally in the directories
containing the binaries found by :module:`FindLATEX`.  This module will
also load :module:`FindLATEX` to check that a valid LaTeX compiler is on
the system.

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the following :ref:`Imported Targets <Imported Targets>`:

*   ``Latexmk::Latexmk``
    The ``latexmk`` executable

Result Variables
^^^^^^^^^^^^^^^^

*   ``Latexmk_FOUND``
    The system has ``latexmk``
*   ``Latexmk_Executable``
    The path to the ``latexmk`` executable

Hints
^^^^^

Additional flags to ``latexmk`` may be specified via
:variable:`Latexmk_FLAGS`.

This module will inspect :variable`ENV{LATEXMK}` for an absolute path to
``latexmk``.  It is a fatal error if this is not an executable.  It will
then check :variable:`Latexmk_DIR` for the executable before checking
the directories containing the binaries found by :module:`FindLATEX`.

Defined Macros
^^^^^^^^^^^^^^

This module defines the following macros:

.. command:: add_latex_document

  .. code-block:: cmake

    add_latex_document(<output> <main source> [<additional sources> ...]
                       [ALL] [ENGINE PDFLATEX | LUALATEX | XELATEX])

  This function takes a main LaTeX source file and creates a target that
  will run ``latexmk`` on the input.  All of the dependency scanning for
  the target is deferred to ``latexmk``.  The driver for ``latexmk`` is
  deduced from the extension of the output file.  In short, the
  extension maps directly to the appropriate ``latexmk`` flag (i.e.
  ``.dvi`` -> ``-dvi``, ``.ps`` -> ``-ps``, ``.pdf`` -> ``-pdf``).  The
  exception is ``.pdf`` extensions.  If the output is PDF, the
  ``ENGINE`` option can be used to change the desired back-end to
  ``pdflatex``, ``lualatex``, or ``xelatex`` as desired.  The default is
  to use ``lualatex`` as that is the future (cannot seem to find the
  link where I read that at the moment).  It is a ``FATAL_ERROR`` to
  specify the ``ENGINE`` for a DVI or Postscript target.  The ``ALL``
  option adds the document to the ``ALL`` command.  Additional flags may
  be passed via :variable:`Latesmk_FLAGS`.  The command only uses the
  main source.  All additional sources are set as explicit dependencies
  for the main target (``<output>``) at the CMake level.

  .. note::
    It is highly recommended to *not* add the ``-dvi``, ``-pdf``,
    ``-lualatex``, ``-xelatex``, or ``-ps`` flags to
    :variable:`Latexmk_FLAGS` or the equivalent entries in the
    ``latexmkrc`` as this may lead to files that are not recognized as
    byproducts by CMake.

  .. note::
    This method does not sanity check the :variable:`Latexmk_FLAGS` for
    incompatible flags.

Known Bugs
^^^^^^^^^^

This module does not know if it needs to check for ``biblatex``,
``biber``, ``makeindex``, or any other executables.  It assumes that if
``latexmk`` has been found, the compilation will succeed.  This is not a
terrible assumption since a user will most likely have a full enough
LaTeX installation since they have ``latexmk``.

#]================================================================]

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# Don't do duplicate work if necessary
if (TARGET Latexmk::Latexmk)
    return()
endif()

# Define the function to locate latexmk
function(_latexmk__find_latexmk)
    # First, check if the environment specifies a valid latexmk
    if (DEFINED ENV{LATEXMK})
        execute_process(COMMAND $ENV{LATEXMK} -h
                        RESULT_VARIABLE res
                        OUTPUT_QUIET ERROR_QUIET)
        if (NOT res EQUAL "0")
            message(FATAL_ERROR "LATEXMK=$ENV{LATEXMK} is not valid")
        endif()
        set(Latexmk_Executable $ENV{LATEXMK} CACHE PATH
            "Latexmk executable path" FORCE)
        return()
    endif()

    # Check if latexmk has been loaded.
    if (NOT DEFINED LATEX_FOUND)
        find_package(LATEX)
    endif()
    if (NOT LATEX_FOUND)
        message(FATAL_ERROR "No underlying LaTeX found")
    endif()

    # Otherwise, scan known directories.  We do this by inspecting the
    # results of :module:`FindLATEX`.  Note, we only really care about
    # the main compilers.
    if (DEFINED Latexmk_DIR)
        find_program(Latexmk_Executable latexmk
                     PATHS ${Latexmk_DIR}
                     NO_DEFAULT_PATH)
        return()
    else()
        set(dirs)
        foreach(compiler LATEX LUALATEX PDFLATEX XELATEX)
            if (LATEX_${compiler}_FOUND)
                get_filename_component(_dir ${${compiler}_COMPILER} DIRECTORY)
                list(APPEND dirs ${_dir})
            endif()
        endforeach()
    endif()
    list(REMOVE_DUPLICATES dirs)
    if (NOT dirs)
        message(FATAL_ERROR "No directories to search for latexmk")
    endif()

    # Now actually do the search
    find_program(Latexmk_Executable latexmk PATHS ${dirs})
endfunction()

# Locate the latexmk if we haven't already.  Note this does require the
# user to reset :variable:`Latexmk_Executable`.
if (NOT DEFINED Latexmk_Executable)
    _latexmk__find_latexmk()
endif()

# Make sure we found the executable
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Latexmk DEFAULT_MSG Latexmk_Executable)

# Create the official target.
add_executable(Latexmk::Latexmk IMPORTED)
set_property(TARGET Latexmk::Latexmk
             PROPERTY IMPORTED_LOCATION "${Latexmk_Executable}")

function(add_latex_document target source)
    cmake_parse_arguments(PARSE_ARGV 2 latexmk "ALL" "ENGINE" "")
    # Split the root and extension from the target
    get_filename_component(root ${target} NAME_WE)
    get_filename_component(ext ${target} LAST_EXT)
    set(byproducts "${target};${root}.log;${root}.fdb_latexmk")

    # Determine the output flags based on the extension and the given
    # ENGINE.
    if (ext MATCHES "[.][Dd][Vv][Ii]")
        if (NOT latexmk_ENGINE MATCHES "")
            message(WARNING "ENGINE not supported for dvi output")
        endif()
        set(flags "-dvi;-ps-;-pdf-")
    elseif(ext MATCHES "[.][Pp][Ss]")
        if (NOT latexmk_ENGINE MATCHES "")
            message(WARNING "ENGINE not supported for postscript output")
        endif()
        set(flags "-dvi-;-ps;-pdf-")
    elseif(ext MATCHES "[.][Pp][Dd][Ff]")
        if (latexmk_ENGINE MATCHES "(|LUALATEX)")
            set(flags "-dvi-;-ps-;-lualatex")
        elseif(latexmk_ENGINE MATCHES "XELATEX")
            set(flags "-dvi-;-ps-;-xelatex")
        elseif(latexmk_ENGINE MATCHES "PDFLATEX")
            set(flags "-dvi-;-ps-;-pdf")
        else()
            message(FATAL_ERROR "Unknown ENGINE ${latexmk_ENGINE}")
        endif()
    else()
        message(FATAL_ERROR "Unknown extension ${ext}")
    endif()

    # Run Latexmk to determine what it thinks the generated files will
    # be so we can add these as byproducts.
    execute_process(
        COMMAND ${Latexmk_Executable}
            -e "print join(';', @generated_exts)"
            -e "exit(0)"
            ${source}
        OUTPUT_VARIABLE exts
        ERROR_VARIABLE errors
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    if (NOT result EQUAL "0")
        message("Error getting generated extensions: ${exts}")
        message("Error getting generated extensions: ${result}")
        message(FATAL_ERROR "Error getting generated extensions: ${errors}")
    endif()
    foreach(ext ${exts})
        list(APPEND byproducts ${root}.${ext})
    endforeach()

    # Finally, create the target.  Using :command`add_custom_target` is
    # always considered out of date so the dependency resolution is
    # pushed to latexmk.
    if (latexmk_ALL)
        set(_all ALL)
    else()
        set(_all)
    endif()
    add_custom_target(${target} ${_all}
                      COMMAND Latexmk::Latexmk ${flags}
                              -output-directory=${CMAKE_CURRENT_BINARY_DIR}
                              ${Latexmk_FLAGS}
                              ${source}
                      DEPENDS ${source} ${latexmk_UNPARSED_ARGUMENTS}
                      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                      BYPRODUCTS ${byproducts}
                     )
endfunction()

