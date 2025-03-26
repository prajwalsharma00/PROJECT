#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/types.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>

#define SOCKET int
#define CLOSESOCKET(s) close(s)
#define ISSOCKETVALID(s) ((s) >= 0)