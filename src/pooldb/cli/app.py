from cement.core import foundation, handler
from .base import BaseController


class PooldApp(foundation.CementApp):
    class Meta:
        label = 'pooldb'
        base_controller = BaseController

    def execute(self):
        try:
            self.setup()
            self.run()
        finally:
            self.close()

    def setup(self, *args, **kw):
        from . import install, shell
        handler.register(install.InstallController)
        handler.register(shell.ShellController)
        super(PooldApp, self).setup(*args, **kw)
