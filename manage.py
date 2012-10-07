import os
import sys

root = os.path.dirname(__name__)
root = os.path.abspath(root)
src = os.path.join(root, 'src')
sys.path.append(src)

from pooldb import cli

cli.run()
