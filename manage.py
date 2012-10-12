import os
import sys

DIR = os.path.dirname(__name__)
DIR = os.path.abspath(DIR)
SRC = os.path.join(DIR, 'src')
sys.path.append(SRC)

from pooldb import cli

cli.run()
