package cn.com.zjol;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Looper;
import android.util.Log;

import com.zjrb.core.utils.AppManager;
import com.zjrb.core.utils.UIUtils;

import java.io.PrintWriter;
import java.io.StringWriter;

import cn.com.zjol.biz.core.ui.toast.ZBToast;


/**
 * @author: lujialei
 * @date: 2019/5/15
 * @describe:应用崩溃监测类
 */


public class CrashHandler implements Thread.UncaughtExceptionHandler {

    private static final String TAG = "CrashHandler";
    private static CrashHandler sInstance = new CrashHandler();

    private Context mContext;

    private CrashHandler() {
    }

    public static CrashHandler getInstance() {
        return sInstance;
    }

    public void init(Context context) {
        mContext = context;
        Thread.setDefaultUncaughtExceptionHandler(this);
    }

    /**
     * 目前崩溃后只会打印日志并且退出App
     *
     * @param thread
     * @param throwable
     */
    @Override
    public void uncaughtException(Thread thread, Throwable throwable) {

        if (UIUtils.isDebuggable()) {
            throwable.printStackTrace();
            String message = getStackTrace(throwable);
            ClipboardManager cm = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData mClipData = ClipData.newPlainText("Label", message);
            cm.setPrimaryClip(mClipData);

            new Thread() {
                @Override
                public void run() {
                    Looper.prepare();
//                    Toast.makeText(mContext, "应用已奔溃，奔溃信息已放入剪切板", Toast.LENGTH_LONG).show();
                    ZBToast.showByType(mContext,"应用已奔溃\n奔溃信息已\n放入剪切板", ZBToast.TYPE_3);
                    Looper.loop();
                }
            }.start();


            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                Log.e(TAG, "InterruptedException", e);
            }
        }

        //退出程序
        AppManager.get().finishAllActivity();
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(0);
    }

    public static String getStackTrace(Throwable throwable) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        try {
            throwable.printStackTrace(pw);
            return sw.toString();
        } finally {
            pw.close();
        }
    }
}

