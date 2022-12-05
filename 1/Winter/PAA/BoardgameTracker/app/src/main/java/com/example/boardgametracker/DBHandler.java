package com.example.boardgametracker;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;

//https://www.geeksforgeeks.org/how-to-create-and-add-data-to-sqlite-database-in-android/
public class DBHandler extends SQLiteOpenHelper {
    private static final String DB_NAME = "BoardgamesTrackerDB";
    private static final int DB_VERSION = 1;
    private static final String PLAYERS_TABLE_NAME = "players";
    private static final String GAMES_TABLE_NAME = "games";
    private static final String ID_COL = "id";
    private static final String NAME_COL = "name";
    private static final String DATE_COL = "date";
    private static final String GAME_WINNER_TABLE_NAME = "games_winners";
    private static final String GAME_PLAYER_TABLE_NAME = "games_players";
    private static final String GAMES_TABLE_ID_COL = "game_id";
    private static final String PLAYERS_TABLE_ID_COL = "player_id";

    public DBHandler(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onConfigure(SQLiteDatabase db) {
        db.setForeignKeyConstraintsEnabled(true);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        String query;

        query = "CREATE TABLE " + PLAYERS_TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + NAME_COL + " TEXT UNIQUE)";

        sqLiteDatabase.execSQL(query);

        query = "CREATE TABLE " + GAMES_TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + NAME_COL + " TEXT, "
                + DATE_COL + " TEXT)";

        sqLiteDatabase.execSQL(query);

        query = "CREATE TABLE " + GAME_WINNER_TABLE_NAME + " ("
                + GAMES_TABLE_ID_COL + " INTEGER NOT NULL, "
                + PLAYERS_TABLE_ID_COL + " INTEGER NOT NULL, " +
                "PRIMARY KEY ( " + GAMES_TABLE_ID_COL + ", " + PLAYERS_TABLE_ID_COL + " ), " +
                "FOREIGN KEY(" + GAMES_TABLE_ID_COL + ") REFERENCES " + GAMES_TABLE_NAME + "(" + ID_COL + ") " +
                "ON UPDATE CASCADE " +
                "ON DELETE CASCADE," +
                "FOREIGN KEY(" + PLAYERS_TABLE_ID_COL + ") REFERENCES " + PLAYERS_TABLE_NAME + "(" + ID_COL + ") " +
                "ON UPDATE CASCADE " +
                "ON DELETE CASCADE" +
                ")";

        sqLiteDatabase.execSQL(query);

        query = "CREATE TABLE " + GAME_PLAYER_TABLE_NAME + " ("
                + GAMES_TABLE_ID_COL + " INTEGER NOT NULL, "
                + PLAYERS_TABLE_ID_COL + " INTEGER NOT NULL, " +
                "PRIMARY KEY ( " + GAMES_TABLE_ID_COL + ", " + PLAYERS_TABLE_ID_COL + " ), " +
                "FOREIGN KEY(" + GAMES_TABLE_ID_COL + ") REFERENCES " + GAMES_TABLE_NAME + "(" + ID_COL + ") " +
                "ON UPDATE CASCADE " +
                "ON DELETE CASCADE," +
                "FOREIGN KEY(" + PLAYERS_TABLE_ID_COL + ") REFERENCES " + PLAYERS_TABLE_NAME + "(" + ID_COL + ") " +
                "ON UPDATE CASCADE " +
                "ON DELETE CASCADE" +
                ")";

        sqLiteDatabase.execSQL(query);
    }

    public boolean addNewGameWinner(int game_id, int player_id){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(GAMES_TABLE_ID_COL, game_id);
        values.put(PLAYERS_TABLE_ID_COL, player_id);
        long success = db.insert(GAME_WINNER_TABLE_NAME, null, values);
        db.close();
        return success > 0;
    }

    public boolean addNewGamePlayer(int game_id, int player_id){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(GAMES_TABLE_ID_COL, game_id);
        values.put(PLAYERS_TABLE_ID_COL, player_id);
        long success = db.insert(GAME_PLAYER_TABLE_NAME, null, values);
        db.close();
        return success > 0;
    }

    public ArrayList<GamePlayer> readGameWinners(){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + GAME_WINNER_TABLE_NAME, null);

        ArrayList<GamePlayer> gameWinnersArrayList = new ArrayList<>();

        if (cursor.moveToFirst()){
            do{
                gameWinnersArrayList.add(new GamePlayer(
                        cursor.getInt(0),
                        cursor.getInt(1))
                );
            }while (cursor.moveToNext());
        }

        cursor.close();

        return gameWinnersArrayList;
    }

