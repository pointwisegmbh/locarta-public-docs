A=./android

docker:
	(cd $A && make docker)

tag:
	(cd $A  && make tag) 

push:
	(cd $A && make push)
