package com.example.smart_health;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;

import rd.nalib.ExceptionNA;
import rd.nalib.NA;
import rd.nalib.ResponseListener;

public class CardReader {

    CardReaderCallback callback;

    public static final int MY_STORAGE_PERMISSION = 0x1;
    public static final int MY_LOCATION_PERMISSION = 0x2;
    public static final int REQUEST_ALL_FILE_PERMISSION = 0x3;
    public static final int REQUEST_STORAGE_PERMISSION = 0x4;
    private final int sleepTime = 10;     // = 10 ms
    private final int NA_POPUP = 0x80;
    private final int NA_FIRST = 0x40;
    private final int NA_RESERVE2 = 0x20;
    private final int NA_SCAN = 0x10;
    private final int NA_BLE1 = 0x08;
    private final int NA_BLE0 = 0x04;
    private final int NA_BT = 0x02;
    private final int NA_USB = 0x01;

    private final int NA_NO_ATEXT = 0x00;
    private final int NA_ATEXT = 0x01;

    private String NAVersion;
    private byte[] byteRes = null;
    private boolean bReturnResponseFinish = false;
    private NA NALibs;
    private Button bt_SelectReader, bt_Read, bt_UpdateLicense, bt_Exit;
    private TextView tv_Reader, tv_Result, tv_SoftwareInfo, tv_LicenseInfo;
    private ImageView iv_Photo;
    private MyHandler mHandler;
    private final Handler handler = new Handler();
    private int iRes = -999;
    private ArrayList<String> aRes = null;
    private String sRes = "";

    protected Activity activity;

    protected boolean connect = false;

    public CardReader(Activity activity){

        this.activity = activity;

        HandlerThread myThread = new HandlerThread("Worker Thread");
        myThread.start();
        Looper mLooper = myThread.getLooper();
        mHandler = new MyHandler(mLooper);


//        ProgressDialog progressDialog = new ProgressDialog(this.activity);
//        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
//        progressDialog.setMessage("Scan bluetooth");


//        NALibs = new NA(this.activity);
        NALibs = new NA(this.activity);


        /*================= get Software Info =================*/
        clearReturnResponse();
        String[] data = new String[1];
        NALibs.getSoftwareInfoNA(data);
        if (data[0] != null) {
//            tv_SoftwareInfo.setText("Software Info: " + data[0]);
            setText(tv_SoftwareInfo, "Software Info: " + data[0]);
        }

        NALibs.setListenerNA(responseListener);

////        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
////            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT}, MY_LOCATION_PERMISSION);
////        } else {
////            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) != PERMISSION_GRANTED) {
////                AlertDialog dialog = new AlertDialog.Builder(MainActivity.this).create();
////                dialog.setTitle("Permission");
////                dialog.setMessage("Please allow Location permission if use Bluetooth reader.");
////                dialog.setCancelable(false);
////                dialog.setCanceledOnTouchOutside(false);
////                dialog.setButton(androidx.appcompat.app.AlertDialog.BUTTON_POSITIVE, "Close", new DialogInterface.OnClickListener() {
////                    public void onClick(DialogInterface dialog, int which) {
////                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, MY_LOCATION_PERMISSION);
////                        dialog.dismiss();
////                    }
////                });
////                dialog.show();
////                dialog.getButton(AlertDialog.BUTTON_POSITIVE).setAllCaps(false);
////
////            } else {
////                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, MY_LOCATION_PERMISSION);
////            }
////            init();
////        }
//
        init();

    }

    void setCallback(CardReaderCallback callback){
        this.callback = callback;
    }

