package com.example.cv3;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

public class MainActivity extends AppCompatActivity {
    private static final String LOG_TAG =
            MainActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void showBMI(View view){
        Log.d(LOG_TAG, "Button clicked!");

        final EditText editHeight =  (EditText) findViewById(R.id.editHeight);
        if (editHeight.getText().length() <= 0) return;
        float height = Float.parseFloat(editHeight.getText().toString())/100;

        final EditText editWeight = (EditText) findViewById(R.id.editWeight);
        if (editWeight.getText().length() <= 0) return;
        float weight = Float.parseFloat(editWeight.getText().toString());

        float bmi = weight/(height*height);

        Intent intent = new Intent(this, BMIActivity.class);
        intent.putExtra("bmi", bmi);
        startActivity(intent);
    }

}