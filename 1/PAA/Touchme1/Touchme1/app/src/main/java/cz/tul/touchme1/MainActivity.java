package cz.tul.touchme1;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private int width, height;
    public static boolean pohyblivy = false;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        MyTouchListener touchListener = new MyTouchListener(this);
        ImageButton ikonka = (ImageButton) findViewById(R.id.imageButton);
        ikonka.setOnTouchListener(touchListener);
        ikonka.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {
                Toast.makeText(MainActivity.this.getBaseContext(),"Jsem volna, hybej se mnou. ",Toast.LENGTH_SHORT).show();
                MainActivity.pohyblivy = true;
                return false;
            }
        });
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        updateSizeInfo();
        premistiIkonkuNahodne();
    }

    private void updateSizeInfo() {
        ConstraintLayout myWindow = (ConstraintLayout) findViewById(R.id.MainWindow);
        TextView textView = (TextView) findViewById(R.id.textView);
        width = myWindow.getWidth();
        height = myWindow.getHeight();
        textView.setText("Rozliseni " + width + " x " + height + "px");

    }
    public void premistiIkonku(float x, float y, int size){
        ImageButton ikonka = (ImageButton) findViewById(R.id.imageButton);
        TextView kamslo = (TextView) findViewById(R.id.textView2);
        if(size > 0){
            ikonka.getLayoutParams().height = size;
            ikonka.getLayoutParams().width = size;
            ikonka.requestLayout();
        }
        ikonka.setX(x);
        ikonka.setY(y);
        int ikonka_width = ikonka.getWidth();
        int ikonka_height = ikonka.getHeight();
        String kamsloString = "x,y: " + Math.ceil(x) + "," + Math.ceil(y)
                + " w,h: " + Integer.toString(ikonka_width) + "," + Integer.toString(ikonka_height);
        kamslo.setText(kamsloString);
    }
    public void premistiIkonkuNahodne(){
        Random rand = new Random();

        int size = rand.nextInt(50) + 50;//zhruba mezi 50 a 100
        int x = rand.nextInt(width - 100);
        int y = rand.nextInt(height - 100);
        premistiIkonku(x,y,size);


    }
    public void removeIcon() {
        ImageButton ikonka = (ImageButton) findViewById(R.id.imageButton);
        ikonka.setY(height+100);
    }



}