package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import java.util.ArrayList;

public class PlayedGamesTrackerActivity extends AppCompatActivity implements GamesRecyclerViewAdapter.ItemClickListener {

    GamesRecyclerViewAdapter adapter;
    private DBHandler dbHandler;
    private ArrayList<Game> games;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_played_games_tracker);

        dbHandler = new DBHandler(PlayedGamesTrackerActivity.this);

        games = new ArrayList<>();

        RecyclerView recyclerView = findViewById(R.id.recyclerViewGames);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new GamesRecyclerViewAdapter(this, games);
        adapter.setClickListener(this);
        recyclerView.setAdapter(adapter);

        updateListFromDB();
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateListFromDB();
    }

    private void updateListFromDB() {
        games.clear();
        games.addAll(dbHandler.readGames());
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onItemClick(View view, int position) {
        Intent intent = new Intent(this, GameDetailActivity.class);
        Game game = adapter.getGames().get(position);
        intent.putExtra("game_id", game.get_id());
        startActivity(intent);
    }

    public void addGameButtonClick(View view){
        Intent intent = new Intent(this, AddGameFormActivity.class);
        startActivity(intent);
    }
}