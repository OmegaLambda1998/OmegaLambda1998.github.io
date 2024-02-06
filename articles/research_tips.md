@def tabname="Research Tips"
@def title="Research Tips and Tricks"
@def subtitle="Some things I picked up during my PhD"
@def authors="Patrick Armstrong"

## Color Brewer
[Color Brewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3) is a fantastic site for generating a colour scheme for a paper, and making sure it's colourblind and printer friendly.

## Scalene
[Scalene](https://github.com/plasma-umass/scalene) is a fast, accurate insanely useful profiler for Python. This [video](https://www.youtube.com/watch?v=5iEf-_7mM1k) goes over why it's so good.

## Overleaf Vim Mode
Want to vim-ify your life (why wouldn't you)?

Overleaf has a vim mode, just go to Menu (top left), then change keybindings from None to vim. You can also change it to emacs... if you must.

## Overleaf Bibliography Workflow
I found myself getting annoyed by having to search for bibtex citations for papers I cited previously in other papers

I have a project in Overleaf called "Preamble" which contains:
- `preamble.tex`: All the custom commands, packages, and options I like to have by default.
- `biblio.bib`: An ever expanding bibliography containing every paper I ever cited (currently 6700 lines long). I make sure to name each citation `FirstAuthorSecondAuthorDate` so I avoid duplicate entries.

Now whenever I start a new project I simply need to these files `From Another Project` and then `\input{preamble}` after `documentclass` and include `\bibliography{biblio.bib}` before `\end{document}`.

## Useful ssh config options
If you find yourself ssh-ing into servers a lot, there are a number of ssh config commands you might consider. In `~/.ssh/config`, the general syntax is:
```
Host hostname
    HostName host.name.com
    User username
```
Allowing you to simply `ssh hostname` as a proxy for `ssh username@host.name.com`

In addition there are a number of options I impose on all ssh hosts:
```
Host * # Apply these options to all hosts
    ControlMaster auto
    ControlPersist 4800
    ControlPath ~/.ssh/control/%r.%h.%p.sock
```
This creates a file in `~/.ssh/control/` which contains my connection information. As long as I don't lose network connection, this allows me to keep whatever login authentication I used valid. This means that I login to the server once, this file is created, and then I don't need to login in again (at least until I restart my computer).

## Doi2Bib
[Doi2Bib](https://www.doi2bib.org/) lets you insert the doi of a paper and get its bibtex citation.

## Interactive Echo
In my .bashrc files on servers I like to have echo commands to state various bits of info, however that makes non-interactive commands like scp and sshfs quite angry, so I usually include the following:
```
alias interactive_echo='[[ $- == *i* ]] && echo'
```
Which first checks if the session is interactive, and only then echoes.

You can use a similar syntax to speed up non-interactive ssh commands if the `~/.bashrc` file on the server you're connecting to does a lot of work (aliasing, setting up environments, etc...)
```
# Test if interactive shell
if [[ $- == *i* ]]; then
    # Do all your work
    source ...
    conda activate ...
    module load ...
fi
```

## Python For Loop / List Comprehension Easy Parallisation
If you have a for loop like:
```
result_list = []
for value in list:
    do
    stuff
    to
    value
    result_list.append(value)
```
Or a list comprehension like:
```
result_list = [do_stuff(value) for value in list]
```
Then you can easily parallise this via:
```
import multiprocessing
from joblib import Parallel, delayed

num_cores = multiprocessing.cpu_count()
def do_stuff(val):
    do
    stuff

result_list = Parallel(n_jobs=num_cores)(delayed(do_stuff(value) for value in list))
```
You can even wrap `list` in `tqdm` to get a parallel friendly progress bar!
