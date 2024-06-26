import XCTest
@testable import Sqlite
import SQLite3

final class SqliteEnumTests: XCTestCase {
    func testConfig() {
        XCTAssertEqual(Sqlite.Config.MULTITHREAD.rawValue, SQLITE_CONFIG_MULTITHREAD)
        XCTAssertEqual(Sqlite.Config.SERIALIZED.rawValue, SQLITE_CONFIG_SERIALIZED)
        XCTAssertEqual(Sqlite.Config.MALLOC.rawValue, SQLITE_CONFIG_MALLOC)
        XCTAssertEqual(Sqlite.Config.GETMALLOC.rawValue, SQLITE_CONFIG_GETMALLOC)
        XCTAssertEqual(Sqlite.Config.PAGECACHE.rawValue, SQLITE_CONFIG_PAGECACHE)
        XCTAssertEqual(Sqlite.Config.HEAP.rawValue, SQLITE_CONFIG_HEAP)
        XCTAssertEqual(Sqlite.Config.MEMSTATUS.rawValue, SQLITE_CONFIG_MEMSTATUS)
        XCTAssertEqual(Sqlite.Config.MUTEX.rawValue, SQLITE_CONFIG_MUTEX)
        XCTAssertEqual(Sqlite.Config.GETMUTEX.rawValue, SQLITE_CONFIG_GETMUTEX)
        XCTAssertEqual(Sqlite.Config.LOOKASIDE.rawValue, SQLITE_CONFIG_LOOKASIDE)
        XCTAssertEqual(Sqlite.Config.URI.rawValue, SQLITE_CONFIG_URI)
        XCTAssertEqual(Sqlite.Config.PCACHE2.rawValue, SQLITE_CONFIG_PCACHE2)
        XCTAssertEqual(Sqlite.Config.GETPCACHE2.rawValue, SQLITE_CONFIG_GETPCACHE2)
        XCTAssertEqual(Sqlite.Config.COVERING_INDEX_SCAN.rawValue, SQLITE_CONFIG_COVERING_INDEX_SCAN)
        XCTAssertEqual(Sqlite.Config.SQLLOG.rawValue, SQLITE_CONFIG_SQLLOG)
        XCTAssertEqual(Sqlite.Config.MMAP_SIZE.rawValue, SQLITE_CONFIG_MMAP_SIZE)
        XCTAssertEqual(Sqlite.Config.WIN32_HEAPSIZE.rawValue, SQLITE_CONFIG_WIN32_HEAPSIZE)
        XCTAssertEqual(Sqlite.Config.PCACHE_HDRSZ.rawValue, SQLITE_CONFIG_PCACHE_HDRSZ)
        XCTAssertEqual(Sqlite.Config.STMTJRNL_SPILL.rawValue, SQLITE_CONFIG_STMTJRNL_SPILL)
        XCTAssertEqual(Sqlite.Config.SMALL_MALLOC.rawValue, SQLITE_CONFIG_SMALL_MALLOC)
        XCTAssertEqual(Sqlite.Config.SORTERREF_SIZE.rawValue, SQLITE_CONFIG_SORTERREF_SIZE)
        XCTAssertEqual(Sqlite.Config.MEMDB_MAXSIZE.rawValue, SQLITE_CONFIG_MEMDB_MAXSIZE)
    }
    
    func testDbConfig() {
        XCTAssertEqual(Sqlite.DbConfig.MAIN_DB_NAME.rawValue, SQLITE_DBCONFIG_MAINDBNAME)
        XCTAssertEqual(Sqlite.DbConfig.LOOKASIDE.rawValue, SQLITE_DBCONFIG_LOOKASIDE)
        XCTAssertEqual(Sqlite.DbConfig.ENABLE_FKEY.rawValue, SQLITE_DBCONFIG_ENABLE_FKEY)
        XCTAssertEqual(Sqlite.DbConfig.ENABLE_TRIGGER.rawValue, SQLITE_DBCONFIG_ENABLE_TRIGGER)
        XCTAssertEqual(Sqlite.DbConfig.ENABLE_FTS3_TOKENIZER.rawValue, SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER)
        XCTAssertEqual(Sqlite.DbConfig.ENABLE_LOAD_EXTENSION.rawValue, SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION)
        XCTAssertEqual(Sqlite.DbConfig.NO_CKPT_ON_CLOSE.rawValue, SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE)
        XCTAssertEqual(Sqlite.DbConfig.ENABLE_QPSG.rawValue, SQLITE_DBCONFIG_ENABLE_QPSG)
        XCTAssertEqual(Sqlite.DbConfig.TRIGGER_EQP.rawValue, SQLITE_DBCONFIG_TRIGGER_EQP)
        XCTAssertEqual(Sqlite.DbConfig.RESET_DATABASE.rawValue, SQLITE_DBCONFIG_RESET_DATABASE)
        XCTAssertEqual(Sqlite.DbConfig.DEFENSIVE.rawValue, SQLITE_DBCONFIG_DEFENSIVE)
        XCTAssertEqual(Sqlite.DbConfig.WRITABLE_SCHEMA.rawValue, SQLITE_DBCONFIG_WRITABLE_SCHEMA)
    }
    
