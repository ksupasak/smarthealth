package rd.naiflutter;

// NAiFlutter
// Copyright R&D Computer System Co., Ltd.

import android.annotation.SuppressLint;

import android.content.res.AssetManager;

import android.os.Build;
import android.os.Bundle;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.util.ArrayList;

import java.util.Base64;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import rd.nalib.ExceptionNA;
import rd.nalib.NA;
import rd.nalib.ResponseListener;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "flutter.native/helper";
    private static final int NA_NO_ATEXT = 0x0;
    private static final int NA_ATEXT = 0x1;

    public NA NALibs;

    private int iRes = -999;
    private ArrayList<String> aRes = null;
    private String sRes = "";
    private byte[] byteRes = null;
    private boolean bReturnResponseFinish = false;
    private int sleepTime = 10; // = 10 ms

    private MyHandler mHandler;
    private HandlerThread myThread;
    private Handler handler;

    MethodChannel.Result Global_result;

    private int pms;

    private String Parameter_OpenLib;

    private String str_result;

    private int listOption;
    private String readerSelect;

    ResponseListener responseListener = new ResponseListener() {

        @Override
        public void onOpenLibNA(int i) {

            iRes = i;
            bReturnResponseFinish = true;
        }

        @Override
        public void onGetReaderListNA(ArrayList<String> arrayList, int i) {
            iRes = i;
            aRes = arrayList;
            bReturnResponseFinish = true;
        }

        @Override
        public void onSelectReaderNA(int i) {
            iRes = i;
            bReturnResponseFinish = true;
        }

        @Override
        public void onGetNIDNumberNA(String s, int i) {
            iRes = i;
            sRes = s;
            bReturnResponseFinish = true;
        }

        @Override
        public void onGetNIDTextNA(String s, int i) {

            iRes = i;
            sRes = s;
            bReturnResponseFinish = true;

        }

        @Override
        public void onGetNIDPhotoNA(byte[] bytes, int i) {
            iRes = i;
            byteRes = bytes;
            bReturnResponseFinish = true;
        }

        @Override
        public void onUpdateLicenseFileNA(int i) {
            iRes = i;
            bReturnResponseFinish = true;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        NALibs = new NA(MainActivity.this);

        myThread = new HandlerThread("Worker Thread");
        myThread.start();
        Looper mLooper = myThread.getLooper();
        mHandler = new MyHandler(mLooper);

        handler = new Handler();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @RequiresApi(api = Build.VERSION_CODES.O)
                    @SuppressLint("WrongThread")
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        Global_result = result;

                        
                        if (call.method.equals("getFilesDirMC")) {

                            String res = String.valueOf( getFilesDir() );
                            Global_result.success(res);
                        }

                        if (call.method.equals("writeLicFileMC")) {

                            String LicFile = (String) call.arguments;

                            int res = writeLicFile(LicFile);
                            Global_result.success(res);
                        }


                        if (call.method.equals("setListenerMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "setlistener";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("setPermissionsMC")) {

                            pms = (int) call.arguments;

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "setpermissions";
                            mHandler.sendMessage(msg);
                            
                        }



                        if (call.method.equals("openLibMC")) {

                            Parameter_OpenLib = (String) call.arguments;

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "openlib";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getReaderListMC")) {

                            listOption = (int) call.arguments;

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getreaderlist";
                            mHandler.sendMessage(msg);

                        }




                        if (call.method.equals("selectReaderMC")) {

                            readerSelect = (String) call.arguments;

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "selectreader";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getReaderInfoMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getreaderinfo";
                            mHandler.sendMessage(msg);

                        }




                        if (call.method.equals("getReaderIDMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getreaderid";
                            mHandler.sendMessage(msg);
                        }




                        if (call.method.equals("connectCardMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "connectcard";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("disconnectCardMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "disconnectcard";
                            mHandler.sendMessage(msg);

                        }




                        if (call.method.equals("getTextMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "gettext";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getPhotoMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getphoto";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getNIDNumberMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getnidnumber";
                            mHandler.sendMessage(msg);

                        }



                    
                        if (call.method.equals("updateLicenseFileMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "updatelicensefile";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getLicenseInfoMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getlicenseinfo";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getSoftwareInfoMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getsoftwareinfo";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("getCardStatusMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "getcardstatus";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("deselectReaderMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "deselectreader";
                            mHandler.sendMessage(msg);

                        }



                        if (call.method.equals("closeLibMC")) {

                            Message msg = mHandler.obtainMessage();
                            msg.obj = "closelib";
                            mHandler.sendMessage(msg);

                        }
                        


                    }
                });
    }



    // ============================================= Multithreading Function ================================================ //

    class MyHandler extends Handler {

        MyHandler(Looper myLooper) {
            super(myLooper);
        }

        @RequiresApi(api = Build.VERSION_CODES.O)
        public void handleMessage(Message msg) {
            String message = (String) msg.obj;
            switch (message) {

                case "setlistener": {

                    /* ================= Set Listener ================= */
                    NALibs.setListenerNA(responseListener);

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(ExceptionNA.NA_SUCCESS); }
                    });

                    break;
                }

                case "setpermissions": {

                    /* ================= Set Permission ================= */
                    int res = NALibs.setPermissionsNA(pms);

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(res); } 
                    });

                    break;
                }

                case "openlib": {

                    /* ================= Open Lib ================= */
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.openLibNA(Parameter_OpenLib);
                    waitResponse();

                    handler.post(new Runnable() {
                            @Override
                            public void run() { Global_result.success(iRes); }
                        });
                    break;
                    
                }

                case "getreaderlist": {

                    /* ================= Get Reader List ================= */
                   bReturnResponseFinish = false;
                   clearReturnResponse();

                   NALibs.getReaderListNA(listOption);

                   waitResponse();

                    str_result = iRes + ";" ;

                   if (iRes > 0) {
                       str_result = iRes + ";" + aRes.get(0);
                   }

                   handler.post(new Runnable() {
                       @Override
                       public void run() { Global_result.success(str_result); }
                   });

                   break;

                }

                case "selectreader": {

                    /* ================= Select Reader ================= */
                    clearReturnResponse();
                    bReturnResponseFinish = false;
                    try{
                        NALibs.selectReaderNA(readerSelect);
                    }catch(Exception e){
                        handler.post(new Runnable() {
                            @Override
                            public void run() { Global_result.success(-11); }
                        });
                        break;
                    }
                    waitResponse();


                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(iRes); }
                    });
                    
                    break;
                }

                case "getreaderinfo": {

                    /* ================= Get Reader Info ================= */
                    String[] data = new String[1];

                    NALibs.getReaderInfoNA(data);

                    if (data[0] != null) {
                        str_result = ExceptionNA.NA_SUCCESS + ";"+ data[0] ;
                    }else{
                        str_result = ExceptionNA.NA_READER_NOT_FOUND + ";" ;
                    }

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(str_result); }
                    });

                    break;
                }

                case "getreaderid": {

                    /* ================= Get Reader ID ================= */
                    final byte[] Rid = new byte[256];
                    int result = NALibs.getRidNA(Rid);
                   
                    String encoded = Base64.getEncoder().encodeToString(Rid);

                    if (result > 0) {

                       str_result = result + ";" + encoded;

                    } else {
                        str_result = result + ";";
                    }
                    
                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success( str_result); }
                    });

                    break;
                }



                case "connectcard": {

                     /* ================= Connect Card ================= */
                     int res = NALibs.connectCardNA();

                     handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(res); }
                     });

                    break;
                }

                case "disconnectcard": {

                    /* ================= Disconnect Card ================= */
                    int res = NALibs.disconnectCardNA();

                    handler.post(new Runnable() {
                        @Override
                            public void run() { Global_result.success(res); }
                    });

                   
                   break;
               }

                case "gettext": {

                    /* ================= Get NID Text ================= */
                    bReturnResponseFinish = false;
                    clearReturnResponse();

                    int getTextOption = NA_NO_ATEXT;
                    //int getTextOption = NA_ATEXT;
                    NALibs.getNIDTextNA(getTextOption);

                    waitResponse();

                    str_result = iRes + ";"+ sRes ;

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(str_result); }
                    });

                    break;
                }

                case "getphoto": {

                    /* ================= Get NID Photo ================= */
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.getNIDPhotoNA();

                    waitResponse();

                    str_result = iRes + ";" ;

                    if (iRes == ExceptionNA.NA_SUCCESS) {

                        String encoded = Base64.getEncoder().encodeToString(byteRes);

                        str_result = iRes + ";"+ encoded;

                    } 

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(str_result); }
                    });

                    break;

                }

                case "getnidnumber": {

                    /* ================= Get NID Number ================= */
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.getNIDNumberNA();

                    waitResponse();

                    str_result = iRes + ";"+ sRes ;

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(str_result); }
                    });

                    break;
                }

                case "updatelicensefile": {

                    /* ================= Update License File ================= */
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.updateLicenseFileNA();
                    waitResponse();

                    /* ================= Retry Update ================= */
                    if (iRes == ExceptionNA.NA_LICENSE_UPDATE_ERROR) {
                        bReturnResponseFinish = false;
                        clearReturnResponse();
                        NALibs.updateLicenseFileNA();
                        waitResponse();
                    }

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(iRes); }
                    });

                    break;
                }

                case "getlicenseinfo": {

                    /* ================= Get License Info ================= */
                    String[] data = new String[1];
                    NALibs.getLicenseInfoNA(data);
                    if (data[0] != null) {
                        handler.post(new Runnable() {
                            @Override
                            public void run() { Global_result.success(data[0]); }
                        });

                    }
                    break;
                }

                case "getsoftwareinfo": {

                    /* ================= Get Software Info ================= */
                    String[] data = new String[1];

                    NALibs.getSoftwareInfoNA(data);
                    
                    if (data[0] != null) {
                        handler.post(new Runnable() {
                            @Override
                            public void run() { Global_result.success(data[0]); }
                        });
                    }

                    break;

                }

                case "getcardstatus": {

                    /* ================= Get Card Status ================= */
                    int Result = NALibs.getCardStatusNA();

                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(Result); }
                    });

                    break;

                }

                case "deselectreader": {

                    /* ================= Deselect Reader ================= */
                    int Result = NALibs.deselectReaderNA();
                    
                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(Result); }
                    });

                    break;

                }

                case "closelib": {

                    /*================= Close Lib =================*/
                    int Result = NALibs.closeLibNA();
                    
                    handler.post(new Runnable() {
                        @Override
                        public void run() { Global_result.success(Result); }
                    });

                    break;

                }

            }
        }
    }
    // ====================================================================================================================== //



    public int writeLicFile(String Path) {

        AssetManager assetManager = getAssets();
        try {

            InputStream is = assetManager.open("rdnidlib.dls");

            File out = new File(Path);
            if (out.exists()) { //check already has License File
                return 1;
            }

            String writeLicPath = out.getParent();

            File parent = new File(writeLicPath);
            parent.mkdirs();
            byte[] buffer = new byte[1024];
            FileOutputStream fos = new FileOutputStream(out);
            int read;

            while ((read = is.read(buffer, 0, 1024)) >= 0) {
                fos.write(buffer, 0, read);
            }

            fos.flush();
            fos.close();
            is.close();

            return 0;

        } catch (IOException e) {
            e.printStackTrace();
            return -1;

        }
    }

    public void waitResponse() {
        while (!bReturnResponseFinish) {
            try {
                Thread.sleep(sleepTime);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public void clearReturnResponse() {
        iRes = -999;
        sRes = "";
        aRes = null;
        byteRes = null;
    }

}
