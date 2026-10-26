import SQLiteData

public func appDatabase() throws -> any DatabaseWriter {
    let database = try SQLiteData.defaultDatabase()
    print("SQLITE DATABASE PATH: ", database.path)

    var migrator = DatabaseMigrator()
    #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
    #endif

    migrator.registerMigration("Create episodes") { db in
        try #sql(
            """
            CREATE TABLE "episodes" (
                "id" INTEGER PRIMARY KEY NOT NULL,
                "episodeNumber" INTEGER NOT NULL,
                "title" TEXT NOT NULL,
                "summary" TEXT NOT NULL,
                "publishedAt" TEXT NOT NULL,
                "updatedAt" TEXT NOT NULL,
                "duration" INTEGER NOT NULL,
                "episodeType" TEXT NOT NULL,
                "artworkSmallURL" TEXT NOT NULL
            ) STRICT
            """
        ).execute(db)
    }

    try migrator.migrate(database)
    return database
}
