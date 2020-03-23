alloc:
	gcc -g c_alloc.c -o c_alloc

strlen:
	gcc -g c_strlen.c -o c_strlen -lcatch -L../catch/target/debug
	gcc -shared -fPIC my_strlen.c -o libmy_strlen.so	

rand:
	gcc -g c_rand.c -o c_rand
	gcc -shared -fPIC my_rand.c -o libmy_rand.so