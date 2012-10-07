.PHONY := db deps shell
.DEFAULT_GOAL := deps

db:
	@python manage.py install

deps:
	@easy_install readline
	@pip install -r requirements.txt

shell:
	@python manage.py shell