    public void init() {
        /*** set USB reader in-app permission ***/
        /***
         pms: 0 = Disable USB reader in-app permission (default).
         pms: 1 = Enable USB reader in-app permission.
         pms: -1 = Get current permissions state.
         ***/

        int pms = 1;
        NALibs.setPermissionsNA(pms);

        clearReturnResponse();

        String mNIDReader = "/" + "NASample";
        String rootFolder = activity.getFilesDir() + mNIDReader;
        String LICFileName = "/" + "rdnidlib.dls";
        writeFile(rootFolder + LICFileName, "rdnidlib.dls");                         // Write file Licence

        /*===================== Open Libs =====================*/
        NALibs.openLibNA(rootFolder + LICFileName);

        if (iRes != 0) {
            tv_Result.setClickable(false);
            tv_Result.setText("Open Lib failed; Please restart app");
            bt_SelectReader.setEnabled(false);
            bt_Read.setEnabled(false);
            bt_UpdateLicense.setEnabled(false);
            bt_Exit.setEnabled(true);
            return;
        }

        /*================= get License Info =================*/
        clearReturnResponse();
        String[] data = new String[1];
        NALibs.getLicenseInfoNA(data);
        if (data[0] != null) {
//            tv_LicenseInfo.setText("License Info: " + data[0]);
        }
//        tv_Result.setText("");
//        bt_SelectReader.setEnabled(true);
//        bt_Read.setEnabled(true);
//        bt_UpdateLicense.setEnabled(true);
//        bt_Exit.setEnabled(true);
    }

    void findReader(){
        Message msg = mHandler.obtainMessage();
        msg.obj = "findreader";
        mHandler.sendMessage(msg);
    }

    void read(){

        if(connect==false){
            findReader();
        }else{
            Message msg = mHandler.obtainMessage();
            msg.obj = "read";
            mHandler.sendMessage(msg);
        }

    }