    func testErrorCode() {
        // https://www.sqlite.org/rescode.html
        XCTAssertEqual(Sqlite.SqliteError.ABORT_ROLLBACK.rawValue, 516)
        XCTAssertEqual(Sqlite.SqliteError.AUTH_USER.rawValue, 279)
        XCTAssertEqual(Sqlite.SqliteError.BUSY_RECOVERY.rawValue, 261)
        XCTAssertEqual(Sqlite.SqliteError.BUSY_SNAPSHOT.rawValue, 517)
        XCTAssertEqual(Sqlite.SqliteError.BUSY_TIMEOUT.rawValue, 773)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_CONVPATH.rawValue, 1038)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_DIRTYWAL.rawValue, 1294)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_FULLPATH.rawValue, 782)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_ISDIR.rawValue, 526)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_NOTEMPDIR.rawValue, 270)
        XCTAssertEqual(Sqlite.SqliteError.CANTOPEN_SYMLINK.rawValue, 1550)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_CHECK.rawValue, 275)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_COMMITHOOK.rawValue, 531)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_DATATYPE.rawValue, 3091)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_FOREIGNKEY.rawValue, 787)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_FUNCTION.rawValue, 1043)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_NOTNULL.rawValue, 1299)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_PINNED.rawValue, 2835)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_PRIMARYKEY.rawValue, 1555)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_ROWID.rawValue, 2579)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_TRIGGER.rawValue, 1811)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_UNIQUE.rawValue, 2067)
        XCTAssertEqual(Sqlite.SqliteError.CONSTRAINT_VTAB.rawValue, 2323)
        XCTAssertEqual(Sqlite.SqliteError.CORRUPT_INDEX.rawValue, 779)
        XCTAssertEqual(Sqlite.SqliteError.CORRUPT_SEQUENCE.rawValue, 523)
        XCTAssertEqual(Sqlite.SqliteError.CORRUPT_VTAB.rawValue, 267)
        XCTAssertEqual(Sqlite.SqliteError.ERROR_MISSING_COLLSEQ.rawValue, 257)
        XCTAssertEqual(Sqlite.SqliteError.ERROR_RETRY.rawValue, 513)
        XCTAssertEqual(Sqlite.SqliteError.ERROR_SNAPSHOT.rawValue, 769)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_ACCESS.rawValue, 3338)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_AUTH.rawValue, 7178)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_BEGIN_ATOMIC.rawValue, 7434)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_BLOCKED.rawValue, 2826)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_CHECKRESERVEDLOCK.rawValue, 3594)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_CLOSE.rawValue, 4106)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_COMMIT_ATOMIC.rawValue, 7690)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_CONVPATH.rawValue, 6666)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_CORRUPTFS.rawValue, 8458)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_DATA.rawValue, 8202)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_DELETE.rawValue, 2570)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_DELETE_NOENT.rawValue, 5898)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_DIR_CLOSE.rawValue, 4362)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_DIR_FSYNC.rawValue, 1290)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_FSTAT.rawValue, 1802)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_FSYNC.rawValue, 1034)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_GETTEMPPATH.rawValue, 6410)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_LOCK.rawValue, 3850)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_MMAP.rawValue, 6154)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_NOMEM.rawValue, 3082)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_RDLOCK.rawValue, 2314)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_READ.rawValue, 266)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_ROLLBACK_ATOMIC.rawValue, 7946)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SEEK.rawValue, 5642)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SHMLOCK.rawValue, 5130)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SHMMAP.rawValue, 5386)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SHMOPEN.rawValue, 4618)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SHMSIZE.rawValue, 4874)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_SHORT_READ.rawValue, 522)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_TRUNCATE.rawValue, 1546)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_UNLOCK.rawValue, 2058)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_VNODE.rawValue, 6922)
        XCTAssertEqual(Sqlite.SqliteError.IOERR_WRITE.rawValue, 778)
        XCTAssertEqual(Sqlite.SqliteError.LOCKED_SHAREDCACHE.rawValue, 262)
        XCTAssertEqual(Sqlite.SqliteError.LOCKED_VTAB.rawValue, 518)
        XCTAssertEqual(Sqlite.SqliteError.NOTICE_RECOVER_ROLLBACK.rawValue, 539)
        XCTAssertEqual(Sqlite.SqliteError.NOTICE_RECOVER_WAL.rawValue, 283)
        XCTAssertEqual(Sqlite.SqliteError.OK_LOAD_PERMANENTLY.rawValue, 256)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_CANTINIT.rawValue, 1288)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_CANTLOCK.rawValue, 520)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_DBMOVED.rawValue, 1032)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_DIRECTORY.rawValue, 1544)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_RECOVERY.rawValue, 264)
        XCTAssertEqual(Sqlite.SqliteError.READONLY_ROLLBACK.rawValue, 776)
        XCTAssertEqual(Sqlite.SqliteError.WARNING_AUTOINDEX.rawValue, 284)
    }
    
    func testLimitFlag() {
        XCTAssertEqual(Sqlite.Limit.LENGTH.rawValue, SQLITE_LIMIT_LENGTH)
        XCTAssertEqual(Sqlite.Limit.SQL_LENGTH.rawValue, SQLITE_LIMIT_SQL_LENGTH)
        XCTAssertEqual(Sqlite.Limit.COLUMN.rawValue, SQLITE_LIMIT_COLUMN)
        XCTAssertEqual(Sqlite.Limit.EXPR_DEPTH.rawValue, SQLITE_LIMIT_EXPR_DEPTH)
        XCTAssertEqual(Sqlite.Limit.COMPOUND_SELECT.rawValue, SQLITE_LIMIT_COMPOUND_SELECT)
        XCTAssertEqual(Sqlite.Limit.VDBE_OP.rawValue, SQLITE_LIMIT_VDBE_OP)
        XCTAssertEqual(Sqlite.Limit.FUNCTION_ARG.rawValue, SQLITE_LIMIT_FUNCTION_ARG)
        XCTAssertEqual(Sqlite.Limit.ATTACHED.rawValue, SQLITE_LIMIT_ATTACHED)
        XCTAssertEqual(Sqlite.Limit.LIKE_PATTERN_LENGTH.rawValue, SQLITE_LIMIT_LIKE_PATTERN_LENGTH)
        XCTAssertEqual(Sqlite.Limit.VARIABLE_NUMBER.rawValue, SQLITE_LIMIT_VARIABLE_NUMBER)
        XCTAssertEqual(Sqlite.Limit.TRIGGER_DEPTH.rawValue, SQLITE_LIMIT_TRIGGER_DEPTH)
        XCTAssertEqual(Sqlite.Limit.WORKER_THREADS.rawValue, SQLITE_LIMIT_WORKER_THREADS)
    }
    
    func testColumnType() {
        XCTAssertEqual(Sqlite.ColumnType.INTEGER.rawValue, SQLITE_INTEGER)
        XCTAssertEqual(Sqlite.ColumnType.FLOAT.rawValue, SQLITE_FLOAT)
        XCTAssertEqual(Sqlite.ColumnType.BLOB.rawValue, SQLITE_BLOB)
        XCTAssertEqual(Sqlite.ColumnType.NULL.rawValue, SQLITE_NULL)
        XCTAssertEqual(Sqlite.ColumnType.TEXT.rawValue, SQLITE_TEXT)
        XCTAssertEqual(Sqlite.ColumnType.TEXT.rawValue, SQLITE3_TEXT)
    }
    
    func testTextEncoding() {
        XCTAssertEqual(Sqlite.TextEncoding.UTF8.rawValue, SQLITE_UTF8)
        XCTAssertEqual(Sqlite.TextEncoding.UTF16LE.rawValue, SQLITE_UTF16LE)
        XCTAssertEqual(Sqlite.TextEncoding.UTF16BE.rawValue, SQLITE_UTF16BE)
        XCTAssertEqual(Sqlite.TextEncoding.UTF16.rawValue, SQLITE_UTF16)
        XCTAssertEqual(Sqlite.TextEncoding.ANY.rawValue, SQLITE_ANY)
        XCTAssertEqual(Sqlite.TextEncoding.UTF16_ALIGNED.rawValue, SQLITE_UTF16_ALIGNED)
    }
    
    func testIndexConstraint() {
        XCTAssertEqual(Sqlite.IndexConstraint.EQ.rawValue, SQLITE_INDEX_CONSTRAINT_EQ)
        XCTAssertEqual(Sqlite.IndexConstraint.GT.rawValue, SQLITE_INDEX_CONSTRAINT_GT)
        XCTAssertEqual(Sqlite.IndexConstraint.LE.rawValue, SQLITE_INDEX_CONSTRAINT_LE)
        XCTAssertEqual(Sqlite.IndexConstraint.LT.rawValue, SQLITE_INDEX_CONSTRAINT_LT)
        XCTAssertEqual(Sqlite.IndexConstraint.GE.rawValue, SQLITE_INDEX_CONSTRAINT_GE)
        XCTAssertEqual(Sqlite.IndexConstraint.MATCH.rawValue, SQLITE_INDEX_CONSTRAINT_MATCH)
        XCTAssertEqual(Sqlite.IndexConstraint.LIKE.rawValue, SQLITE_INDEX_CONSTRAINT_LIKE)
        XCTAssertEqual(Sqlite.IndexConstraint.GLOB.rawValue, SQLITE_INDEX_CONSTRAINT_GLOB)
        XCTAssertEqual(Sqlite.IndexConstraint.REGEXP.rawValue, SQLITE_INDEX_CONSTRAINT_REGEXP)
        XCTAssertEqual(Sqlite.IndexConstraint.NE.rawValue, SQLITE_INDEX_CONSTRAINT_NE)
        XCTAssertEqual(Sqlite.IndexConstraint.ISNOT.rawValue, SQLITE_INDEX_CONSTRAINT_ISNOT)
        XCTAssertEqual(Sqlite.IndexConstraint.ISNOTNULL.rawValue, SQLITE_INDEX_CONSTRAINT_ISNOTNULL)
        XCTAssertEqual(Sqlite.IndexConstraint.ISNULL.rawValue, SQLITE_INDEX_CONSTRAINT_ISNULL)
        XCTAssertEqual(Sqlite.IndexConstraint.IS.rawValue, SQLITE_INDEX_CONSTRAINT_IS)
        XCTAssertEqual(Sqlite.IndexConstraint.FUNCTION.rawValue, SQLITE_INDEX_CONSTRAINT_FUNCTION)
    }
    
    func testDbStatus() {
        XCTAssertEqual(Sqlite.DbStatus.LOOKASIDE_USED.rawValue, SQLITE_DBSTATUS_LOOKASIDE_USED)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_USED.rawValue, SQLITE_DBSTATUS_CACHE_USED)
        XCTAssertEqual(Sqlite.DbStatus.SCHEMA_USED.rawValue, SQLITE_DBSTATUS_SCHEMA_USED)
        XCTAssertEqual(Sqlite.DbStatus.STMT_USED.rawValue, SQLITE_DBSTATUS_STMT_USED)
        XCTAssertEqual(Sqlite.DbStatus.LOOKASIDE_HIT.rawValue, SQLITE_DBSTATUS_LOOKASIDE_HIT)
        XCTAssertEqual(Sqlite.DbStatus.LOOKASIDE_MISS_SIZE.rawValue, SQLITE_DBSTATUS_LOOKASIDE_MISS_SIZE)
        XCTAssertEqual(Sqlite.DbStatus.LOOKASIDE_MISS_FULL.rawValue, SQLITE_DBSTATUS_LOOKASIDE_MISS_FULL)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_HIT.rawValue, SQLITE_DBSTATUS_CACHE_HIT)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_MISS.rawValue, SQLITE_DBSTATUS_CACHE_MISS)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_WRITE.rawValue, SQLITE_DBSTATUS_CACHE_WRITE)
        XCTAssertEqual(Sqlite.DbStatus.DEFERRED_FKS.rawValue, SQLITE_DBSTATUS_DEFERRED_FKS)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_USED_SHARED.rawValue, SQLITE_DBSTATUS_CACHE_USED_SHARED)
        XCTAssertEqual(Sqlite.DbStatus.CACHE_SPILL.rawValue, SQLITE_DBSTATUS_CACHE_SPILL)
        XCTAssertEqual(Sqlite.DbStatus.MAX, SQLITE_DBSTATUS_MAX)
    }
    
    func testStatus() {
        XCTAssertEqual(Sqlite.Status.MEMORY_USED.rawValue, SQLITE_STATUS_MEMORY_USED)
        XCTAssertEqual(Sqlite.Status.PAGECACHE_USED.rawValue, SQLITE_STATUS_PAGECACHE_USED)
        XCTAssertEqual(Sqlite.Status.PAGECACHE_OVERFLOW.rawValue, SQLITE_STATUS_PAGECACHE_OVERFLOW)
        XCTAssertEqual(Sqlite.Status.SCRATCH_USED.rawValue, SQLITE_STATUS_SCRATCH_USED)
        XCTAssertEqual(Sqlite.Status.SCRATCH_OVERFLOW.rawValue, SQLITE_STATUS_SCRATCH_OVERFLOW)
        XCTAssertEqual(Sqlite.Status.MALLOC_SIZE.rawValue, SQLITE_STATUS_MALLOC_SIZE)
        XCTAssertEqual(Sqlite.Status.PARSER_STACK.rawValue, SQLITE_STATUS_PARSER_STACK)
        XCTAssertEqual(Sqlite.Status.PAGECACHE_SIZE.rawValue, SQLITE_STATUS_PAGECACHE_SIZE)
        XCTAssertEqual(Sqlite.Status.SCRATCH_SIZE.rawValue, SQLITE_STATUS_SCRATCH_SIZE)
        XCTAssertEqual(Sqlite.Status.MALLOC_COUNT.rawValue, SQLITE_STATUS_MALLOC_COUNT)
    }
    
    func testStmtStatus() {
        XCTAssertEqual(Sqlite.StmtStatus.FULLSCAN_STEP.rawValue, SQLITE_STMTSTATUS_FULLSCAN_STEP)
        XCTAssertEqual(Sqlite.StmtStatus.SORT.rawValue, SQLITE_STMTSTATUS_SORT)
        XCTAssertEqual(Sqlite.StmtStatus.AUTOINDEX.rawValue, SQLITE_STMTSTATUS_AUTOINDEX)
        XCTAssertEqual(Sqlite.StmtStatus.VM_STEP.rawValue, SQLITE_STMTSTATUS_VM_STEP)
        XCTAssertEqual(Sqlite.StmtStatus.REPREPARE.rawValue, SQLITE_STMTSTATUS_REPREPARE)
        XCTAssertEqual(Sqlite.StmtStatus.RUN.rawValue, SQLITE_STMTSTATUS_RUN)
        XCTAssertEqual(Sqlite.StmtStatus.MEMUSED.rawValue, SQLITE_STMTSTATUS_MEMUSED)
    }
    
    func testConfilict() {
        XCTAssertEqual(Sqlite.Conflict.ROLLBACK.rawValue, SQLITE_ROLLBACK)
        XCTAssertEqual(Sqlite.Conflict.ABORT.rawValue, SQLITE_ABORT)
        XCTAssertEqual(Sqlite.Conflict.FAIL.rawValue, SQLITE_FAIL)
        XCTAssertEqual(Sqlite.Conflict.IGNORE.rawValue, SQLITE_IGNORE)
        XCTAssertEqual(Sqlite.Conflict.REPLACE.rawValue, SQLITE_REPLACE)
    }

    static var allTests = [
        ("testConfig", testConfig),
        ("testDbConfig", testDbConfig),
        ("testErrorCode", testErrorCode),
        ("testLimitFlag", testLimitFlag),
        ("testColumnType", testColumnType),
        ("testTextEncoding", testTextEncoding),
        ("testIndexConstraint", testIndexConstraint),
        ("testDbStatus", testDbStatus),
        ("testStatus", testStatus),
        ("testStmtStatus", testStmtStatus),
        ("testConfilict", testConfilict),
    ]
}
