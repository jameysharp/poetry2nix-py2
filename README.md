This repo demonstrates building a minimal Python 2.7 project, using the
Poetry build backend, and packaged with poetry2nix.

I found that poetry2nix didn't work as I expected for a Python 2
project, because the dependencies for `poetry-core` weren't installed in
the Python environment where `pip` tried to invoke it.

Adding those dependencies to my project's dev-dependencies makes the
build succeed. That doesn't seem like a _good_ solution, but I haven't
been able to figure out how to fix it correctly.

So this repo has two versions of the same minimal project. `working`
demonstrates my workaround. Trying to build `broken` fails during the
first step, ending with a stack trace like this:

```
    Running command /nix/store/...-python-2.7.18/bin/python2.7 /nix/store/...-python2.7-pip-20.3.4/lib/python2.7/site-packages/pip/_vendor/pep517/_in_process.py prepare_metadata_for_build_wheel /build/tmpAvvvtz
    Preparing wheel metadata ... done
ERROR: Exception:
Traceback (most recent call last):
...
  File "/nix/store/...-python2.7-pip-20.3.4/lib/python2.7/site-packages/pip/_vendor/pep517/wrappers.py", line 196, in prepare_metadata_for_build_wheel
    '_allow_fallback': _allow_fallback,
  File "/nix/store/...-python2.7-pip-20.3.4/lib/python2.7/site-packages/pip/_vendor/pep517/wrappers.py", line 284, in _call_hook
    raise BackendUnavailable(data.get('traceback', ''))
BackendUnavailable
```

I had to read both PEP517 and the source for the `pep517` library to get
enough context to understand this error. Using `nix-shell` in the
`broken` directory, you can run Python and try the same import that Pip
is doing internally:

```
>>> import poetry.core.masonry.api
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/nix/store/...-python2.7-poetry-core-1.0.7/lib/python2.7/site-packages/poetry/core/__init__.py", line 8, in <module>
    from pathlib2 import Path
ImportError: No module named pathlib2
```