    void stop(){
        /*================= Deselect Reader =================*/
        NALibs.deselectReaderNA();

        /*================= Close Lib =================*/
        NALibs.closeLibNA();
    }

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
        public void onSelectReaderNA(final int i) {
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
        public void onGetNIDTextNA(final String s, int i) {
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

    public void setText(TextView tv, final String message) {
        System.out.println("READER================");
        System.out.println(message);
//        tv_Result.setClickable(false);
//        final TextView textView = tv;
//        handler.post(() -> textView.setText(message));
    }
    public void clearReturnResponse() {
        iRes = -999;
        sRes = "";
        aRes = null;
        byteRes = null;
    }

    public void setEnableButton(final boolean SelectReader, final boolean Read, final boolean UpdateLicense, final boolean Exit) {
        handler.post(() -> {
//            bt_SelectReader.setEnabled(SelectReader);
//            bt_Read.setEnabled(Read);
//            bt_UpdateLicense.setEnabled(UpdateLicense);
//            bt_Exit.setEnabled(Exit);
        });
    }

    public void writeFile(String Path, String Filename) {
        AssetManager assetManager = activity.getAssets();
        try {
            InputStream is = assetManager.open(Filename);
            File out = new File(Path);
            if (out.exists())
                return;
            File parent = new File(out.getParent());
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
        } catch (IOException e) {
            e.printStackTrace();
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

    private void printException(int ex, String OldText) {

        if (OldText.compareTo("") != 0) {
            OldText += "\n\n";
        }
        switch (ex) {
            case ExceptionNA.NA_INTERNAL_ERROR:
                setText(tv_Result, OldText + "-1 Internal error.");
                break;

            case ExceptionNA.NA_INVALID_LICENSE:
                setText(tv_Result, OldText + "-2 This reader is not licensed.");
                break;

            case ExceptionNA.NA_READER_NOT_FOUND:
                setText(tv_Result, OldText + "-3 Reader not found.");
                break;

            case ExceptionNA.NA_CONNECTION_ERROR:
                setText(tv_Result, OldText + "-4 Card connection error.");
                break;

            case ExceptionNA.NA_GET_PHOTO_ERROR:
                setText(tv_Result, OldText + "-5 Get photo error.");
                break;

            case ExceptionNA.NA_GET_TEXT_ERROR:
                setText(tv_Result, OldText + "-6 Get text error.");
                break;

            case ExceptionNA.NA_INVALID_CARD:
                setText(tv_Result, OldText + "-7 Invalid card.");
                break;

            case ExceptionNA.NA_UNKNOWN_CARD_VERSION:
                setText(tv_Result, OldText + "-8 Unknown card version.");
                break;

            case ExceptionNA.NA_DISCONNECTION_ERROR:
                setText(tv_Result, OldText + "-9 Disconnection error.");
                break;

            case ExceptionNA.NA_INIT_ERROR:
                setText(tv_Result, OldText + "-10 Init error.");
                break;

            case ExceptionNA.NA_READER_NOT_SUPPORTED:
                setText(tv_Result, OldText + "-11 Reader not supported.");
                break;

            case ExceptionNA.NA_LICENSE_FILE_ERROR:
                setText(tv_Result, OldText + "-12 License file error.");
                break;

            case ExceptionNA.NA_PARAMETER_ERROR:
                setText(tv_Result, OldText + "-13 Parameter error.");
                break;

            case ExceptionNA.NA_INTERNET_ERROR:
                setText(tv_Result, OldText + "-15 Internet error.");
                break;

            case ExceptionNA.NA_CARD_NOT_FOUND:
                setText(tv_Result, OldText + "-16 Card not found.");
                break;

            case ExceptionNA.NA_BLUETOOTH_DISABLED:
                setText(tv_Result, OldText + "-17 Bluetooth is disabled.");
                break;

            case ExceptionNA.NA_LICENSE_UPDATE_ERROR:
                setText(tv_Result, OldText + "-18 License update error.");
                break;

//            case ExceptionNA.NA_STORAGE_PERMISSION_ERROR:
//                setText(tv_Result, OldText + ExceptionNA.NA_STORAGE_PERMISSION_ERROR + " Storage permission error: Settings >");
//                tv_Result.setClickable(true);
//                tv_Result.setOnClickListener(new View.OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                            if (!Environment.isExternalStorageManager()) {
//                                try {
//                                    Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
//                                    intent.addCategory("android.intent.category.DEFAULT");
//                                    intent.setData(Uri.parse(String.format("package:%s", getApplicationContext().getPackageName())));
//                                    startActivityForResult(intent, REQUEST_ALL_FILE_PERMISSION);
//                                } catch (Exception e) {
//                                    Intent intent = new Intent();
//                                    intent.setAction(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
//                                    startActivityForResult(intent, REQUEST_ALL_FILE_PERMISSION);
//                                }
//                            }
//
//                            if (ContextCompat.checkSelfPermission(v.getContext(), Manifest.permission.WRITE_EXTERNAL_STORAGE) != PERMISSION_GRANTED) {
//                                Intent intent = new Intent();
//                                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                                intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
//                                Uri uri = Uri.fromParts("package", getPackageName(), null);
//                                intent.setData(uri);
//                                if (!flagSetting) {
//                                    flagSetting = true;
//                                    startActivityForResult(intent, REQUEST_STORAGE_PERMISSION);
//                                }
//                            }
//                        } else {
//                            Intent intent = new Intent();
//                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
//                            Uri uri = Uri.fromParts("package", getPackageName(), null);
//                            intent.setData(uri);
//                            if (!flagSetting) {
//                                flagSetting = true;
//                                startActivityForResult(intent, REQUEST_STORAGE_PERMISSION);
//                            }
//                        }
//                    }
//                });
//                break;

            case ExceptionNA.NA_LOCATION_PERMISSION_ERROR:
                setText(tv_Result, OldText + ExceptionNA.NA_LOCATION_PERMISSION_ERROR + " Location permission error: Settings >");
//                tv_Result.setClickable(true);
//                tv_Result.setOnClickListener(new View.OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        Intent intent = new Intent();
//                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
//                        Uri uri = Uri.fromParts("package", getPackageName(), null);
//                        intent.setData(uri);
//                        if (!flagSetting) {
//                            flagSetting = true;
//                            startActivity(intent);
//                        }
//                    }
//                });
                break;

            case ExceptionNA.NA_BLUETOOTH_PERMISSION_ERROR:
                setText(tv_Result, OldText + "-33 Bluetooth permission error.");
                break;

            case ExceptionNA.NA_LOCATION_SERVICE_ERROR:
                setText(tv_Result, OldText + "-41 Location service error.");
                break;

            default:
                break;

        }
    }


    class MyHandler extends Handler {
        MyHandler(Looper myLooper) {
            super(myLooper);
        }

        public void handleMessage(Message msg) {
            String message = (String) msg.obj;
            switch (message) {

                /*================= When Click [Find Reader Button]   =================*/
                case "findreader": {
                    int listOption = NA_POPUP + NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT + NA_USB;     //0x9F USB & BLE Reader
                    setEnableButton(false, false, false, false);

                    /*================= get Reader List =================*/
                    bReturnResponseFinish = false;
                    clearReturnResponse();

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        if ((listOption & NA_SCAN) != 0 && ((listOption & NA_BT) != 0 || (listOption & NA_BLE1) != 0 || (listOption & NA_BLE0) != 0)) {
//                            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.BLUETOOTH_SCAN) == PERMISSION_GRANTED &&
//                                    ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED) {
//                                listOption = listOption;
//                            } else {
//                                listOption = listOption - (NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT);  //remove BT Scanning
//                            }
                        }
                    } else {
                        if ((listOption & NA_SCAN) != 0 && ((listOption & NA_BT) != 0 || (listOption & NA_BLE1) != 0 || (listOption & NA_BLE0) != 0)) {
//                            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) == PERMISSION_GRANTED) {
//                                listOption = listOption;
//                            } else {
//                                listOption = listOption - (NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT);  //remove BT Scanning
//                            }
                        }
                    }

                    NALibs.getReaderListNA(listOption);

                    waitResponse();

                    printException(iRes, "");

                    if (iRes == 0) {
                        setEnableButton(true, true, true, true);
                        break;
                    }

                    if (iRes < 0) {
                        setText(tv_Reader, "Reader not found.");
                        setEnableButton(true, true, true, true);
                        break;
                    }

                    String readerSelect = aRes.get(0);

                    /*================= Select Reader =================*/
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    setText(tv_Reader, "Reader Selecting...");
                    NALibs.selectReaderNA(readerSelect);
                    waitResponse();

                    printException(iRes, "");

                    String[] data = new String[1];
                    NALibs.getLicenseInfoNA(data);
                    if (data[0] != null) {
                        setText(tv_LicenseInfo, "License Info: " + data[0]);
                    }

                    setEnableButton(true, true, true, true);
                    if (iRes != ExceptionNA.NA_SUCCESS && iRes != ExceptionNA.NA_INVALID_LICENSE && iRes != ExceptionNA.NA_LICENSE_FILE_ERROR) {
                        setText(tv_Reader, "Reader not found.");
                        break;
                    } else if (iRes == ExceptionNA.NA_INVALID_LICENSE || iRes == ExceptionNA.NA_LICENSE_FILE_ERROR) {
                        setText(tv_Reader, "Reader: " + readerSelect);
                        break;
                    }

                    setText(tv_Reader, "Reader: " + readerSelect);

                    data = new String[1];
                    if (NALibs.getReaderInfoNA(data) == 0) {
                        setText(tv_Result, "getReaderInfoNA: " + data[0]);
                    }
                    connect = true;
                    read();

                    break;
                }

                /*================= When Click [Read Button] =================*/
                case "read": {
                    long startTime = System.currentTimeMillis();
                    setEnableButton(false, false, false, false);
                    setText(tv_Result, "");
//                    handler.post(() -> iv_Photo.setImageResource(R.mipmap.nas));

                    /*================= Connect Card =================*/
                    int result = NALibs.connectCardNA();
                    if (result != ExceptionNA.NA_SUCCESS) {
                        setEnableButton(true, true, true, true);
                        printException(result, "");
                        //setText(tv_Result, "Card connection error.");
                        break;
                    }

                    /*================= Get NID Text =================*/
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    int getTextOption = NA_NO_ATEXT;
                    //int getTextOption = NA_ATEXT;
                    NALibs.getNIDTextNA(getTextOption);

                    waitResponse();
                    printException(iRes, "");

                    if (iRes != ExceptionNA.NA_SUCCESS) {
                        setEnableButton(true, true, true, true);
                        NALibs.disconnectCardNA();
                        break;
                    }

                    setText(tv_Result, sRes);

                    final long difference = System.currentTimeMillis() - startTime;
                    final BigDecimal bd = new BigDecimal(difference / 1000.0);
                    String result_text = ""+sRes;




                    handler.post(() -> {
//                        iv_Photo.setImageResource(R.mipmap.nas);
//                        setText(tv_Result, tv_Result.getText().toString() + "\nRead Text: " + bd.setScale(2, RoundingMode.HALF_UP) + " s");

                        System.out.println("Card Reader : "+bd.setScale(2, RoundingMode.HALF_UP) );


                    });

                    /*================= Get NID Photo =================*/
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.getNIDPhotoNA();

                    waitResponse();

                    printException(iRes, "");
                    if (iRes == 0) {
                        final Bitmap bMap = BitmapFactory.decodeByteArray(byteRes, 0, byteRes.length);

                        callback.receiveResult(result_text, bMap);


//                        handler.post(() -> {
//
//                            if(callback!=null)
//                            callback.receiveResult(result_text, bMap);
//
//                        });

//                        handler.post(() -> iv_Photo.setImageBitmap(bMap));
                    }

                    /*================= Disconnect Card =================*/
                    NALibs.disconnectCardNA();

                    setEnableButton(true, true, true, true);

                    if (iRes >= 0) {
                        final long difference2 = System.currentTimeMillis() - startTime;
                        final BigDecimal bd2 = new BigDecimal(difference2 / 1000.0);
//                        handler.post(() -> setText(tv_Result, tv_Result.getText().toString() + ", Text+Photo: " + bd2.setScale(2, RoundingMode.HALF_UP) + " s"));
                    }
                    break;
                }

                /*================= When Click [Update License Button] =================*/
                case "updatelicense": {
                    setEnableButton(false, false, false, false);

                    /*================= Update License File =================*/
                    bReturnResponseFinish = false;
                    clearReturnResponse();
                    NALibs.updateLicenseFileNA();
                    waitResponse();

                    /*================= Retry Update =================*/
                    if (iRes == ExceptionNA.NA_LICENSE_UPDATE_ERROR) {
                        bReturnResponseFinish = false;
                        clearReturnResponse();
                        NALibs.updateLicenseFileNA();
                        waitResponse();
                    }

                    printException(iRes, "");

                    /*if (iRes == ExceptionNA.NA_SUCCESS) {
                        String[] data = new String[1];
                        NALibs.getLicenseInfoNA(data);
                        if (data[0] != null) {
                            setText(tv_LicenseInfo, "License Info: " + data[0]);
                        }
                        setText(tv_Result, iRes + ": License has been successfully updated.");
                    } else if (iRes == 1) {
                        setText(tv_Result, iRes + ": The latest license has already been installed.");
                    }*/

                    if (iRes == 0 || iRes == 1 || iRes == 2 || iRes == 3) {
                        String[] data = new String[1];
                        NALibs.getLicenseInfoNA(data);
                        if (data[0] != null) {
                            setText(tv_LicenseInfo, "License Info: " + data[0]);
                        }
                        setText(tv_Result, iRes + ": License has been successfully updated.");
                    } else if (iRes == 100 || iRes == 101 || iRes == 102 || iRes == 103) {
                        setText(tv_Result, iRes + ": The latest license has already been installed.");
                    }

                    setEnableButton(true, true, true, true);
                    break;
                }
            }
        }




    }




}
