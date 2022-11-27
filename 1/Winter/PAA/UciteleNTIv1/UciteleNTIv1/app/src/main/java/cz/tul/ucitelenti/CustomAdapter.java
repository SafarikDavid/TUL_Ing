package cz.tul.ucitelenti;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

public class CustomAdapter extends BaseAdapter {
    ArrayList<Ucitel> ucitele = new ArrayList<>();
    Context context;
    public CustomAdapter(Context context, ArrayList<Ucitel> ucitele) {
        this.context = context;
        this.ucitele = ucitele;
    }

    @Override
    public int getCount() {
        return this.ucitele.size();
    }

    @Override
    public Object getItem(int i) {
        return this.ucitele.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        if(view == null){
            view = LayoutInflater.from(this.context).inflate(R.layout.list_item,viewGroup,false);
        }
        Ucitel pomUcitel = (Ucitel) this.getItem(i);
        TextView tvJmeno = (TextView) view.findViewById(R.id.jmeno);
        TextView tvPrijmeni = (TextView) view.findViewById(R.id.prijmeni);

        tvJmeno.setText(pomUcitel.jmeno);
        tvPrijmeni.setText(pomUcitel.prijmeni);
        return view;
    }




}
