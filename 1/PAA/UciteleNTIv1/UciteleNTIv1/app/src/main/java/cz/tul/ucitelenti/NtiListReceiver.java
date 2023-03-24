package cz.tul.ucitelenti;

import android.os.AsyncTask;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class NtiListReceiver extends AsyncTask {
    private MainActivity mainActivity;
    private String TAG = NtiListReceiver.class.getSimpleName();
    //private ProgressDialog progressDialog = new ProgressDialog(mainActivity);
    private static String adresa = "https://stag-ws.tul.cz/ws/services/rest2/ucitel/getUciteleKatedry?outputFormat=JSON&katedra=NTI";


    public NtiListReceiver(MainActivity activity){
        this.mainActivity = activity;
    }


    @Override
    protected void onPreExecute() {
        super.onPreExecute();
       // progressDialog.setMessage("Downloading...");
       // progressDialog.show();

    }

    @Override
    protected void onPostExecute(Object o) {
        super.onPostExecute(o);
        mainActivity.refreshList();
    }

    @Override
    protected Object doInBackground(Object[] objects) {
        HttpHandler sh = new HttpHandler();
        String jsonStr = sh.makeServiceCall(adresa);
        if (jsonStr != null) {
            Log.v(TAG, "I have json from server.");
            Log.v(TAG, jsonStr);
            try{
                JSONObject data = new JSONObject(jsonStr);
                //JSONArray data = new JSONArray(jsonStr);
                //Log.v(TAG,data.toString());
                JSONArray ucitele = data.getJSONArray("ucitel");
                //HashMap<Integer, Ucitel> pole = new HashMap<>();
                //Ucitel[] obj = new Ucitel[1000];
                for(int i = 0; i<ucitele.length(); i++){
                    JSONObject ucitel = ucitele.getJSONObject(i);

                    Ucitel kantor = new Ucitel(ucitel);
                    MainActivity.ucitele.add(kantor);
                    Log.v(TAG,kantor.toString());
                }


            }catch (final JSONException e){
                Log.e(TAG, "Json parsing error: " + e.getMessage());
            }
        }else{
            Log.e(TAG, "Couldn't get json from server.");
        }
        return null;
    }


}
