package gov.noaa.nwfsc.watchNoFileUpdate;

import java.nio.file.*;
import static java.nio.file.StandardWatchEventKinds.*;
import static java.nio.file.LinkOption.*;
import java.nio.file.attribute.*;
import java.text.SimpleDateFormat;
import java.io.*;
import java.util.*;
import java.util.concurrent.TimeUnit;

import javax.swing.JOptionPane;

/**
 * Example to watch a directory (or tree) for changes to files.
 */

public class WatchDir {

    private final WatchService watcher;
    private final Map<WatchKey,Path> keys;
    private final boolean recursive;
    private boolean trace = false;

    @SuppressWarnings("unchecked")
    static <T> WatchEvent<T> cast(WatchEvent<?> event) {
        return (WatchEvent<T>)event;
    }

    /**
     * Register the given directory with the WatchService
     */
    private void register(Path dir) throws IOException {
        WatchKey key = dir.register(watcher, ENTRY_CREATE, ENTRY_DELETE, ENTRY_MODIFY);
        if (trace) {
            Path prev = keys.get(key);
            if (prev == null) {
                System.out.format("register: %s\n", dir);
            } else {
                if (!dir.equals(prev)) {
                    System.out.format("update: %s -> %s\n", prev, dir);
                }
            }
        }
        keys.put(key, dir);
    }

    /**
     * Register the given directory, and all its sub-directories, with the
     * WatchService.
     */
    private void registerAll(final Path start) throws IOException {
        // register directory and sub-directories
        Files.walkFileTree(start, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
                throws IOException
            {
                register(dir);
                return FileVisitResult.CONTINUE;
            }
        });
    }

    /**
     * Creates a WatchService and registers the given directory
     */
    WatchDir(Path dir, boolean recursive) throws IOException {
        this.watcher = FileSystems.getDefault().newWatchService();
        this.keys = new HashMap<WatchKey,Path>();
        this.recursive = recursive;

        if (recursive) {
            System.out.format("Scanning %s ...\n", dir);
            registerAll(dir);
            System.out.println("Done.");
        } else {
            register(dir);
        }

        // enable trace after initial registration
        this.trace = true;
    }

    /**
     * Process all events for keys queued to the watcher
     */
    void processEvents(int waitSeconds, String alarmFilePath, String instID) {
        for (;;) {

            // wait for key to be signalled
            WatchKey key;
            try {
                key = watcher.poll(waitSeconds, TimeUnit.SECONDS);
            } catch (InterruptedException x) {
                return;
            }

            Path dir = keys.get(key);
            if (dir == null) {
                //System.err.println("WatchKey not recognized!!");
            		WriteAlarmFile(alarmFilePath, instID);
                //continue;
                break;
            }
            
            for (WatchEvent<?> event: key.pollEvents()) {  
            }
			
            // reset key and remove from set if directory no longer accessible
            boolean valid = key.reset();
            if (!valid) {
                keys.remove(key);

                // all directories are inaccessible
                if (keys.isEmpty()) {
                    break;
                }
            }
        }
    }
    
    private void WriteAlarmFile(String path, String instID) {
    		String timeStamp = new SimpleDateFormat("yyyy-MM-dd_HH.mm.ss").format(Calendar.getInstance().getTime());
    		String outPath = path + " " + timeStamp + ".txt";
    		PrintWriter outStream;
		String message = instID + " has stopped writing output data.";
		try{
			outStream = new PrintWriter(new FileWriter(outPath));
			outStream.println(message);
			outStream.close();
		}
		catch(Exception e){
			System.out.println("Error: " + e);
		}
    }
}
