eval "$(/opt/homebrew/bin/brew shellenv)"
#export PATH=$PATH:/Users/yonah.citron/Library/Python/3.8/bin
export PATH=$PATH:/opt/homebrew/anaconda3/bin

alias venv='python -m venv venv'
alias activate='source ./venv/bin/activate'

# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH
