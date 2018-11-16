package com.xiangshike.provinceprovider;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.NetworkOnMainThreadException;
import android.view.View;
import android.widget.Toast;
import android.widget.Toast;

import com.bigkoo.pickerview.builder.OptionsPickerBuilder;
import com.bigkoo.pickerview.listener.OnOptionsSelectListener;
import com.bigkoo.pickerview.view.OptionsPickerView;
import com.google.gson.Gson;
import com.xiangshike.provinceprovider.bean.JsonBean;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ProvinceProviderPlugin */
public class ProvinceProviderPlugin implements MethodCallHandler {
    Registrar registrar;
    MethodChannel channel;
    interface  CallBackImp{
        void  back();
    }
    CallBackImp backImp;
    private static final int MSG_LOAD_DATA = 0x0001;
    private static final int MSG_LOAD_SUCCESS = 0x0002;
    private static final int MSG_LOAD_FAILED = 0x0003;

    private static final String CHANNEL = "province_provider";
    private ArrayList<JsonBean> options1Items = new ArrayList<>();
    private ArrayList<ArrayList<String>> options2Items = new ArrayList<>();
    private ArrayList<ArrayList<ArrayList<String>>> options3Items = new ArrayList<>();
    private Thread thread;

    public ProvinceProviderPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
        Toast.makeText(registrar.activeContext(), "Plugin", Toast.LENGTH_LONG).show();
    }
    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_LOAD_DATA:
                    if (thread == null) {//如果已创建就不再重新创建子线程了

//                        Toast.makeText(ProvinceProviderPlugin.this.registrar.context(), "Begin Parse Data", Toast.LENGTH_SHORT).show();
                        thread = new Thread(new Runnable() {
                            @Override
                            public void run() {
                                // 子线程中解析省市区数据
                                initJsonData();
                            }
                        });
                        thread.start();
                    }
                    break;

                case MSG_LOAD_SUCCESS:
//                    Toast.makeText(JsonDataActivity.this, "Parse Succeed", Toast.LENGTH_SHORT).show();

                    ProvinceProviderPlugin.this.backImp.back();
                    break;

                case MSG_LOAD_FAILED:
//                    Toast.makeText(MainActivity.this, "Parse Failed", Toast.LENGTH_SHORT).show();
                    break;
            }
        }
    };


public  void  showProvinceProvider(MethodCall call, Result result) {
    picker(call, result);
}
    /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "province_provider");
    channel.setMethodCallHandler(new ProvinceProviderPlugin(registrar, channel));
  }
    private void initJsonData() {//解析数据

        /**
         * 注意：assets 目录下的Json文件仅供参考，实际使用可自行替换文件
         * 关键逻辑在于循环体
         *
         * */
        String JsonData = new GetJsonDataUtil().getJson(this.registrar.activeContext(), "province.json");//获取assets目录下的json文件数据

        ArrayList<JsonBean> jsonBean = parseData(JsonData);//用Gson 转成实体

        /**
         * 添加省份数据
         *
         * 注意：如果是添加的JavaBean实体，则实体类需要实现 IPickerViewData 接口，
         * PickerView会通过getPickerViewText方法获取字符串显示出来。
         */
        options1Items = jsonBean;

        for (int i = 0; i < jsonBean.size(); i++) {//遍历省份
            ArrayList<String> CityList = new ArrayList<>();//该省的城市列表（第二级）
            ArrayList<ArrayList<String>> Province_AreaList = new ArrayList<>();//该省的所有地区列表（第三极）

            for (int c = 0; c < jsonBean.get(i).getCityList().size(); c++) {//遍历该省份的所有城市
                String CityName = jsonBean.get(i).getCityList().get(c).getName();
                CityList.add(CityName);//添加城市
                ArrayList<String> City_AreaList = new ArrayList<>();//该城市的所有地区列表

                //如果无地区数据，建议添加空字符串，防止数据为null 导致三个选项长度不匹配造成崩溃
                if (jsonBean.get(i).getCityList().get(c).getArea() == null
                        || jsonBean.get(i).getCityList().get(c).getArea().size() == 0) {
                    City_AreaList.add("");
                } else {
                    City_AreaList.addAll(jsonBean.get(i).getCityList().get(c).getArea());
                }
                Province_AreaList.add(City_AreaList);//添加该省所有地区数据
            }

            /**
             * 添加城市数据
             */
            options2Items.add(CityList);

            /**
             * 添加地区数据
             */
            options3Items.add(Province_AreaList);
        }

        mHandler.sendEmptyMessage(MSG_LOAD_SUCCESS);

    }


    public ArrayList<JsonBean> parseData(String result) {//Gson 解析
        ArrayList<JsonBean> detail = new ArrayList<>();
        try {
            JSONArray data = new JSONArray(result);
            Gson gson = new Gson();
            for (int i = 0; i < data.length(); i++) {
                JsonBean entity = gson.fromJson(data.optJSONObject(i).toString(), JsonBean.class);
                detail.add(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
            mHandler.sendEmptyMessage(MSG_LOAD_FAILED);
        }
        return detail;
    }


    protected  void  picker(final MethodCall call, Result result) {
        this.backImp = new CallBackImp() {
            @Override
            public void back() {
                OptionsPickerView p =  new  OptionsPickerBuilder(ProvinceProviderPlugin.this.registrar.activeContext(), new OnOptionsSelectListener() {
                    @Override
                    public void onOptionsSelect(int options1, int options2, int options3, View v) {
                        Map<String, String> value = new HashMap<>();
                        value.put("province", ((JsonBean)options1Items.get(options1)).getName());
                        value.put("city", options2Items.get(options1).get(options2));
                        value.put("school", options3Items.get(options1).get(options2).get(options3));
                        Map<String, Object> result = new HashMap<>();
                        result.put("type","province");
                        result.put("value", value);
                        ProvinceProviderPlugin.this.channel.invokeMethod("provinceResult", result, new Result() {
                            @Override
                            public void success(Object o) {
                                Toast.makeText(ProvinceProviderPlugin.this.registrar.activeContext(), ""+o, Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void error(String s, String s1, Object o) {
                                Toast.makeText(ProvinceProviderPlugin.this.registrar.activeContext(), s+s1+o, Toast.LENGTH_SHORT).show();

                            }

                            @Override
                            public void notImplemented() {
                                Toast.makeText(ProvinceProviderPlugin.this.registrar.activeContext(), "notImp", Toast.LENGTH_SHORT).show();

                            }
                        });
                    }
                }).build();
                p.setPicker(options1Items, options2Items, options3Items);
                String title = (String) call.arguments;
                p.setTitleText(title);
                p.show();

            }
        };

        thread = new Thread(new Runnable() {
            @Override
            public void run() {
                // 子线程中解析省市区数据
                initJsonData();
            }
        });
        thread.start();


    }

     @Override
  public void onMethodCall(MethodCall call, Result result) {
            showProvinceProvider(call,result);
  }
}
