.PHONY := db deps shell fixtures
.DEFAULT_GOAL := deps

db:
	@python manage.py install

fixtures:
	@python manage.py fixtures

clean:
	@find . -name "*.py[co]" -exec rm -rf {} \;

deps:
	@easy_install readline
	@pip install -r requirements.txt

shell:
	@python manage.py shell
