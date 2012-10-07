import os

from cement.core import controller
import psycopg2

import pooldb


class InstallController(controller.CementBaseController):

    class Meta:
        label = 'install'
        description = "Install the Poold.in database."

    @controller.expose(hide=True, help='Install the database')
    def default(self):
        conn = psycopg2.connect(database='pooldin', host='localhost')
        try:
            self.commit(conn, ''.join(self.sql()))
        finally:
            print ''.join(conn.notices).strip()
            conn.close()

    def commit(self, conn, sql):
        cursor = conn.cursor()
        cursor.execute(sql)
        cursor.connection.commit()
        cursor.close()

    def sql(self):
        lines = []
        lines.extend(self.load_sql('schema.sql'))
        lines.extend(self.load_sql('types.sql'))
        lines.extend(self.load_sql('all.sql'))
        return lines

    def load_sql(self, *path):
        with open(os.path.join(pooldb.DIR, 'sql', *path), 'r') as fd:
            return fd.readlines()
