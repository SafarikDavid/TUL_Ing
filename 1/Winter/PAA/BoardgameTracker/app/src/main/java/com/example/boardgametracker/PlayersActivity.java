package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_players);

        editTextNewPlayerName = findViewById(R.id.editTextNewPlayerName);

        dbHandlerPlayers = new DBHandlerPlayers(PlayersActivity.this);

        // data to populate the RecyclerView with
        ArrayList<Player> players = new ArrayList<>();
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        players.add(new Player("Filip", 0));
        players.add(new Player("Dom", 1));
        players.add(new Player("Kirin", 2));
        players.add(new Player("Lul", 3));
        // set up the RecyclerView
        RecyclerView recyclerView = findViewById(R.id.view_players);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new PlayersRecyclerViewAdapter(this, players);
        adapter.setClickListener(this);
        recyclerView.setAdapter(adapter);
    }

    @Override
    public void onItemClick(View view, int position) {
        Toast.makeText(this, "You clicked" + adapter.getItem(position) + "or row" + position, Toast.LENGTH_SHORT).show();
    }

    public void addPlayerButtonClick(View view){
        String name = editTextNewPlayerName.getText().toString();

        if (name.isEmpty()){
            Toast.makeText(this, R.string.toast_enter_player_name, Toast.LENGTH_SHORT).show();
            return;
        }

        dbHandlerPlayers.addNewPlayer(name);

        Toast.makeText(this, R.string.toast_entered_player_name, Toast.LENGTH_SHORT).show();
        editTextNewPlayerName.setText("");
    }


}