    public ArrayList<GamePlayer> readGamePlayers(){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + GAME_PLAYER_TABLE_NAME, null);

        ArrayList<GamePlayer> gamePlayersArrayList = new ArrayList<>();

        if (cursor.moveToFirst()){
            do{
                gamePlayersArrayList.add(new GamePlayer(
                        cursor.getInt(0),
                        cursor.getInt(1))
                );
            }while (cursor.moveToNext());
        }

        cursor.close();

        return gamePlayersArrayList;
    }

    public boolean addNewPlayer(String name){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(NAME_COL, name);
        long success = db.insert(PLAYERS_TABLE_NAME, null, values);
        db.close();
        return success > 0;
    }

    public ArrayList<Player> readPlayers(){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + PLAYERS_TABLE_NAME, null);

        ArrayList<Player> playersArrayList = new ArrayList<>();

        if (cursor.moveToFirst()){
            do{
                playersArrayList.add(new Player(
                        cursor.getString(1),
                        cursor.getInt(0))
                );
            }while (cursor.moveToNext());
        }

        cursor.close();

        return playersArrayList;
    }

    public Player readPlayer(int id){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + PLAYERS_TABLE_NAME, null);

        if (cursor.moveToFirst()){
            do{
                Player player = new Player(
                        cursor.getString(1),
                        cursor.getInt(0)
                );
                if (player.get_id() == id) {
                    cursor.close();
                    return player;
                }
            }while (cursor.moveToNext());
        }

        cursor.close();

        return null;
    }

    public boolean deletePlayer(int id){
        SQLiteDatabase db = this.getWritableDatabase();
        int success = db.delete(PLAYERS_TABLE_NAME, String.format("%s = ?", ID_COL), new String[]{String.valueOf(id)});
        db.close();
        return success > 0;
    }

    public void updatePlayer(int id, String new_name){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(NAME_COL, new_name);

        db.update(PLAYERS_TABLE_NAME, values, String.format("%s = ?", ID_COL), new String[]{String.valueOf(id)});
        db.close();
    }

    public long addNewGame(String name, String date){
        Log.v("DBHandlerGames", "adding new game");
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(NAME_COL, name);
        values.put(DATE_COL, date);
        long line = db.insert(GAMES_TABLE_NAME, null, values);
        db.close();
        return line;
    }

    public ArrayList<Game> readGames(){
        Log.v("tady", "reading games");
        SQLiteDatabase db = this.getReadableDatabase();
        Log.v("tady", "reading games2");

        Cursor cursor = db.rawQuery("SELECT * FROM " + GAMES_TABLE_NAME, null);
        Log.v("tady", "reading games3");

        ArrayList<Game> gamesArrayList = new ArrayList<>();
        Log.v("tady", "reading games4");

        if (cursor.moveToFirst()){
            do{
                gamesArrayList.add(new Game(
                        cursor.getInt(0),
                        cursor.getString(1),
                        cursor.getString(2))
                );
            }while (cursor.moveToNext());
        }

        cursor.close();

        return gamesArrayList;
    }

    public Game readGame(int id){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + GAMES_TABLE_NAME, null);

        if (cursor.moveToFirst()){
            do{
                Game game = new Game(
                        cursor.getInt(0),
                        cursor.getString(1),
                        cursor.getString(2)
                );
                if (game.get_id() == id) {
                    cursor.close();
                    return game;
                }
            }while (cursor.moveToNext());
        }

        cursor.close();

        return null;
    }

    public boolean deleteGame(int id){
        SQLiteDatabase db = this.getWritableDatabase();
        int success = db.delete(
                GAMES_TABLE_NAME,
                String.format("%s = ?", ID_COL),
                new String[]{String.valueOf(id)}
        );
        db.close();
        return success > 0;
    }

    public void updateGame(int id, String new_name, String new_date){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(NAME_COL, new_name);
        values.put(DATE_COL, new_date);

        db.update(
                GAMES_TABLE_NAME,
                values,
                String.format("%s = ?", ID_COL),
                new String[]{String.valueOf(id)}
        );
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + PLAYERS_TABLE_NAME);
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + GAMES_TABLE_NAME);
        onCreate(sqLiteDatabase);
    }
}
