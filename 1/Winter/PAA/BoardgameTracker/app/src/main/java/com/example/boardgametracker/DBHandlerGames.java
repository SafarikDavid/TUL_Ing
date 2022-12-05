package com.example.boardgametracker;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;

public class DBHandlerGames extends SQLiteOpenHelper {
    private static final String DB_NAME = "BoardgamesTrackerDB";
    private static final int DB_VERSION = 1;
    private static final String TABLE_NAME = "games";
    private static final String ID_COL = "id";
    private static final String NAME_COL = "name";
    private static final String DATE_COL = "date";

    public DBHandlerGames(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        Log.v("DBHandlerGames", "onCreate");
        String query = "CREATE TABLE " + TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + NAME_COL + " TEXT, "
                + DATE_COL + " TEXT)";

        sqLiteDatabase.execSQL(query);
    }

    public boolean addNewGame(String name, String date){
        Log.v("DBHandlerGames", "adding new game");
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(NAME_COL, name);
        values.put(DATE_COL, date);
        long success = db.insert(TABLE_NAME, null, values);
        db.close();
        return success > 0;
    }

    public ArrayList<Game> readGames(){
        Log.v("DBHandlerGames", "reading games");
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);

        ArrayList<Game> gamesArrayList = new ArrayList<>();

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

    public Game readPlayer(int id){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);

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
                TABLE_NAME,
                String.format("%s = ?", ID_COL),
                new String[]{String.valueOf(id)}
        );
        db.close();
        return success > 0;
    }

    public void updatePlayer(int id, String new_name, String new_date){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(NAME_COL, new_name);
        values.put(DATE_COL, new_date);

        db.update(
                TABLE_NAME,
                values,
                String.format("%s = ?", ID_COL),
                new String[]{String.valueOf(id)}
        );
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
        onCreate(sqLiteDatabase);
    }
}
