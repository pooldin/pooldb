from pooldlib import cli
from pooldb.cli.install import InstallController


class RootController(cli.RootController):
    class Meta:
        label = 'base'
        description = "Poold.in database management cli application."
        epilog = "The goal of this application is to speed up database " \
                 "management, development, migration, and versioning " \
                 "issues. See the help associated with the following " \
                 "commands for more details."


class App(cli.App):
    class Meta:
        label = 'pooldb'
        base_controller = RootController
        handlers = (cli.ShellController,
                    InstallController)
