package com.example.cv4;

import android.view.MotionEvent;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

public class MyTouchListener implements View.OnTouchListener {
    public MainActivity mainActivity;
    private ImageButton imgButton;

    public MyTouchListener(MainActivity someActivity, ImageButton imgButton){
        mainActivity = someActivity;
        this.imgButton = imgButton;
    }

    @Override
    public boolean onTouch(View view, MotionEvent motionEvent) {
        Log.v("my listener", "is pressed");

        switch (motionEvent.getAction()){
            case MotionEvent.ACTION_DOWN:
                Toast.makeText(mainActivity.getBaseContext(), "I'm being oppressed.", Toast.LENGTH_SHORT).show();
                break;
            case MotionEvent.ACTION_UP:
                Toast.makeText(mainActivity.getBaseContext(), "I'm free once again.", Toast.LENGTH_SHORT).show();
                mainActivity.moveImageButton(imgButton);
                break;
        }

        return false;
    }
}
