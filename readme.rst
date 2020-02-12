
dotfiles
========

Personal collection of dotfiles.


Installation
------------

Clone the repo:

.. code:: bash

    $ git clone https://github.com/treynr/dotfiles.git

Run the installation script.

.. code:: bash

    $ cd dotfiles && ./install.sh

This will treat your ``$HOME`` directory as a git repo, the contents of which
are stored under ``$HOME/.dotfiles``.
To commit files, use ``git`` along with ``--git-dir`` and ``--work-tree``
options:

.. code:: bash

    $ git --git-dir=$HOME/.dotfiles --work-tree=$HOME commit -a

