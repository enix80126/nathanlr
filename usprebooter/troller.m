//
//  troller.c
//  usprebooter
//
//  Created by LL on 29/11/23.
//
#include <mach/arm/kern_return.h>
#include "troller.h"
#include <xpc/xpc.h> // copy from macOS
#include <xpc/connection.h> // copy from macOS
#include <bootstrap.h> // copy from macOS, launch.h from macOS
#include <stdio.h>
#include <unistd.h>
#include <os/object.h>
#include <time.h>
#include <sys/errno.h>
#include "util.h"
#include <IOKit/IOKitLib.h>

int userspaceReboot(void) {
    kern_return_t ret = 0;
    xpc_object_t xdict = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_uint64(xdict, "cmd", 5);
    xpc_object_t xreply;
    ret = unlink("/private/var/mobile/Library/MemoryMaintenance/mmaintenanced");
    if (ret && errno != ENOENT) {
        fprintf(stderr, "could not delete mmaintenanced last reboot file\n");
        return -1;
    }
    xpc_connection_t connection = xpc_connection_create_mach_service("com.apple.mmaintenanced", NULL, 0);
    if (xpc_get_type(connection) == XPC_TYPE_ERROR) {
        char* desc = xpc_copy_description((__bridge xpc_object_t _Nonnull)(xpc_get_type(connection)));
        puts(desc);
        free(desc);
        return -1;
    }
    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
        char* desc = xpc_copy_description(event);
        puts(desc);
        free(desc);
    });
    xpc_connection_activate(connection);
    char* desc = xpc_copy_description(connection);
    puts(desc);
    printf("connection created\n");
    xpc_object_t reply = xpc_connection_send_message_with_reply_sync(connection, xdict);
    if (reply) {
        char* desc = xpc_copy_description(reply);
        puts(desc);
        free(desc);
        xpc_connection_cancel(connection);
        return 0;
    }

    return -1;
}
int bindfs(char *from, char *to) {
    int ch, mntflags = 0;
    char *dir = (char *)calloc(MAXPATHLEN, sizeof(char));
    if (realpath(from, dir) == NULL) {
        printf("%s: failed to realpath dir %s -> %s - %s(%d)\n", getprogname(), from, dir, strerror(errno), errno);
        free(dir);
        return errno;
    }
    dir = (char *)realloc(dir, (strlen(dir) + 1) * sizeof(char));

    char *mountpoint = (char *)calloc(MAXPATHLEN, sizeof(char));
    if (realpath(to, mountpoint) == NULL) {
        printf("%s: failed to realpath mountpoint %s -> %s - %s(%d)\n", getprogname(), from, mountpoint, strerror(errno), errno);
        free(mountpoint);
        return errno;
    }
    mountpoint = (char *)realloc(mountpoint, (strlen(mountpoint) + 1) * sizeof(char));

    int mountStatus = mount("bindfs", mountpoint, mntflags, dir);
    if (mountStatus < 0)
        printf("%s: failed to mount %s -> %s - %s(%d)\n", getprogname(), dir, mountpoint, strerror(errno), errno);
    free(dir);
    free(mountpoint);
    return mountStatus == 0 ? 0 : errno;
}
