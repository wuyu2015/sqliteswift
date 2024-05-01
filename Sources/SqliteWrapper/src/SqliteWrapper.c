#include "SqliteWrapper.h"

int sqliteWrapperConfig(int option, va_list args) {
    return sqlite3_config(option, args);
}

int sqliteWrapperDbConfig(sqlite3* db, int option, va_list args) {
    return sqlite3_db_config(db, option, args);
}
