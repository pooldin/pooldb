from cement.core import controller

description = "Poold.in database management cli application."
epilog = """The goal of this application is to speed up database management,
development, migration, and versioning issues. See the help associated
with the following commands for more details.
"""


class BaseController(controller.CementBaseController):
    class Meta:
        label = 'base'
        description = description
        epilog = epilog

    @controller.expose(hide=True, aliases=['run'])
    def default(self):
        self.app.args.print_help()
