package cz.tul.ucitelenti;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    private String TAG = MainActivity.class.getSimpleName();
    public static ArrayList<Ucitel> ucitele;
    private ListView lvSeznam;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.lvSeznam = (ListView) findViewById(R.id.lvSeznam);

        if(ucitele != null){
            this.refreshList();
        }

    }

    public void reloadNTI(View view){
        ucitele = new ArrayList<>();
        new NtiListReceiver(MainActivity.this).execute();//volani asynchronni metody
    }
    public void refreshList(){

        CustomAdapter myAdapter = new CustomAdapter(MainActivity.this, ucitele);
        this.lvSeznam.setAdapter(myAdapter);
        this.lvSeznam.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Ucitel kliknuto = (Ucitel) parent.getItemAtPosition(position);

                Log.v(TAG,"id je " + kliknuto.getUcitIdno());
                /* TODO
                *   Vytvorit Intent
                * dat mu info o uciteli, ktereho budeme chtit zobrazit v detailu
                * start aktivity se zamerem */
                Intent myIntent = new Intent(MainActivity.this, ShowUcitelInfoActivity.class);
                myIntent.putExtra("ucitelInfo", kliknuto.toString());
                MainActivity.this.startActivity(myIntent);
            }
        });
    }




    /*public void showDetail(View view){

    }*/
}