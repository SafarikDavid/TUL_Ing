package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.TextView;

import java.util.ArrayList;

public class GameDetailActivity extends AppCompatActivity {
    int game_id;
    TextView textViewGameDetail;
    DBHandler dbHandler;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game_detail);

        Bundle extras = getIntent().getExtras();
        if (extras != null){
            game_id = extras.getInt("game_id");
        }

        dbHandler = new DBHandler(this);

        textViewGameDetail = findViewById(R.id.textViewGameDetail);

        Game game = dbHandler.readGame(game_id);

        ArrayList<GamePlayer> winnersTemp = dbHandler.readGameWinners();
        ArrayList<GamePlayer> winners = new ArrayList<>();
        for (GamePlayer gp:
             winnersTemp) {
            if (gp.getId_game() == game_id){
                winners.add(gp);
            }
        }

        ArrayList<GamePlayer> playersTemp = dbHandler.readGamePlayers();
        ArrayList<GamePlayer> players = new ArrayList<>();
        for (GamePlayer gp:
                playersTemp) {
            if (gp.getId_game() == game_id){
                players.add(gp);
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.append(game.toString());
        sb.append("\n");
        sb.append(getText(R.string.Winners_text));
        sb.append(": ");
        for (GamePlayer gp:
             winners) {
            sb.append(dbHandler.readPlayer(gp.getId_player()).getName());
            sb.append(", ");
        }
        sb.deleteCharAt(sb.length()-1);
        sb.deleteCharAt(sb.length()-1);
        sb.append("\n");
        sb.append(getText(R.string.Players_text));
        sb.append(": ");
        for (GamePlayer gp:
                players) {
            sb.append(dbHandler.readPlayer(gp.getId_player()).getName());
            sb.append(", ");
        }
        sb.deleteCharAt(sb.length()-1);
        sb.deleteCharAt(sb.length()-1);

        textViewGameDetail.setText(sb.toString());
    }
}