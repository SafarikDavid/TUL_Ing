package cz.tul.touchme1;

import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;

public class MyTouchListener implements View.OnTouchListener {

    public MainActivity mainActivity;
    public MyTouchListener(MainActivity someMainActivity){
        mainActivity = someMainActivity;
    }

    private long startTime=0;//
    private long endTime=0;//

    private float dX,dY;

    @Override
    public boolean onTouch(View view, MotionEvent motionEvent) {
        Log.v("MyTouchListener","was touched");

        switch(motionEvent.getAction()){
            case MotionEvent.ACTION_DOWN:
                //record the start time
                startTime = motionEvent.getEventTime();
                dX = view.getX() - motionEvent.getRawX();
                dY = view.getY() - motionEvent.getRawY();

                Toast.makeText(mainActivity.getBaseContext(),"Kdyz mne podrzis, uvolnim se. ",Toast.LENGTH_SHORT).show();

                break;
                case MotionEvent.ACTION_UP:
                Toast.makeText(mainActivity.getBaseContext(),"Uz mne nikdo nedrzi. ",Toast.LENGTH_SHORT).show();
                 if(MainActivity.pohyblivy) {
                     MainActivity.pohyblivy = false;

                 }else{

                     //mainActivity.removeIcon();
                     mainActivity.premistiIkonkuNahodne();
                     /*try {

                         Thread.sleep(3000);


                     }catch (Exception ex){

                     }*/
                 }
                break;

                case MotionEvent.ACTION_MOVE:
                    if(MainActivity.pohyblivy) {
                        float X = motionEvent.getRawX() + dX;
                        float Y = motionEvent.getRawY() + dY;
                        mainActivity.premistiIkonku(X, Y,0);
                        //view.setX(X);
                        //view.setY(Y);
                    }
                            //update text v TextView
                        //    updateImageTextView(tempX, tempY, ikonka_width, ikonka_height);
                   //     }

        }
        return false;
    }
}
