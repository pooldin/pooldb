import os

from cement.core import controller
from pooldlib.postgresql import db

import pooldb


class InstallController(controller.CementBaseController):

    class Meta:
        label = 'install'
        description = "Install the Poold.in database."
        arguments = [
            (['-c', '--connection'], {
                'action': 'store',
                'help': 'Connection string to use for the database connection',
                'default': 'postgresql://localhost/pooldin',
            }),
            (['-s', '--schema'], {
                'action': 'store',
                'help': 'Schema to install into',
                'default': 'public',
            }),
        ]

    @controller.expose(hide=True, help='Install the database')
    def default(self):
        connection = self.pargs.connection

        db.init_connection({
            'SQLALCHEMY_DATABASE_URI': connection,
            'SQLALCHEMY_ECHO': True
        })

        try:
            schema = self.pargs.schema

            drop = 'DROP SCHEMA IF EXISTS "%s" CASCADE;'
            drop %= schema

            db.session.execute(drop)
            db.session.execute('CREATE SCHEMA "%s";' % schema)
            db.session.execute('SET search_path TO "%s";' % schema)
            db.session.execute(self.sql())
            db.session.commit()
        finally:
            db.session.remove()

    def sql(self):
        sql = self.load_sql('types.sql')
        sql += self.load_sql('all.sql')
        sql += self.load_sql('extensions.sql')
        return sql

    def load_sql(self, *path):
        with open(os.path.join(pooldb.DIR, 'sql', *path), 'r') as fd:
            return ''.join(fd.readlines())
