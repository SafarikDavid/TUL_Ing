package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import java.util.ArrayList;

public class PlayersActivity extends AppCompatActivity implements PlayersRecyclerViewAdapter.ItemClickListener {

    PlayersRecyclerViewAdapter adapter;
    private DBHandlerPlayers dbHandlerPlayers;
    private EditText editTextNewPlayerName;
    private EditText editTextPlayerId_delete;
    private ArrayList<Player> players;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_players);

        editTextNewPlayerName = findViewById(R.id.editTextNewPlayerName);
        editTextPlayerId_delete = findViewById(R.id.editTextPlayerId_delete);

        dbHandlerPlayers = new DBHandlerPlayers(PlayersActivity.this);

        players = new ArrayList<>();

        // set up the RecyclerView
        RecyclerView recyclerView = findViewById(R.id.view_players);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new PlayersRecyclerViewAdapter(this, players);
        adapter.setClickListener(this);
        recyclerView.setAdapter(adapter);

        updateListFromDB();
    }

    public void updateListFromDB(){
        players.clear();
        players.addAll(dbHandlerPlayers.readPlayers());
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onItemClick(View view, int position) {
        Toast.makeText(this, "You clicked " + adapter.getItem(position) + " on row " + position, Toast.LENGTH_SHORT).show();
        Intent intent = new Intent(this, PlayerDetailActivity.class);
        Player player = adapter.getPlayers().get(position);
        intent.putExtra("player_id", player.get_id());
        startActivity(intent);
    }

    public void addPlayerButtonClick(View view){
        String name = editTextNewPlayerName.getText().toString();

        if (name.isEmpty()){
            Toast.makeText(this, R.string.toast_enter_player_name, Toast.LENGTH_SHORT).show();
            return;
        }

        if (dbHandlerPlayers.addNewPlayer(name)){
            Toast.makeText(this, R.string.toast_entered_player_name, Toast.LENGTH_SHORT).show();
        }else{
            Toast.makeText(this, R.string.toast_entered_player_name_not_valid, Toast.LENGTH_SHORT).show();
        }

        editTextNewPlayerName.setText("");

        updateListFromDB();
    }

    public void deletePlayerButtonClick(View view){
        try {
            int id = Integer.parseInt(editTextPlayerId_delete.getText().toString());
            if (dbHandlerPlayers.deletePlayer(id)) {
                Toast.makeText(this, "Deleted " + id, Toast.LENGTH_SHORT).show();
            }else {
                Toast.makeText(this, "Deletion not successful.", Toast.LENGTH_SHORT).show();
            }
        } catch (Exception e){
            Toast.makeText(this, "Invalid id.", Toast.LENGTH_SHORT).show();
        }
        editTextPlayerId_delete.setText("");

        updateListFromDB();
    }

}