package com.example.lifecycles;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import kotlin.NotImplementedError;

public class MainActivity extends AppCompatActivity {

    public int numberOfClicks;
    public int numberOfClicksThisInstance;
    public final String N_CLICKS = "N_CLICKS";
    public int numberOfDestroys;
    public final String N_DESTROYS = "N_DESTROYS";
//    shared preferences sem nasledne prace s tady
    private SharedPreferences mySharedPreferences;
    private ArrayList<String> values;
    private ListView seznam;
    private ArrayAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        toto bude asi potreba zmenit
        values = new ArrayList<>();//pole hodnot
        seznam = (ListView) findViewById(R.id.seznam);
        adapter = new ArrayAdapter(this, android.R.layout.simple_list_item_1, values);
        seznam.setAdapter(adapter);
//        konec
//        TODO upravit aby
//         1) kliknuti na button pridalo zaznam do listu
//         2) libovolna dalsi zivotni faze, necht se zobrazi v seznamu

        if(savedInstanceState != null){
            Log.v("onCreate", "savedInstanceState is not empty.");
        }else{
            Log.v("onCreate", "savedInstanceState is empty.");
        }

        mySharedPreferences = getSharedPreferences("MY_PREF", MODE_PRIVATE);

        numberOfClicks = mySharedPreferences.getInt(N_CLICKS, -1);
        numberOfDestroys = mySharedPreferences.getInt(N_DESTROYS, -1);
        refreshWelcomeText();
        Log.v("LifeCycles", "Jsem v OnCreate");
    }

    public void addToListView(String entry){
        values.add(entry);
        seznam.setAdapter(adapter);
    }

    public String getTimeNow(){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
        return simpleDateFormat.format(new Date());//ulozeni aktualniho casu ve forme retezce
    }

    public void click(View view){//v activity_main.xml jsem tuto metodu pridal k button u parametru onClick
        numberOfClicks++;
        numberOfClicksThisInstance++;
        refreshWelcomeText();
        addToListView("Click " + numberOfClicks + ": " + getTimeNow());
    }

    private void refreshWelcomeText() {
        TextView textView = (TextView) findViewById(R.id.textView);
        textView.setText(String.format("Pocet celkovych kliku je: %d\n" +
                "Pocet kliku aktualni realce je: %d\n" +
                "Pocet destroys: %d",
                numberOfClicks, numberOfClicksThisInstance, numberOfDestroys));
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        outState.putInt(N_CLICKS, numberOfClicks);
        outState.putInt(N_DESTROYS, numberOfDestroys);
        super.onSaveInstanceState(outState);
        Log.v("onSaveInstanceState", "Saving number of clicks.");
        Log.v("LifeCycles", "Jsem v OnSave");
    }

    @Override
    protected void onRestoreInstanceState(@NonNull Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        this.numberOfClicks = savedInstanceState.getInt(N_CLICKS, -1);
        this.numberOfDestroys = savedInstanceState.getInt(N_DESTROYS, -1);
        //Kdyby neexistoval "N_CLICKS" potom numberOfClicks dostane -1
        Log.v("onSaveInstanceState", "Retrieving number of clicks.");
        refreshWelcomeText();
        Log.v("LifeCycles", "Jsem v onRestore");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.v("onSaveInstanceState", "I am paused.");
        SharedPreferences.Editor editor = mySharedPreferences.edit();
        editor.putInt(N_CLICKS, numberOfClicks);
        editor.commit();
        Log.v("LifeCycles", "Jsem v OnPause");
        addToListView("Pause: " + getTimeNow());
        
    }

    @Override
    protected void onResume() {
        Log.v("LifeCycles", "Jsem v Resume");
        addToListView("Resume: " + getTimeNow());
        super.onResume();
    }

    @Override
    protected void onRestart() {
        Log.v("LifeCycles", "Jsem v Restart");
        super.onRestart();
    }

    @Override
    protected void onStop() {
        Log.v("LifeCycles", "Jsem v onStrop");
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        Log.v("LifeCycles", "Jsem v onDestroy");
        numberOfDestroys++;
        SharedPreferences.Editor editor = mySharedPreferences.edit();
        editor.putInt(N_DESTROYS, numberOfDestroys);
//        kdyz nezabere presunout shared pref ven, tak sem dat apply
        editor.commit();
        super.onDestroy();
        Log.v("LifeCycles", "Jsem v onDestroy");
    }

    public void click_reset_clicks(View view){
        throw new NotImplementedError("Not yet implemented.");
    }
}