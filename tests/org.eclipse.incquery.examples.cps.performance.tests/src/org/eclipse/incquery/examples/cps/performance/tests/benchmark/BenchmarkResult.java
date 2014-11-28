package org.eclipse.incquery.examples.cps.performance.tests.benchmark;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class BenchmarkResult {

	// CONFIGS
	private boolean isGeneratingHeader = true;
	private int artifactSize = 0;
	private int seriesCount = -1; // alapból -1 de ha többször futtatjuk akkro lehet magasabb
	private Integer nMax = 2; // modify cycles
	
	public void setArtifactSize(int size){
		artifactSize = size;
	}
	
	
	
	
	protected String tool;
	protected String query;
	protected String scenario = "";
	protected String benchmarkArtifact = "undef";

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	protected Long nElemToModifySum = new Long(-1L);
	protected List<Long> nElemToModify = new ArrayList<Long>();

	protected Long readTime = new Long(-1L);

	protected Long checkTimeSum = new Long(-1L);
	protected List<Long> checkTime = new ArrayList<Long>();

	protected Long modificationTimeSum = new Long(-1L);
	protected List<Long> modificationTime = new ArrayList<Long>();

	protected Long editTimeSum = new Long(-1L);
	protected List<Long> editTime = new ArrayList<Long>();

	protected List<Long> checkInvalid = new ArrayList<Long>();

	protected List<Long> memoryBytes = new ArrayList<Long>();

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	protected Random random;
	
	


	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONSTRUCTOR

	public BenchmarkResult(final String tool, final String query, Random random) {
		this.tool = tool;
		this.query = query;
		this.random = random;
	}

	

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// @formatter:off
	@Override
	public String toString() {

		ResultStringBuilder rsb = ResultStringBuilder
				.builder()
				.append("NMeas", seriesCount)
				.append("Tool", tool)
				.append("Query", query)
				.append("Scenario", scenario)
				.append("File", benchmarkArtifact)
				.append("Size", artifactSize )
				.append("NOfModifications", nElemToModifySum)
				.append("Read", readTime)
				.append("Check0", (checkTime.size() > 0 ? checkTime.get(0) : "-1"))
				.append("SumModify", modificationTimeSum)
				.append("SumReCheck", (checkTime.size() > 1 ? checkTimeSum - checkTime.get(0) : "-1"))
				.append("SumEdit", editTimeSum)
				.append("ResultSize1", (checkInvalid.size() > 0 ? checkInvalid.get(0) : "-1"))
				.append("ResultSizeN", (checkInvalid.size() > 1 ? checkInvalid.get(checkInvalid.size() - 1) : "-1"))
				.append("Memory", memoryBytes.get(memoryBytes.size() - 1) / 1024)
				.appendGroup("Check", ResultStringBuilder.builder()
						.setN(nMax)
						.appendList("Check", checkTime)
				.appendGroup("Edit", ResultStringBuilder.builder()
						.setN(nMax)
						.appendList("Edit", editTime)
				.appendGroup("Invalid", ResultStringBuilder.builder()
						.setN(nMax)
						.appendList("Invalid", checkInvalid)
						)));
		
		rsb.appendGroup("END", ResultStringBuilder.builder());
		
		String result = "";
		
		if (isGeneratingHeader) {
			result += rsb.getHeader().trim() + "\n";
		}
		
		result += rsb.toString().trim();

		
		return result;
	}
	// @formatter:on

	public static double round(final double unrounded, final int precision,
			final int roundingMode) {
		final BigDecimal bd = new BigDecimal(unrounded);
		final BigDecimal rounded = bd.setScale(precision, roundingMode);
		return rounded.doubleValue();
	}

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STOPPER

	long startTime;


	public void startStopper() {
		startTime = System.nanoTime();
	}


	public void setReadTime() {
		setReadTime(System.nanoTime() - startTime);
	}


	public void setReadTime(final long readTime) {
		this.readTime = readTime;
	}


	public void addCheckTime() {
		addCheckTime(System.nanoTime() - startTime);
	}


	public void addCheckTime(final long time) {
		if (checkTimeSum == -1L) {
			checkTimeSum = 0L;
		}
		checkTimeSum += time;
		this.checkTime.add(new Long(time));
	}


	public void addInvalid() {
		addInvalid(System.nanoTime() - startTime);
	}


	public void addInvalid(final long invalids) {
		this.checkInvalid.add(new Long(invalids));
	}


	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GETTERS & SETTERS

	// ________________________________________________________ BenchmarkConfig

	public String getQuery() {
		return query;
	}


	// ______________________________________________________ benchmarkArtifact
	@Deprecated
	public String getFileName() {
		return benchmarkArtifact;
	}


	@Deprecated
	public void setFileName(final String fileName) {
		this.benchmarkArtifact = fileName;
	}


	public String getBenchmarkArtifact() {
		return benchmarkArtifact;
	}


	public void setBenchmarkArtifact(String benchmarkArtifact) {
		this.benchmarkArtifact = benchmarkArtifact;
	}


	// _______________________________________________________________ scenario
	public String getScenario() {
		return scenario;
	}


	public void setScenario(final String scenario) {
		this.scenario = scenario;
	}


	// _______________________________________________________________ readTime
	public Long getReadTime() {
		return readTime;
	}


	// ______________________________________________________________ checkTime
	public List<Long> getCheckTimes() {
		return checkTime;
	}


	// _______________________________________________________________ invalids
	public List<Long> getInvalids() {
		return checkInvalid;
	}


	// _______________________________________________________ modificationTime
	public List<Long> getModificationTimes(final int index) {
		return modificationTime;
	}


	public void addModificationTime() {
		addModificationTime(System.nanoTime() - startTime);
	}


	public void addModificationTime(final long modificationTime) {
		if (modificationTimeSum == -1L) {
			modificationTimeSum = 0L;
		}
		modificationTimeSum += modificationTime;
		this.modificationTime.add(new Long(modificationTime));
	}


	// _______________________________________________________________ editTime
	public List<Long> getEditTimes() {
		return editTime;
	}


	public void addEditTime() {
		addEditTime(System.nanoTime() - startTime);
	}


	public void addEditTime(final long editTime) {
		if (editTimeSum == -1L) {
			editTimeSum = 0L;
		}
		editTimeSum += editTime;
		this.editTime.add(new Long(editTime));
	}


	// ____________________________________________________________ memoryBytes
	public List<Long> getMemoryBytes() {
		return memoryBytes;
	}


	public void addMemoryBytes(final long memoryBytes) {
		this.memoryBytes.add(new Long(memoryBytes));
	}


	// __________________________________________________________ nElemToModify
	public List<Long> getModifyParams() {
		return nElemToModify;
	}


	public void addModifyParams(final long nElemToModify) {
		if (nElemToModifySum == -1L) {
			nElemToModifySum = 0L;
		}
		nElemToModifySum += nElemToModify;
		this.nElemToModify.add(new Long(nElemToModify));
	}


	public long getModifyParamsSum() {
		return nElemToModifySum;
	}


	// _________________________________________________________________ random
	public Random getRandom() {
		return random;
	}


	public void setRandom(final Random random) {
		this.random = random;
	}


	// _____________________________________________________________ deprecated
	@Deprecated
	protected void setMemoryBytes(final int index, final long memoryByte) {
		if (this.memoryBytes.size() != index - 1) {
			throw new RuntimeException("MemoryBytes only has "
					+ memoryBytes.size() + " values.");
		}

		this.memoryBytes.set(index - 1, memoryByte);
	}


	// memory2
	@Deprecated
	public Long getMemoryBytes2() {
		// return memoryBytes2;
		return memoryBytes.get(2);
	}


	@Deprecated
	public void setMemoryBytes2(final long memoryBytes2) {
		// this.memoryBytes2 = memoryBytes2;
		setMemoryBytes(2, memoryBytes2);
	}


	// memory3
	@Deprecated
	public Long getMemoryBytes3() {
		// return memoryBytes3;
		return memoryBytes.get(3);
	}


	@Deprecated
	public void setMemoryBytes3(final int index, final long memoryBytes3) {
		// this.memoryBytes2 = memoryBytes2;
		setMemoryBytes(2, memoryBytes3);
	}

	// ========================================================================

	protected static class ResultStringBuilder {

		protected static final String DEFAULT_SEPARATOR = " ";
		protected static final String GROUP_SEPARATOR = " ! ";
		protected static final String INVALID = "-1";
		
		protected Integer n;

		protected StringBuilder builder = new StringBuilder();
		protected StringBuilder header = new StringBuilder();


		public static ResultStringBuilder builder() {
			return new ResultStringBuilder();
		}


		public ResultStringBuilder append(String columnHeader, Object object) {
			return append(columnHeader, object.toString());
		}


		public ResultStringBuilder append(String columnHeader, String string) {
			
			if (header.length() != 0) {
				header.append(DEFAULT_SEPARATOR);
			}

			header.append(columnHeader);
			
			// --------- ^ HEADER -------- v CONTENT --------------------------

			if (builder.length() != 0) {
				builder.append(DEFAULT_SEPARATOR);
			}

			builder.append(string);

			return this;
		}


		public ResultStringBuilder appendGroup(String groupName, ResultStringBuilder group) {
			
			if (header.length() != 0) {
				header.append(DEFAULT_SEPARATOR);
			}

			header.append("SEP_" + groupName + DEFAULT_SEPARATOR);
			header.append(group.getHeader());
			
			// --------- ^ HEADER -------- v CONTENT --------------------------

			if (builder.length() != 0) {
				builder.append(GROUP_SEPARATOR);
			}

			builder.append(group.toString());

			return this;
		}


		private ResultStringBuilder setN(Integer n) {
			this.n = n;
			return this;
		}


		public <T> ResultStringBuilder appendList(String listName, List<T> list) {
			int listSize = list.size();
			int maxSize = (n == null) ? listSize : n;

			for (int i = 0; i < maxSize; i++) {
				this.append(listName + "_" + i, (i < listSize) ? list.get(i) : INVALID);
			}

			return this;
		}


		@Override
		public String toString() {
			return builder.toString();
		}
		
		public String getHeader() {
			return header.toString();
		}

	}

}
