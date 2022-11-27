package com.example.cv4;

//Touch me

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.media.Image;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;

public class MainActivity extends AppCompatActivity {
    private ConstraintLayout window;
    private int windowWidth;
    private int windowHeight;


    //udelat aby pri pusteni tlacitka ho dal pryc
    //udelat ze muzu tahat to tlacitko kdyz ho drzim
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        window = (ConstraintLayout) findViewById(R.id.mainWindow);
        updateSizeInfo();

        ImageButton button2 = (ImageButton) findViewById(R.id.imageButton2);
        MyTouchListener myListener = new MyTouchListener(this, (ImageButton) findViewById(R.id.imageButton2));
        button2.setOnTouchListener(myListener);
//        button2.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View view, MotionEvent motionEvent) {
//                Log.v("button2", "pressed");
//                return false;
//            }
//        });
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        updateSizeInfo();
        moveImageButton((ImageButton) findViewById(R.id.imageButtonBanana));
    }

//    pri otoceni zarizeni umistit ikonku nahodne na plochu, ale aby byla cela videt
//    pripadne i udelat jinak velikou ikonku => musi se cela vejit do veci
    public void moveImageButton(ImageButton imgButton) {
        Random rand = new Random();

        int upperbound = windowWidth/2;
        int lowerbound = windowWidth/8;
        int randButtonWidth = rand.nextInt(upperbound-lowerbound) + lowerbound;
        upperbound = windowHeight/2;
        lowerbound = windowHeight/8;
        int randButtonHeight = rand.nextInt(upperbound-lowerbound) + lowerbound;
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(randButtonWidth, randButtonHeight);
        imgButton.setLayoutParams(lp);

        int widthButton = imgButton.getLayoutParams().width;
        int heightButton = imgButton.getLayoutParams().height;

        //zmena velikosti
        int maxRangeRandWidth = windowWidth - widthButton;
        int maxRangeRandHeight = windowHeight - heightButton;

        int xParam = rand.nextInt(maxRangeRandWidth);
        int yParam = rand.nextInt(maxRangeRandHeight);

        imgButton.setX(xParam);
        imgButton.setY(yParam);
    }

    private void updateSizeInfo() {
        windowWidth = window.getWidth();
        windowHeight = window.getHeight();
        String resText = "Resolution: " + windowWidth + " x " + windowHeight;
        Toast.makeText(this, resText, Toast.LENGTH_LONG).show();
        //Rozliseni napisu v TextView
        TextView textResolution = (TextView) findViewById(R.id.textViewResolution);
        textResolution.setText(resText);
    }
}