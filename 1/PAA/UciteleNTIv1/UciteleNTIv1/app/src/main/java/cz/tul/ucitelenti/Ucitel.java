package cz.tul.ucitelenti;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

public class Ucitel extends Object{
    public String jmeno, prijmeni;
    public int ucitIdno;
    private String TAG = Ucitel.class.getSimpleName();
    public Ucitel(JSONObject object) {
        try {
            this.jmeno = object.getString("jmeno");
            this.prijmeni = object.getString("prijmeni");
            this.ucitIdno = object.getInt("ucitIdno");
        }catch(final JSONException e){
            Log.e(TAG, "Json parsing error: " + e.getMessage());
        }

    }

    @Override
    public String toString() {
        return "Ucitel{" +
                "jmeno='" + jmeno + '\'' +
                ", prijmeni='" + prijmeni + '\'' +
                ", ucitIdno=" + ucitIdno +
                '}';
    }

    public int getUcitIdno(){
        return this.ucitIdno;
    }
}
