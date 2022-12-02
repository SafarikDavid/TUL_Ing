package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class PlayerDetailActivity extends AppCompatActivity {
    private int player_id;
    private Player player;
    private TextView textView_id;
    private TextView textView_name;
    private DBHandlerPlayers dbHandlerPlayers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player_detail);

        Bundle extras = getIntent().getExtras();
        if (extras != null){
            player_id = extras.getInt("player_id");
        }

        textView_id = findViewById(R.id.textViewPlayerId);
        textView_name = findViewById(R.id.textViewPlayerName);

        dbHandlerPlayers = new DBHandlerPlayers(PlayerDetailActivity.this);

        updateActivityText();
    }

    private void updateActivityText(){
        readPlayerFromDB();
        updateTextViews();
    }

    private void readPlayerFromDB(){
        player = dbHandlerPlayers.readPlayer(player_id);
    }

    private void updateTextViews(){
        if (player != null) {
            textView_id.setText(String.format("ID: %s", String.valueOf(player.get_id())));
            textView_name.setText(String.format("%s: %s", getString(R.string.player_name), player.getName()));
        }
    }

    public void onClickUpdate(View view){
        EditText editText = findViewById(R.id.editTextUpdatePlayerName);
        String newName = String.valueOf(editText.getText());
        if (newName.length() > 0) {
            dbHandlerPlayers.updatePlayer(player_id, newName);
        } else {
            Toast.makeText(this, R.string.toast_invalid_update_name, Toast.LENGTH_SHORT).show();
        }
        editText.setText("");
        updateActivityText();
    }
}