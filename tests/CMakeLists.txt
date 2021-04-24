set(Latexmk_FLAGS "-gg;-r;${CMAKE_CURRENT_SOURCE_DIR}/latexmkrc")

add_latex_document(mwe.tex)
add_test(NAME basic-usage
         COMMAND ${CMAKE_COMMAND}
                 -P ${CMAKE_CURRENT_SOURCE_DIR}/check.cmake
                 ${CMAKE_CURRENT_BINARY_DIR}/mwe.pdf
         )

# Check each engine generates an appropriate output
foreach(engine PDFLATEX
               LUALATEX
               XELATEX
               LATEX
               DVI
               PS
        )
    configure_file(mwe.tex ${CMAKE_CURRENT_BINARY_DIR}/mwe-${engine}.tex
                   COPYONLY)
    add_latex_document(${CMAKE_CURRENT_BINARY_DIR}/mwe-${engine}.tex
                       ENGINE ${engine}
                       )
    if (engine MATCHES "(PDFLATEX|LUALATEX|XELATEX)")
        set(ext pdf)
    elseif (engine MATCHES "(LATEX|DVI)")
        set(ext dvi)
    else()
        set(ext ps)
    endif()

    add_test(NAME ${engine}
             COMMAND ${CMAKE_COMMAND}
                     -P ${CMAKE_CURRENT_SOURCE_DIR}/check.cmake
                     ${CMAKE_CURRENT_BINARY_DIR}/mwe-${engine}.${ext}
             )
endforeach()
