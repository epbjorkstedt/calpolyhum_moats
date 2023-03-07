package gov.noaa.nwfsc.watchNoFileUpdate;


import java.awt.Component;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;


public class WatchNoUpdateFrame extends JFrame implements ActionListener{
	private GridBagConstraints gbc;
	private DirPathPanel dirPathPanel;
	private FilePathPanel outPanel;
	private JButton startButton;
	private WatchDir watchDir;
	private ValuePanel waitPanel;
	private ValuePanel chamberPanel;
	private String defaultWatchFolderPath = "C:\\chamber_data";
	private String defaultAlarmFilePath = "C:\\alarm_files\\LV stopped";
	private String defaultWatchDelay = "240";
	private String defaultInstrument = "Chamber X";
	
	public WatchNoUpdateFrame() {
		System.out.println("Opening No-Update Watch Alarm Program");
		this.setSize(new Dimension(800, 300));
	    this.setTitle("Watch if no update");
	    this.setLayout(new GridBagLayout());
		gbc = new GridBagConstraints();
		gbc.weightx = 100;
		gbc.weighty = 100;
		
		dirPathPanel = new DirPathPanel();
		this.add(dirPathPanel,0,0,1,1);
		dirPathPanel.setText(defaultWatchFolderPath);
		waitPanel = new ValuePanel("If no file updates within this time, send alarm (Seconds)");
		waitPanel.setValueText(defaultWatchDelay);
		this.add(waitPanel,0,1,1,1);
		
		chamberPanel = new ValuePanel("Instrument ID (e.g 'Chamber 05' or 'MOATS 11')");
		chamberPanel.setValueText(defaultInstrument);
		this.add(chamberPanel,0,2,1,1);
		
		outPanel = new FilePathPanel("Alarm File", false, false);
		outPanel.setText(defaultAlarmFilePath);
		this.add(outPanel,0,3,1,1);
		
		startButton = new JButton("Start");
		startButton.addActionListener(this);
		this.add(startButton,0,4,1,1);
	}
	
	private void add(Component c, int x, int y, int w, int h){
		gbc.gridx = x;
		gbc.gridy = y;
		gbc.gridwidth = w;
		gbc.gridheight = h;
		this.add(c, gbc);
	}
	
	public void actionPerformed(ActionEvent e) {		
		Object source = e.getSource();
		if(source == startButton){
			String outPath = outPanel.getPath() + " " +  chamberPanel.getText();
			Path dir = Paths.get(dirPathPanel.getPath());
			System.out.println("Running No-Update Watch Alarm Program");
			try {
				watchDir = new WatchDir(dir, false);
				watchDir.processEvents(waitPanel.getInt(), outPath, chamberPanel.getText());
				System.out.println("No-Update Watch Alarm tripped");
				JOptionPane.showMessageDialog(this,
					    "Labview stopped writting output files.\nFix the Labview problem, then restart the alarm program.");
			}
			catch (IOException x) {
                System.out.println(x);
            }	
		}
	}
}
