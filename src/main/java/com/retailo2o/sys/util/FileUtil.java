package com.retailo2o.sys.util;

import java.io.File;
import java.io.IOException;


public class FileUtil {

    public static File createFile(String path, String fileName) {
        File f = new File(path);
        if (!f.exists()) {
            f.mkdirs();
        }
        File file = new File(path, fileName);
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException ignored) {
            }
        }
        return file;
    }
}
