package cz.tul.ucitelenti;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

public class ShowUcitelInfoActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_ucitel_info);
        Intent intent = getIntent();
        String value = intent.getStringExtra("ucitelInfo");
        TextView textView = (TextView) findViewById(R.id.textView);
        textView.setText(value);
    }
}