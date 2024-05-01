#ifndef SqliteWrapper_h
#define SqliteWrapper_h
#include <stdarg.h>
#include <sqlite3.h>

int sqliteWrapperConfig(int option, va_list args);
int sqliteWrapperDbConfig(sqlite3* db, int option, va_list args);

#endif /* SqliteWrapper_h */
