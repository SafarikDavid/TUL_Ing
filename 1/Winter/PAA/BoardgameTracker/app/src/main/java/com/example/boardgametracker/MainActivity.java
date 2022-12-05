package com.example.boardgametracker;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;

import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    Context context;
    Resources resources;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void playersButtonClick(View view){
        Intent intent = new Intent(this, PlayersActivity.class);
        startActivity(intent);
    }

    public void gamesButtonClick(View view){
        Intent intent = new Intent(this, PlayedGamesTrackerActivity.class);
        startActivity(intent);
    }

    public void engLangButtonClick(View view){
        setLocale(MainActivity.this, "en");
        finish();
        startActivity(getIntent());
    }

    public void czechLangButtonClick(View view){
        setLocale(MainActivity.this, "cs");
        finish();
        startActivity(getIntent());
    }

    public void setLocale(Activity activity, String langCode){
        Locale locale = new Locale(langCode);
        locale.setDefault(locale);
        Resources resources = this.getResources();
        Configuration configuration = resources.getConfiguration();
        configuration.setLocale(locale);
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
    }
}