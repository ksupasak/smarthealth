package com.example.smart_health
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "esm.flutter.dev/idcard"

    private val reader :CardReader


    init{


        reader =   CardReader(this);

    }
    private fun initReader(): Int {
        val result: Int



        result = 99;

        return result
    }

    private fun read(): String {
        val result: String

        reader.read();

        result = "3840100269238";
        NativeMethodChannel.showNewIdea("3840100269238");
        return result
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeMethodChannel.configureChannel(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            // This method is invoked on the main thread.
            // TODO
            if (call.method == "init") {
                val it = initReader()
                result.success(it)

            } else
            if (call.method == "read") {
                val it = read()
                result.success(it)

            } else{
                result.notImplemented()
            }
        }
    }



}
