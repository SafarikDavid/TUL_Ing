package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import java.time.LocalDate;
import java.util.ArrayList;

public class PlayedGamesTrackerActivity extends AppCompatActivity implements GamesRecyclerViewAdapter.ItemClickListener {

    GamesRecyclerViewAdapter adapter;
    private DBHandlerGames dbHandlerGames;
    private ArrayList<Game> games;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_played_games_tracker);

        dbHandlerGames = new DBHandlerGames(PlayedGamesTrackerActivity.this);

        games = new ArrayList<>();

        RecyclerView recyclerView = findViewById(R.id.recyclerViewGames);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new GamesRecyclerViewAdapter(this, games);
        adapter.setClickListener(this);
        recyclerView.setAdapter(adapter);

        updateListFromDB();
    }

    private void updateListFromDB() {
        games.clear();
        games.addAll(dbHandlerGames.readGames());
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onItemClick(View view, int position) {

    }

    public void addGameButtonClick(View view){
        Intent intent = new Intent(this, AddGameFormActivity.class);
        startActivity(intent);
    }
}