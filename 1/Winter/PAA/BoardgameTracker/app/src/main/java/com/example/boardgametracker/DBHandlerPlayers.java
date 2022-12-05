package com.example.boardgametracker;

import static androidx.core.content.res.TypedArrayUtils.getText;

import android.content.ContentValues;
import android.content.Context;
import android.content.res.Resources;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;

//https://www.geeksforgeeks.org/how-to-create-and-add-data-to-sqlite-database-in-android/
public class DBHandlerPlayers extends SQLiteOpenHelper {
    private static final String DB_NAME = "BoardgamesTrackerDB";
    private static final int DB_VERSION = 1;
    private static final String TABLE_NAME = "players";
    private static final String ID_COL = "id";
    private static final String NAME_COL = "name";

    public DBHandlerPlayers(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        String query = "CREATE TABLE " + TABLE_NAME + " ("
                + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + NAME_COL + " TEXT UNIQUE)";

        sqLiteDatabase.execSQL(query);
    }

    public boolean addNewPlayer(String name){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(NAME_COL, name);
        long success = db.insert(TABLE_NAME, null, values);
        db.close();
        return success > 0;
    }

    public ArrayList<Player> readPlayers(){
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);

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

        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);

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
        int success = db.delete(TABLE_NAME, String.format("%s = ?", ID_COL), new String[]{String.valueOf(id)});
        db.close();
        return success > 0;
    }

    public void updatePlayer(int id, String new_name){
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(NAME_COL, new_name);

        db.update(TABLE_NAME, values, String.format("%s = ?", ID_COL), new String[]{String.valueOf(id)});
        db.close();
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
        onCreate(sqLiteDatabase);
    }
}
