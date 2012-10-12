import os

from cement.core import controller
from pooldlib.postgresql import db

import pooldb


class InstallController(controller.CementBaseController):

    class Meta:
        label = 'install'
        description = "Install the Poold.in database."

    @controller.expose(hide=True, help='Install the database')
    def default(self):
        db.init_connection({
            'SQLALCHEMY_DATABASE_URI': 'postgresql://localhost/pooldin',
            'SQLALCHEMY_ECHO': True
        })

        try:
            db.session.execute(self.sql())
            db.session.commit()
        finally:
            db.session.remove()

    def sql(self):
        sql = self.load_sql('schema.sql')
        sql += self.load_sql('types.sql')
        sql += self.load_sql('all.sql')
        return sql

    def load_sql(self, *path):
        with open(os.path.join(pooldb.DIR, 'sql', *path), 'r') as fd:
            return ''.join(fd.readlines())
