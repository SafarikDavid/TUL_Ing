package com.example.cv3;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import java.util.HashMap;
import java.util.LinkedHashMap;

public class BMIActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bmiactivity);
        Intent intent = getIntent();
        float bmi = intent.getFloatExtra("bmi", 0);
        TextView textViewBMI = (TextView) findViewById(R.id.textViewBMI);
        textViewBMI.setText(String.format("BMI: %.2f", bmi));



        TextView textViewComment = (TextView) findViewById(R.id.textViewFatness);
        textViewComment.setText(commentsDictionary.get(100));

        for (int key:
                commentsDictionary.keySet()) {
            if (bmi >= key) continue;
            textViewComment.setText(commentsDictionary.get(key));
            break;
        }
    }

    public static HashMap<Integer, String> commentsDictionary;
    static {
        commentsDictionary = new LinkedHashMap<>();
        commentsDictionary.put(16, "Severe Thinness");
        commentsDictionary.put(17, "Moderate Thinness");
        commentsDictionary.put(19, "Mild Thinness");
        commentsDictionary.put(25, "Normal");
        commentsDictionary.put(30, "Overweight");
        commentsDictionary.put(35, "Obese Class 1");
        commentsDictionary.put(40, "Obese Class 2");
        commentsDictionary.put(100, "Obese Class 3");
    }
}