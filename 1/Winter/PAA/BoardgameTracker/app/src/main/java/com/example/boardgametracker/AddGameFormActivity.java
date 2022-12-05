package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;

public class AddGameFormActivity extends AppCompatActivity implements PlayersSelectRecyclerViewAdapter.ItemClickListener {
    private DBHandler dbHandler;
    private EditText editTextName;
    private TextView textViewDate;
    private LocalDate localDate;
    private ArrayList<PlayerSelect> winners;
    PlayersSelectRecyclerViewAdapter adapterWinners;
    private ArrayList<PlayerSelect> players;
    PlayersSelectRecyclerViewAdapter adapterPlayers;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_game_form);

        dbHandler = new DBHandler(this);

        textViewDate = findViewById(R.id.textViewDate);

        editTextName = findViewById(R.id.editTextGameName);

        localDate = LocalDate.now();

        setTextDate();

        players = new ArrayList<>();
        winners = new ArrayList<>();

        adapterWinners = new PlayersSelectRecyclerViewAdapter(this, winners);
        adapterWinners.setClickListener(this);

        // set up the RecyclerViews
        RecyclerView recyclerViewWinners = findViewById(R.id.recyclerViewWinners);
        recyclerViewWinners.setLayoutManager(new LinearLayoutManager(this));
        recyclerViewWinners.setItemAnimator(new DefaultItemAnimator());
        recyclerViewWinners.setAdapter(adapterWinners);

        updateListFromDB(winners);
        adapterWinners.notifyDataSetChanged();

        adapterPlayers = new PlayersSelectRecyclerViewAdapter(this, players);
        adapterPlayers.setClickListener(this);

        RecyclerView recyclerViewPlayers = findViewById(R.id.recyclerViewPlayers);
        recyclerViewPlayers.setLayoutManager(new LinearLayoutManager(this));
        recyclerViewPlayers.setItemAnimator(new DefaultItemAnimator());
        recyclerViewPlayers.setAdapter(adapterPlayers);

        updateListFromDB(players);
        adapterPlayers.notifyDataSetChanged();
    }

    public void updateListFromDB(ArrayList<PlayerSelect> list){
        list.clear();
        ArrayList<Player> playersTemp = dbHandler.readPlayers();
        ArrayList<PlayerSelect> playerSelects = new ArrayList<>();
        for (Player p:
             playersTemp) {
            playerSelects.add(new PlayerSelect(p));
        }
        list.addAll(playerSelects);
    }

    public void addGameClick(View view){
        String name = String.valueOf(editTextName.getText());
        if (localDate == null){
            return;
        }
        String date = localDate.toString();
        if (name.length() <= 0 || date.length() <= 0) {
            Toast.makeText(this, "Is empty", Toast.LENGTH_SHORT).show();
        }else{
            int line = (int) dbHandler.addNewGame(name, date);
            int game_id = dbHandler.readGames().get(line - 1).get_id();
            boolean success = true;
            for (PlayerSelect playerSelect:
                 winners) {
                if (playerSelect.isSelected()) {
                    success = success && dbHandler.addNewGameWinner(game_id, playerSelect.get_id());
                }
            }
            for (PlayerSelect playerSelect:
                    players) {
                if (playerSelect.isSelected()) {
                    success = success && dbHandler.addNewGamePlayer(game_id, playerSelect.get_id());
                }
            }
            if (success == false) {
                Toast.makeText(this, String.format("%b", false), Toast.LENGTH_SHORT).show();
            }
            finish();
        }
    }

    public void setTextDate(){
        textViewDate.setText(localDate.toString());
    }

    public void showDatePickerDialog(View v) {
        final Calendar calendar = Calendar.getInstance();

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog datePickerDialog = new DatePickerDialog(
                AddGameFormActivity.this,
                new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year,
                                          int monthOfYear, int dayOfMonth) {
                        // on below line we are setting date to our text view.
                        localDate = LocalDate.of(year, month+1, day);
                        setTextDate();
                    }
                },
                year, month, day);
        datePickerDialog.show();
    }

    @Override
    public void onItemClick(View view, int position) {

    }
}