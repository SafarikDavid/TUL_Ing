package com.example.uceninazk;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

public class MainActivity extends AppCompatActivity {
    private Handler mHandler;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        JSONObject jsonObject = new JSONObject();
        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < 5; i++){
            JSONObject tempObject = new JSONObject();
            try {
                tempObject.put("number", i);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            jsonArray.put(tempObject);
        }
        try {
            jsonObject.put("array", jsonArray);
        } catch (JSONException e) {
            e.printStackTrace();
        }


        Button button = findViewById(R.id.button2);
        button.setOnClickListener(view -> {
            AsyncTask<String, Integer, Double> myTask = new AsyncTask<String, Integer, Double>() {
                @Override
                protected void onPreExecute() {
                    EditText editText = findViewById(R.id.editTextTextPersonName);
                    editText.setText("Writing to file...");
                    super.onPreExecute();
                }

                @Override
                protected Double doInBackground(String... strings) {
                    Double result = 1.;
                    int progress = 0;
                    for (int i = 0; i <= 100; i++){
                        progress = i;
                        publishProgress(progress);
                        try {
                            Thread.sleep(50);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    writeToFile();
                    return result;
                }

                @Override
                protected void onProgressUpdate(Integer... values) {
                    ProgressBar progressBar = findViewById(R.id.progressBar2);
                    progressBar.setProgress(values[0]);
                    super.onProgressUpdate(values);
                }

                @Override
                protected void onPostExecute(Double aDouble) {
                    EditText editText = findViewById(R.id.editTextTextPersonName);
                    editText.setText("Writing to file complete");
                    super.onPostExecute(aDouble);
                }
            };
            myTask.execute("param");
        });
        mHandler = new Handler(){
            public void handleMessage(Message msg){
                Bundle bundle = msg.getData();
                EditText editText = findViewById(R.id.editTextTextPersonName);
                editText.setText(bundle.getString("text"));
            }
        };
        button = findViewById(R.id.button3);
        button.setOnClickListener(view -> {
            new Thread(this::readFromFile).start();
        });
    }

    private void writeToFile(){
        try {
            FileOutputStream fileOutputStream = openFileOutput("borec.txt", MODE_PRIVATE);
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(fileOutputStream);
            outputStreamWriter.write("Benis");
            outputStreamWriter.close();
            fileOutputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void readFromFile(){
        try {
            FileInputStream fileInputStream = openFileInput("borec.txt");
            if(fileInputStream != null){
                InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream);
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                String receiveString = "";
                StringBuilder stringBuilder = new StringBuilder();

                while ( (receiveString = bufferedReader.readLine()) != null ) {
                    stringBuilder.append("\n").append(receiveString);
                }

                fileInputStream.close();
                Message message = mHandler.obtainMessage();
                Bundle bundle = new Bundle();
                bundle.putString("text", stringBuilder.toString());
                message.setData(bundle);
                mHandler.sendMessage(message);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}