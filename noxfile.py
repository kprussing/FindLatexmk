import pathlib

import nox

@nox.session
def docs(session):
    """Build the documentation"""
    session.install("sphinx", "kpruss", "sphinxcontrib-moderncmakedomain")
    root = pathlib.Path(__file__).parent
    session.run("sphinx-build",
                "-W",
                "-b", "html",
                "-d", str(root / ".doctrees"),
                str(root),
                str(root / "docs")
                )
