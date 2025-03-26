#include "c.h"
#define isvalidchar(s) (s != NULL)
struct client_info
{
    SOCKET client;
    struct sockaddr_storage clientaddress;
    socklen_t clientlen;
    struct client_info *next;
};
static struct client_info *main_list = 0;
struct client_info *get_client(SOCKET s)
{
    struct client_info *temp = main_list;

    while (temp)
    {
        if (temp->client == s)
        {
            return temp;
        }
        temp = temp->next;
    }
    struct client_info *new = malloc(sizeof(*new));
    memset(new, 0, sizeof(struct client_info));
    new->next = main_list;
    main_list = new;
    return new;
}
void parsehttp(char *recv){
    char *request = }

SOCKET createsocket(char *host, char *port)
{
    struct addrinfo hints, *server_address;
    memset(&hints, 0, sizeof(hints));
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;
    printf("Getting the ip address.. \n");
    if (getaddrinfo(host, port, &hints, &server_address))
    {
        fprintf(stderr, "Error in getting address.. \n");
        exit(0);
    }
    printf("Connectin to the socket... \n");
    SOCKET server = socket(server_address->ai_family, server_address->ai_socktype, server_address->ai_protocol);
    if (!ISSOCKETVALID(server))
    {
        fprintf(stderr, "Error in seting up socket.. \n");
        exit(1);
    }
    printf("Binding the server.. \n");
    if (bind(server, server_address->ai_addr, server_address->ai_addrlen))
    {
        fprintf(stderr, "error in bindign the server.. \n");
        exit(1);
    }
    freeaddrinfo(server_address);
    printf("Listneing the server.. \n");
    if (listen(server, 10) < 0)
    {
        fprintf(stderr, "Error in listengint the socket .. \n");
        exit(1);
    }
    return server;
}
void storetofile(char *recv)
{
    printf("This is called .. \n");
    FILE *fp = fopen("new.txt", "a");
    fputs(recv, fp);
    fclose(fp);
}

int main()
{
    SOCKET server = createsocket(NULL, "5050");
    fd_set reads;
    FD_ZERO(&reads);
    FD_SET(server, &reads);
    SOCKET max = server;
    while (1)
    {
        struct timeval ts;
        ts.tv_sec = 1;
        fd_set master = reads;
        if (select(max + 1, &master, 0, 0, &ts) < 0)
        {
            fprintf(stderr, "Nothing to connect at teh moment .. \n");
            break;
        }
        if (FD_ISSET(server, &master))
        {
            struct client_info *clients = get_client(-1);
            clients->clientlen = sizeof(clients->clientaddress);

            clients->client = accept(server, (struct sockaddr *)&(clients->clientaddress), &clients->clientlen);
            printf("The new client excepted is %d \n", clients->client);
            if (!ISSOCKETVALID(clients->client))
            {
                fprintf(stderr, "Error in getting new client.. \n");
                exit(1);
            }
            if (max < clients->client)
            {
                max = clients->client;
            }
            FD_SET(clients->client, &reads);
        }
        struct client_info *temp = main_list;
        while (temp)
        {
            if (FD_ISSET(temp->client, &master))
            {
                char receiv[1024];
                int bytes_recv = recv(temp->client, receiv, sizeof(receiv), 0);

                if (bytes_recv <= 0)
                {
                    printf("Client disconnected: %d\n", temp->client);

                    CLOSESOCKET(temp->client);
                    FD_CLR(temp->client, &reads);
                    // Remove from main set
                    // remove from main_list too
                }
                else
                {
                    receiv[bytes_recv] = '\0';
                    printf("%s \n", receiv);
                    storetofile(receiv);
                }
            }
            temp = temp->next;
        }
    }
}