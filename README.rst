jammer
======

.. image:: https://raw.githubusercontent.com/wasamasa/jammer/master/img/jammer.gif

About
-----

``jammer`` is a tool for punishing yourself (or other unsuspecting
people) for inefficiently using Emacs.

Installation
------------

Install from `Marmalade <https://marmalade-repo.org/>`_ or `MELPA
<http://melpa.org/>`_ with ``M-x package-install RET jammer RET``.

Usage
-----

Enable it interactively with ``M-x jammer-mode`` or by adding the
following to your init file:

.. code:: cl

    (jammer-mode)

Customization
-------------

``jammer`` comes with the ``repeat`` type enabled out of the box which
punishes you for repeating keystrokes too quickly.  You can customize
the base delay (``jammer-repeat-delay``), the repetition window
(``jammer-repeat-window``), amount of allowed repetitions
(``jammer-repeat-allowed-repetitions``) and most importantly, the type
of slowdown (``jammer-repeat-type``).  It can be constant, linear or
quadratic, the latter two types increase the delay time depending on
the repetition count.

Asides from the ``repeat`` type, there's also the option to constantly
slow down all events (for input lag emulation) or slowing down
randomly selected events by a random amount, an effect most comparable
to having spilt a small amount of a sticky liquid on your keyboard.
These can be enabled by customizing ``jammer-type``.

Finally, one can whitelist or blacklist commands.  By default an empty
whitelist is used.  Adding a command to ``jammer-block-list`` in this
state of operation will make it exempt to all delays,
``self-insert-command`` would be an useful example to allow typing
normally, but slowing down other repetitive commands.  Changing
``jammer-block-type`` to ``blacklist`` will change the behaviour to
not affecting anything by default.  If ``jammer-block-list`` were to
contain ``previous-line``, ``next-line``, ``left-char`` and
``right-char``, slowdowns will only happen for the use of arrow keys
for text movement.

Contributing
------------

If you find bugs, have suggestions or any other problems, feel free to
report an issue on the issue tracker or hit me up on IRC, I'm always on
``#emacs``.  Patches are welcome, too, just fork, work on a separate
branch and open a pull request with it.

Alternatives
------------

This package is heavily inspired by `vim-molasses
<https://github.com/0x0dea/vim-molasses>`_ which is inspired by
`vim-hardtime <https://github.com/takac/vim-hardtime>`_ which is
inspired by `hardmode <https://github.com/wikitopian/hardmode>`_.

I'm not aware of any Emacs alternatives, but both `annoying-arrows-mode
<https://github.com/magnars/annoying-arrows-mode.el>`_ and `guru-mode
<https://github.com/bbatsov/guru-mode>`_ come somewhat close.
