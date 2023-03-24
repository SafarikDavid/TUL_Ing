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
    private TextView textViewPlayerDetails;
    private DBHandler dbHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player_detail);

        Bundle extras = getIntent().getExtras();
        if (extras != null){
            player_id = extras.getInt("player_id");
        }

        textViewPlayerDetails = findViewById(R.id.textViewPlayerDetails);

        dbHandler = new DBHandler(PlayerDetailActivity.this);

        updateActivityText();
    }

    private void updateActivityText(){
        readPlayerFromDB();
        updateTextViews();
    }

    private void readPlayerFromDB(){
        player = dbHandler.readPlayer(player_id);
    }

    private void updateTextViews(){
        if (player != null) {
            textViewPlayerDetails.setText(String.format("ID: %s\n%s: %s",
                    String.valueOf(player.get_id()),
                    getString(R.string.player_name),
                    player.getName()));
        }
    }

    public void onClickUpdate(View view){
        EditText editText = findViewById(R.id.editTextUpdatePlayerName);
        String newName = String.valueOf(editText.getText());
        if (newName.length() > 0) {
            dbHandler.updatePlayer(player_id, newName);
        } else {
            Toast.makeText(this, R.string.toast_invalid_update_name, Toast.LENGTH_SHORT).show();
        }
        editText.setText("");
        updateActivityText();
    }

    public void deletePlayerButtonClick(View view){
        dbHandler.deletePlayer(player_id);
        finish();
    }
}